class Api::V1::UsersController < ApplicationController
    # only for testing purposes
    def index
        @users = User.all
        render json: @users., status: :ok
    end
    
    # return current user for profile route
    def show

    end

    # create a user from a hash being passed through params from frontend 
    def create

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