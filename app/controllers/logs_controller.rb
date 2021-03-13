class LogsController < ::ApplicationController
  before_action :authenticate_user!, :enable_house_log_channel

  def enable_house_log_channel
    enable_channel(:house_log)
  end

  def index
    @page = ::LogsPage.new(params[:page])
  end
end
