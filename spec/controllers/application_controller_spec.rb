require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do 

    before(:each) do
        @params = {
            "username"=>"test01",
            "email"=>"test01@test.com",
            "password"=>"123456", 
            "password_confirmation"=> "123456",
            "zipcode"=>"12345"
        }   
        @user = User.create(@params)
    end

    describe 'authenticate' do 
        context 'when application is being accessed' do
            it "returns 401 when unauthorized user tries to access" do
                test_response = controller.send(:current_user)

                expect(test_response).to be(true)
            end
        end
    end
end
