class LogsController < ::ApplicationController
  before_action :authenticate_user!

  def index
    @page = ::LogsPage.new(params[:page])
  end
end
