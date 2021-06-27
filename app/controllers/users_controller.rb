class UsersController < ::ApplicationController
  before_action :authenticate_user!

  def index
    @users = ::User.all
  end

  def destroy
    ::User.find(params[:id]).destroy

    redirect_to users_path
  end
end
