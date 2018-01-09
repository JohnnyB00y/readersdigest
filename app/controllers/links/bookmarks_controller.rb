class Links::BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link

  def create
    @link.bookmarks.where(user_id: current_user.id).first_or_create

    respond_to do |format|
      format.html { redirect_to @link }
      format.js
    end
  end

  def destroy
    @link.bookmarks.where(user_id: current_user.id).destroy_all

    respond_to do |format|
      format.html { redirect_to @link }
      format.js
    end
  end

  private

    def set_link
      @link = Link.find(params[:link_id])
    end
end