class ZipcodesController < ApplicationController

	respond_to :json

  def show
    @zipcode = Zipcode.lookup(params[:id].gsub(/\-\d*/, ''))
    respond_with @zipcode
  end

end
