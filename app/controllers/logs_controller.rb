class LogsController < ::ApplicationController
  before_action :authenticate_user!

  def index
    @logs = ::HouseLog.order(created_at: :desc).page(params[:page]).all
  end
end
