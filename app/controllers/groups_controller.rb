
# class GroupsController < ApplicationController
#   before_action :require_login, except: [:invite]
#   before_action :set_group, only: [:show, :generate_invite_token, :invite, :destroy, :add_member, :add_member_email]

#   def generate_invite_token
#     # Generate the invite token and update the group
#     @group.update(invite_token: @group.generate_invite_token)
#     redirect_to @group, notice: "Invite link generated!"
#   end



#  def invite
#   token = params[:token]  # Grab the token from the URL path

#   if logged_in?
#     # User is logged in, attempt to find the group using the invite token
#     @group = Group.find_by(invite_token: token)
# Rails.logger.debug "invte function called!!!"
#     if @group
#       # Successfully join the group
#       flash[:notice] = "You have successfully joined the group!😍"

#       # Add the current user to the group
#       GroupMembership.create(user: current_user, group: @group)
#       Rails.logger.debug "Group membership created after invite link"
#       # Add the user to the friend list of existing group members
#       @group.users.each do |member|
#         next if member == current_user  # Skip adding themselves as a friend
#         unless current_user.all_friends.include?(member)
#           puts "Creating friendship between #{current_user.name} and #{member.name}"
#           Friendship.create(user: current_user, friend: member) unless Friendship.exists?(user: current_user, friend: member)
#           Friendship.create(user: member, friend: current_user) unless Friendship.exists?(user: member, friend: current_user)
#         end
#       end

#       redirect_to @group
#     else
#       flash[:alert] = "Invalid invite link."
#       redirect_to root_path
#     end
#   else
#     # User is not logged in, save the token in the session and redirect to login page
#     session[:pending_group_invite_token] = token
#     redirect_to login_path, alert: "Please log in first to join the group."
#   end
# end
#   # Handle Group Creation
#   def create
#     @group = current_user.created_groups.build(group_params)
#     if @group.save
#       GroupMembership.create(user: current_user, group: @group)

#       respond_to do |format|
#         format.html { redirect_to @group, notice: "Group created successfully!" }
#         format.js
#       end
#     else
#       respond_to do |format|
#         format.html { redirect_to dashboard_path, alert: "Failed to create group." }
#         format.js
#       end
#     end
#   end

#   # Show Group
#   def show
#     @members = @group.users
#     @expenses = @group.expenses.includes(:paid_by)
#     @friends = current_user.all_friends - @members

#   end

#   # Destroy Group (Only allowed by creator)
#   def destroy
#     @group = Group.find(params[:id])

#     if @group.created_by == current_user.id
#       # Delete all associated memberships first
#       @group.group_memberships.destroy_all

#       # Then delete the group itself
#       @group.destroy
#       redirect_to dashboard_path, notice: "Group deleted successfully."
#     else
#       redirect_to dashboard_path, alert: "You are not authorized to delete this group."
#     end
#   end
#   # Send invitation email
#   def add_member_email
#     email = params[:email].downcase.strip

#     # Send the invitation email
#     FriendRequestMailer.invite_to_group(current_user, email, @group).deliver_now

#     # Flash message and redirect
#     # flash[:notice] = "An invitation has been sent to #{email}."
#     redirect_to group_path(@group), notice: "An invitation has been sent to #{email}" 
#   end
#   # Add Member to Group
#   def add_member
#     user = User.find(params[:user_id])

#     if @group.users.include?(user)

#       redirect_to group_path(@group), alert: "#{user.name} is already a member of the group."
#     else
#       GroupMembership.create(user: user, group: @group)
#       redirect_to group_path(@group), notice: "#{user.name} was added to the group!"
#       # Add user to the friend list of all existing group members (if not already a friend)
#       @group.users.each do |member|
#         next if member == user  # Skip adding themselves as a friend
#         unless user.all_friends.include?(member)
#           puts "Creating friendship between #{user.name} and #{member.name}"
#           Friendship.create(user: user, friend: member) unless Friendship.exists?(user: user, friend: member)
#           Friendship.create(user: member, friend: user) unless Friendship.exists?(user: member, friend: user)
#         end
#       end
#     end
#   end

#   private

#   def set_group
#     if params[:id].present?
#       @group = Group.find(params[:id])
#     elsif params[:token].present?
#       @group = Group.find_by(invite_token: params[:token])
#     end
#   end

#   def group_params
#     params.require(:group).permit(:name)
#   end

#   def require_login
#     redirect_to login_path, alert: "Please log in first" unless logged_in?
#   end
# end

class GroupsController < ApplicationController
  before_action :require_login, except: [:invite]
  before_action :set_group, only: [:show, :generate_invite_token, :invite, :destroy, :add_member, :add_member_email, :edit, :update]
  before_action :authorize_owner, only: [:edit, :update, :destroy] # Add for owner-only actions

  # ... existing actions ...

  def edit
    # @group is already set by set_group
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: "Group name updated successfully!"
    else
      render :edit, alert: "Failed to update group name."
    end
  end

  def generate_invite_token
    @group.update(invite_token: @group.generate_invite_token)
    redirect_to @group, notice: "Invite link generated!"
  end

  def invite
    token = params[:token]
    if logged_in?
      @group = Group.find_by(invite_token: token)
      Rails.logger.debug "invite function called!!!"
      if @group
        flash[:notice] = "You have successfully joined the group!😍"
        GroupMembership.create(user: current_user, group: @group)
        Rails.logger.debug "Group membership created after invite link"
        @group.users.each do |member|
          next if member == current_user
          unless current_user.all_friends.include?(member)
            puts "Creating friendship between #{current_user.name} and #{member.name}"
            Friendship.create(user: current_user, friend: member) unless Friendship.exists?(user: current_user, friend: member)
            Friendship.create(user: member, friend: current_user) unless Friendship.exists?(user: member, friend: current_user)
          end
        end
        redirect_to @group
      else
        flash[:alert] = "Invalid invite link."
        redirect_to root_path
      end
    else
      session[:pending_group_invite_token] = token
      redirect_to login_path, alert: "Please log in first to join the group."
    end
  end

  def create
    @group = current_user.created_groups.build(group_params)
    if @group.save
      GroupMembership.create(user: current_user, group: @group)
      respond_to do |format|
        format.html { redirect_to @group, notice: "Group created successfully!" }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to dashboard_path, alert: "Failed to create group." }
        format.js
      end
    end
  end

  def show
    @members = @group.users
    @expenses = @group.expenses.includes(:paid_by).order(created_at: :desc)
    @friends = current_user.all_friends - @members
  end

  def destroy
    # Authorization moved to before_action
    @group.group_memberships.destroy_all
    @group.destroy
    redirect_to dashboard_path, notice: "Group deleted successfully."
  end

  def add_member_email
    email = params[:email].downcase.strip
    FriendRequestMailer.invite_to_group(current_user, email, @group).deliver_now
    redirect_to group_path(@group), notice: "An invitation has been sent to #{email}"
  end

  def add_member
    user = User.find(params[:user_id])
    if @group.users.include?(user)
      redirect_to group_path(@group), alert: "#{user.name} is already a member of the group."
    else
      GroupMembership.create(user: user, group: @group)
      redirect_to group_path(@group), notice: "#{user.name} was added to the group!"
      @group.users.each do |member|
        next if member == user
        unless user.all_friends.include?(member)
          puts "Creating friendship between #{user.name} and #{member.name}"
          Friendship.create(user: user, friend: member) unless Friendship.exists?(user: user, friend: member)
          Friendship.create(user: member, friend: user) unless Friendship.exists?(user: member, friend: user)
        end
      end
    end
  end

  private

  def set_group
    if params[:id].present?
      @group = Group.find(params[:id])
    elsif params[:token].present?
      @group = Group.find_by(invite_token: params[:token])
    end
  end

  def group_params
    params.require(:group).permit(:name)
  end

  def require_login
    redirect_to login_path, alert: "Please log in first" unless logged_in?
  end

  def authorize_owner
    unless @group.created_by == current_user.id
      redirect_to group_path(@group), alert: "Only the group owner can perform this action."
    end
  end
end
