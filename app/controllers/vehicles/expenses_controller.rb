module Vehicles
  class ExpensesController < ::ApplicationController
    before_action :authenticate_user!

    def new
      @page = ::Vehicles::ExpensesPage.new(params[:vehicle_id])
      @expense = ::Expense.new
    end

    def create
      @page = ::Vehicles::ExpensesPage.new(params[:vehicle_id])
      @expense = ::Datastorage::Creators::VehicleExpense.new(params[:vehicle_id], expense_params).create

      if @expense.valid?
        redirect_to copart_lot_path(@page.lot_id)
      else
        render "new"
      end
    end

    private

    def expense_params
      params.require(:expense).permit(:amount, :description, :expense_type, :refundable, :refunded)
    end
  end
end
