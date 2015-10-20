class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.leaders
  end

  def create
    user = User.find(params[:id])

    if current_user.follow(user).save
      flash[:success] = "You have followed #{user.full_name}"

      redirect_to people_path
    else
      flash[:danger] = "You are already following #{user.full_name}."

      redirect_to user
    end
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    flash[:info] = "You have unfollowed #{user.full_name}"

    redirect_to people_path
  end
end
