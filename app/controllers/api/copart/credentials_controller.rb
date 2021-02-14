module Api
  module Copart
    class CredentialsController < ::Api::ApplicationController
      def index
        username = Rails.application.credentials.copart[:username]
        password = Rails.application.credentials.copart[:password]

        render json: { username: username, password: password }
      end
    end
  end
end
