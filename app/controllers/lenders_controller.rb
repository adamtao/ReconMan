class LendersController < ApplicationController
  before_action :set_lender, only: [:show, :edit, :update, :destroy]

  def index
    @lenders = Lender.order(:name)
  end

  def show
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
  end

  def update
    if @lender.update_attributes(lender_params)
      redirect_to @lender, notice: "Lender updated successfully."
    else
      render action: 'edit'
    end
  end

  def destroy
    @lender.destroy
    respond_to do |format|
      format.html { redirect_to lenders_url, notice: 'Lender was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_lender
    @lender = Lender.find(params[:id])
  end

  def lender_params
    params.require(:lender).permit(:name)
  end
end
