require 'rails_helper'

RSpec.describe Api::V1::RecommendationsController, type: :controller do 

    before do 
        @parameters = { 
                "term"=>"bbq",
                "location"=>"fort worth",
                "radius"=>"30000", 
                "limit"=> "100",
                "open_now"=>"true"
        }
    end

    describe 'search_data' do
        context 'when generating search query from params' do
            it 'returns a usable hash from param data' do
                test_response = controller.send(:search_query, @parameters)

                expect (test_response.keys).to include("term", "location", "radius", "limit", "open_now")
                expect (test_response).to match({
                    "term"=> "bbq",
                    "location"=> "fort worth",
                    "radius"=> "30000",
                    "limit"=> "100",
                    "open_now"=>"true"
                })
            end
        end
    end

    # describe 'POST #random_suggestion' do
    #     context 'when asking for a guided suggestion' do
    #         it 'creates a search_data object from params' do
    #             post 'random_suggestion', :params => @parameters

    #             hash_body = nil
            
    #             expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
    #             expect(hash_body.keys).to include("term", "location", "radius", "limit", "open_now")
    #             expect(hash_body).to match({
    #                 "term"=> "bbq",
    #                 "location"=> "fort worth",
    #                 "radius"=> "30000",
    #                 "limit"=> "100",
    #                 "open_now"=>"true"
    #             })
    #         end
    #     end
    # end

end