class ApplicationController < ActionController::API
    include ::ActionController::Cookies
    include ActionController::MimeResponds

    # before_action :authenticate

    def current_user
        if auth_present?
            user = User.find(auth["id"])
            if user
                @current_user ||= user
            end
        end
    end

    def authenticate    
        render json: {errors: "Unauthorized user."}, status: 401 unless current_user
    end

    private

        def token
            request.env["HTTP_AUTHORIZATION"].scan(/Bearer (.*)$/).flatten.last
        end

        def auth
            Auth.decode(token)
        end

        def auth_present?
            if request.env["HTTP_AUTHORIZATION"]
                !!request.env["HTTP_AUTHORIZATION"].scan(/Bearer (.*)$/).flatten.last
            end
        end

        def user_hash(json)
            eval(json)[:user]
        end      
end