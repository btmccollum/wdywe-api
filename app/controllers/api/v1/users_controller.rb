class Api::V1::UsersController < ApplicationController
    # only for testing purposes
    def index
        @users = User.all
        render json: @users, status: :ok
    end
    
    # return current user for profile route
    def show

    end

    # create a user from a hash being passed through params from frontend 
    def create
        user = User.new(user_params)

        if user.save 
            jwt = Auth.encrypt({id: user.id})
            render json: { user: user, jwt: jwt }, status: :ok
        else
            render json: { errors: user.errors.full_messages }, status: 400
        end
    end

    # def edit  

    # end

    # def destroy

    # end

    private

    def user_params
        params.require(:user).permit(
          :username,
          :email,
          :password,
          :password_confirmation,
          :zipcode,
        )
    end
end