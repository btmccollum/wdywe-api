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

            it 'it creats a User with JWT token' do
                post :create, params: @parameters

                expect(response.body).to include("jwt")
                expect(response.status).to be(200)
            end

            it 'successfully creates a User and accompanying JWT token' do
                post :create, params: @parameters

                user = JSON.parse(response.body)                
                id_hash = Auth.decode(user["jwt"])

                expect(user).to include("jwt")
                expect(id_hash["id"]).to eq(user["user"]["id"])
            end

            it 'does not persist a User if passwords dont match' do
                @parameters["user"]["password_confirmation"] = "1234567"

                post :create, params: @parameters

                expect(response.status).to be(400)
                expect(response.body).to include("Password confirmation doesn't match Password")
            end
        end
    end


end
