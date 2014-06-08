class FoundersController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def create
  	@founder = founder.new
  end

  def new
  	@founder = founder.new(params[:founder])
  end
  
end
