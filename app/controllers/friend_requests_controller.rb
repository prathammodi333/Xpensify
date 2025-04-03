class FriendRequestsController < ApplicationController
  before_action :require_login

  def create
    email = params[:email].downcase.strip
    recipient = User.find_by(email: email)
  
    if recipient
      # Send friend request email
      FriendRequestMailer.request_existing_user(current_user, recipient).deliver_later
  
      respond_to do |format|
        format.turbo_stream {
          flash.now[:notice] = "Friend request sent to #{recipient.name}"
          render turbo_stream: turbo_stream.append("notifications", partial: "shared/flash")
        }
        format.html { redirect_to dashboard_path, notice: "Friend request sent to #{recipient.name}" }
      end
    else
      # Handle invite flow (you already have this set up)
      FriendRequestMailer.invite_new_user(current_user, email).deliver_later
  
      respond_to do |format|
        format.turbo_stream {
          flash.now[:notice] = "Invitation sent to #{email}"
          render turbo_stream: turbo_stream.append("notifications", partial: "shared/flash")
        }
        format.html { redirect_to dashboard_path, notice: "Invitation sent to #{email}" }
      end
    end
  end
  
  def accept
    if current_user.nil?
      session[:pending_friend_request_sender_id] = params[:sender_id]
      redirect_to login_path, alert: "Please log in to accept the friend request."
      return
    end
  
    sender = User.find_by(id: params[:sender_id])
    if sender && !current_user.all_friends.include?(sender)
      Friendship.create(user: current_user, friend: sender)
      flash[:notice] = "You are now friends with #{sender.name}!"
    end
  
    redirect_to dashboard_path
  end
  
  
  private

  def require_login
    redirect_to login_path, alert: "Please log in first" unless logged_in?
  end
end
