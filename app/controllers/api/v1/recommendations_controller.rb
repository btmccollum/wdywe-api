class Api::V1::RecommendationsController < ApplicationController
    def random_suggestion
        # sanitize query data to be used for API call from params
        query = search_query(params)
        search_results = yelp_business_search(query)

        # pull random element from search results to return to user as suggestion
        suggestion = search_results["businesses"].sample
        render json: suggestion
    end

    # guided suggestion based on user selected preferences and selected attributes 
    def guided_suggestion
        query = search_query(params)
        results = yelp_business_search(query)
        # need to take results and filter them down to a single recommendation to be returned:

        render json: results
    end

    private

        # --- YELP API CALLS, v3 REFERENCE 4/18/18 ---
            # 5,000 daily calls permitted ***IMPORTANT

            #   https://www.yelp.com/developers/documentation/v3/business_search
            # term	        string	Optional. Search term, for example "food" or "restaurants". The term may also be business names, such as "Starbucks". If term is not included the endpoint will default to searching across businesses from a small number of popular categories.
            # location	    string	Required if either latitude or longitude is not provided. This string indicates the geographic area to be used when searching for businesses. Examples: "New York City", "NYC", "350 5th Ave, New York, NY 10118". Businesses returned in the response may not be strictly within the specified location.
            # latitude	    decimal	Required if location is not provided. Latitude of the location you want to search nearby.
            # longitude	    decimal	Required if location is not provided. Longitude of the location you want to search nearby.
            # radius	    int	    Optional. A suggested search radius in meters. This field is used as a suggestion to the search. The actual search radius may be lower than the suggested radius in dense urban areas, and higher in regions of less business density. If the specified value is too large, a AREA_TOO_LARGE error may be returned. The max value is 40000 meters (about 25 miles).
            # categories	string	Optional. Categories to filter the search results with. See the list of supported categories. The category filter can be a list of comma delimited categories. For example, "bars,french" will filter by Bars OR French. The category identifier should be used (for example "discgolf", not "Disc Golf").
            # locale	    string	Optional. Specify the locale into which to localize the business information. See the list of supported locales. Defaults to en_US.
            # limit	        int	    Optional. Number of business results to return. By default, it will return 20. Maximum is 50.
            # offset	    int	    Optional. Offset the list of returned business results by this amount.
            # sort_by	    string	Optional. Suggestion to the search algorithm that the results be sorted by one of the these modes: best_match, rating, review_count or distance. The default is best_match. Note that specifying the sort_by is a suggestion (not strictly enforced) to Yelp's search, which considers multiple input parameters to return the most relevant results. For example, the rating sort is not strictly sorted by the rating value, but by an adjusted rating value that takes into account the number of ratings, similar to a Bayesian average. This is to prevent skewing results to businesses with a single review.
            # price	        string	Optional. Pricing levels to filter the search result with: 1 = $, 2 = $$, 3 = $$$, 4 = $$$$. The price filter can be a list of comma delimited pricing levels. For example, "1, 2, 3" will filter the results to show the ones that are $, $$, or $$$.
            # open_now	    boolean	Optional. Default to false. When set to true, only return the businesses open now. Notice that open_at and open_now cannot be used together.
            # open_at       int	    Optional. An integer represending the Unix time in the same timezone of the search location. If specified, it will return business open at the given time. Notice that open_at and open_now cannot be used together.
            # attributes    string  Optional. Try these additional filters to return specific search results!
                        # hot_and_new - popular businesses which recently joined Yelp
                        # request_a_quote - businesses which actively reply to Request a Quote inquiries
                        # reservation - businesses with Yelp Reservations bookings enabled on their profile page
                        # waitlist_reservation - businesses with Yelp Waitlist bookings enabled on their profile screen (iOS/Android)
                        # cashback - businesses offering Yelp Cash Back to in-house customers
                        # deals - businesses offering Yelp Deals on their profile page
                        # gender_neutral_restrooms - businesses which provide gender neutral restrooms
                        # open_to_all - businesses which are Open To All
                        # wheelchair_accessible - businesses which are Wheelchair Accessible
            #     You can combine multiple attributes by providing a comma separated like "attribute1,attribute2". If multiple attributes are used, only businesses that satisfy ALL attributes will be returned in search results. For example, the attributes "hot_and_new,cashback" will return businesses that are Hot and New AND offer Cash Back.

        # random suggestion returned to user based on documented preferences only
        # building query hash that will be used for API call to Yelp
        def search_query(params)
            search_data = {}.tap do |data|
                data[:term] = params["term"] if params["term"]
                data[:location] = params["location"] if params["location"]
                data[:latitude] = params["latitude"] if params["latitude"]
                data[:longitude] = params["longitude"] if params["longitude"]
                data[:radius] = params["radius"] if params["radius"]
                data[:categories] = params["categories"] if params["categories"]
                data[:limit] = params["limit"] if params["limit"] ||= "100"
                data[:sort_by] = params["sort_by"] if params["sort_by"]
                data[:price] = params["price"] if params["price"]
                data[:open_now] = params["open_now"] if params["open_now"]
                data[:open_at] = params["open_at"] if params["open_at"]
                data[:attributes] = params["attributes"] if params["attributes"]
            end
        end

        # reusable method for business search calls
        def yelp_business_search(search_data)
            # limit of 1000 results per call
            conn = Faraday.new(:url => "https://api.yelp.com/v3/businesses/search")

            biz_results = conn.get do |req|
                    req.headers['Authorization'] = "Bearer " + ENV['YELP_SECRET']
                    req.headers['User-Agent'] = "wdywe-api"
                    search_data.each {|key, value| req.params["#{key}"] = "#{value}"}
            end

            biz_hash = JSON.parse(biz_results.body)
            return biz_hash
        end
end