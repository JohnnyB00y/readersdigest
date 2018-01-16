class RelationshipsController < ApplicationController
  def follow_user
    @user = User.find(params[:user_id])
    if current_user.follow @user.id
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { head :ok }
      end
    end
  end

  def unfollow_user
    @user = User.find_by! id: params[:user_id]
    if current_user.unfollow @user.id
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { head :ok }
      end
    end
  end
end