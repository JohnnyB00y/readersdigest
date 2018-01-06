class UsersController < ApplicationController
  def show
  	@users = user.find(params[:id])
  end
end
