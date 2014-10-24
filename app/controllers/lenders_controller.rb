class LendersController < ApplicationController

  def index
    @lenders = Lender.order(:name)
  end

  def show
    @lender = Lender.find(params[:id])
  end

  def new
    @lender = Lender.new
  end

  def create
    @lender = Lender.new(lender_params)
    if @lender.save
      redirect_to @lender, notice: "Lender created successfully."
    else
      render action: 'new'
    end
  end

  def edit
    @lender = Lender.find(params[:id])
  end

  def update
    @lender = Lender.find(params[:id])
    if @lender.update_attributes(lender_params)
      redirect_to @lender, notice: "Lender updated successfully."
    else
      render action: 'edit'
    end
  end

  private

  def lender_params
    params.require(:lender).permit(:name)
  end
end
