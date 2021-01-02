class HomeController < ::ApplicationController
  before_action :authenticate_user!

  def index
    @message = "Hello World #{current_user.email}"
  end
end
