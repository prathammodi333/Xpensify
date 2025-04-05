class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
    @inviter_id = params[:inviter_id]
  end

  def create
    @user = User.new(user_params)
    @inviter_id = params[:inviter_id] # Retrieve inviter_id

    if @user.save
      session[:user_id] = @user.id

      # If the user was invited, add them to the inviter's friend list
      if @inviter_id
        inviter = User.find_by(id: @inviter_id)
        if inviter
          Friendship.create(user: @user, friend: inviter)
          Friendship.create(user: inviter, friend: @user)
          flash[:notice] = "You are now friends with #{inviter.name}!"
        end
      end

      # Automatically join the group after successful sign-up
      if session[:pending_group_invite_token].present?
        group = Group.find_by(invite_token: session.delete(:pending_group_invite_token))
        if group && !group.users.include?(@user)
          GroupMembership.create(user: @user, group: group)
          group.users.each do |member|
            next if member == @user  # Skip adding themselves as a friend
            unless @user.all_friends.include?(member)
              Rails.logger.debug "Creating friendship between #{@user.name} and #{member.name}"
              Friendship.create(user: @user, friend: member) unless Friendship.exists?(user: @user, friend: member)
              Friendship.create(user: member, friend: @user) unless Friendship.exists?(user: member, friend: @user)
            end
          end
          flash[:notice] ||= "You have successfully joined the group!"
          else
        flash[:alert] = "Invalid invite link."
        end
      end

      redirect_to dashboard_path, notice: flash[:notice] || "Account created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  

  def edit
    # renders edit form
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "Account updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user # Ensures users only edit their own profile
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
