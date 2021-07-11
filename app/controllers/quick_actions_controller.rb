class QuickActionsController < ::ApplicationController
  before_action :authenticate_user!

  def show
    @page = ::QuickActionsPage.new(params[:action_code])
  end
end
