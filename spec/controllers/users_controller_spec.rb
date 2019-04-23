require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do 
    before(:each) do
        @parameters = { "user" => {
            "username"=>"test01",
            "email"=>"test01@test.com",
            "password"=>"123456", 
            "password_confirmation"=> "123456",
            "zipcode"=>"12345"
            }   
        }
    end

    describe 'POST #create' do
        context 'when passed JSON data from front end' do
            it 'instantiates a User when required data is present and returns it' do
                post :create, params: @parameters

                expect(response.body).to include("id")
                expect(response.status).to be(200)
            end

            it 'does not persist a User if passwords dont match' do
                @params = {"user"=>{
                    "username"=>"test01",
                    "email"=>"test01@test.com",
                    "password"=>"123456", 
                    "password_confirmation"=> "1234567",
                    "zipcode"=>"12345"
                    }
                }

                post :create, params: @params

                expect(response.status).to be(400)
                expect(response.body).to include("Password confirmation doesn't match Password")
            end
        end
    end


end
