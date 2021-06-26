module Vehicles
  class ExpensesController < ::ApplicationController
    before_action :authenticate_user!, :load_page

    def new
      @expense = ::Expense.new(category: params[:category])
    end

    def create
      @expense = ::Datastorage::Creators::VehicleExpense.new(params[:vehicle_id], expense_params).create

      if @expense.errors.empty?
        redirect_to copart_lot_path(@page.lot_id)
      else
        render "new"
      end
    end

    def edit
      @expense = ::Datastorage::SimpleActions::VehicleExpense.new(params[:vehicle_id], params[:id]).find
    end

    def update
      @expense = ::Datastorage::Updaters::VehicleExpense.new(params[:vehicle_id], params[:id], expense_params).update

      if @expense.errors.empty?
        redirect_to copart_lot_path(@page.lot_id)
      else
        render "edit"
      end
    end

    def destroy
      ::Datastorage::SimpleActions::VehicleExpense.new(params[:vehicle_id], params[:id]).destroy

      redirect_to copart_lot_path(@page.lot_id)
    end

    private

    def load_page
      @page = ::Vehicles::ExpensesPage.new(params[:vehicle_id])
    end

    def expense_params
      params.require(:expense).permit(:amount, :description, :expense_type, :currency, :category)
    end
  end
end
