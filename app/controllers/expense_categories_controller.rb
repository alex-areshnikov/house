class ExpenseCategoriesController < ::ApplicationController
  before_action :authenticate_user!

  def index
    @categories = ExpenseCategory.all
  end

  def new
    @category = ExpenseCategory.new
  end

  def create
    @category = ExpenseCategory.create(expense_category_params)

    if @category.valid?
      redirect_to expense_categories_path
    else
      render "new"
    end
  end

  def destroy
    ExpenseCategory.find(params[:id]).destroy

    redirect_to expense_categories_path
  end

  private

  def expense_category_params
    params.require(:expense_category).permit(:name)
  end
end
