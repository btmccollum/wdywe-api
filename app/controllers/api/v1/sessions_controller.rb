class Api::v1::SessionsController < ApplicationController
    # skip_before_action :authenticate, only: %i[create login logout]

    # normal login flow - no OAuth
    def create 
        # credentials = user_hash(params[:body])
        # user_email = credentials[:email]
        # user_email.downcase!
        
        # user = User.find_by(email: user_email)
    
        # if user && user.valid_password?(credentials[:password])
        #     jwt = Auth.encrypt({id: user.id})

        #     render json: { current: user, preferences: user.preference_setting, jwt: jwt}
        # else
        #     render json: { error: 'Invalid Credentials.'}, status: 404
        # end
    end

    def logout
        # cookies.delete(:jwt)
        # render json: { user: 'removed' }, status: 200
    end

    private

    def generate_token
        Sysrandom.random_number(32)
    end
end