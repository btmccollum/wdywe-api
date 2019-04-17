class API::V1::RecommendationsController < ApplicationController
    def random
        conn = Faraday.new(:url => "https://api.yelp.com/v3/businesses/search")
        results = conn.get do |req|
                req.headers['Authorization'] = "Bearer " + ENV['YELP_SECRET']
                req.params['limit'] = 100
                req.params['term'] = 'new'
        end
    end
end