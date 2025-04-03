# class GroupsController < ApplicationController
#   before_action :require_login
#   before_action :set_group, only: [:show, :generate_invite_token, :invite, :destroy, :add_member]
#   def generate_invite_token
#     @group.update(invite_token: @group.generate_invite_token)
#     redirect_to @group, notice: "Invite link generated!"
#   end
#   # In GroupsController

# def invite
#   if logged_in?
#     token = params[:token]
#     @group = Group.find_by(invite_token: token)

#     if @group
#       flash[:notice] = "You have successfully joined the group!"
#       # Add the current_user to the group (you can adjust this logic based on your needs)
#       GroupMembership.create(user: current_user, group: @group)
#       redirect_to @group
#     else
#       flash[:alert] = "Invalid invite link."
#       redirect_to root_path
#     end
#   else
#     session[:pending_group_invite_token] = params[:token]  # Save the token temporarily
#     redirect_to login_path, alert: "Please log in first to join the group."
#   end
# end

  
  



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

#   def show
#     @members = @group.users
#     @expenses = @group.expenses
#     @friends = current_user.all_friends - @members
#   end
  
#   def destroy
#     @group = Group.find(params[:id])

#     # Check if the current user is the creator of the group
#     if @group.created_by == current_user.id
#       # First delete all associated memberships
#       @group.group_memberships.destroy_all

#       # You can add your logic here to keep track of the balance after the group is deleted.
#       # For example, create a record in a "deleted_groups" table or keep track of member balances.
      
#       # Then, delete the group itself
#       @group.destroy
#       redirect_to dashboard_path, notice: "Group deleted successfully."
#     else
#       redirect_to dashboard_path, alert: "You are not authorized to delete this group."
#     end
#   end

#   def add_member
#     user = User.find(params[:user_id])

#     if @group.users.include?(user)
#       redirect_to group_path(@group), alert: "#{user.name} is already a member of the group."
#     else
#       GroupMembership.create(user: user, group: @group)
#       redirect_to group_path(@group), notice: "#{user.name} was added to the group!"
#     end
#   end

#   private

#   def set_group
#     @group = Group.find(params[:id])
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
  before_action :set_group, only: [:show, :generate_invite_token, :invite, :destroy, :add_member, :add_member_email]

  def generate_invite_token
    # Generate the invite token and update the group
    @group.update(invite_token: @group.generate_invite_token)
    redirect_to @group, notice: "Invite link generated!"
  end


  # def invite
  #   if logged_in?
  #     # User is logged in, now try to find the group using the invite token
  #     token = params[:token]
  #     @group = Group.find_by(invite_token: token)
  
  #     if @group
  #       # Successfully join the group
  #       flash[:notice] = "You have successfully joined the group!"
        
  #       # Add the current user to the group
  #       GroupMembership.create(user: current_user, group: @group)
  
  #       # Optionally, add user to the friend list of all existing group members
  #       @group.users.each do |member|
  #         next if member == current_user  # Skip adding themselves as a friend
  #         Friendship.create(user: current_user, friend: member)
  #         Friendship.create(user: member, friend: current_user)
  #       end
  
  #       # Redirect to the group page
  #       redirect_to @group
  #     else
  #       flash[:alert] = "Invalid invite link."
  #       redirect_to root_path
  #     end
  #   else
  #     # If the user isn't logged in, save the invite token temporarily
  #     session[:pending_group_invite_token] = params[:token]
  #     redirect_to login_path, alert: "Please log in first to join the group."
  #   end
  # end
  
  # def invite
  #   if logged_in?
  #     # User is logged in, now try to find the group using the invite token
  #     token = params[:token]
  #     @group = Group.find_by(invite_token: token)

  #     if @group
  #       flash[:notice] = "You have successfully joined the group!"
  #       GroupMembership.create(user: current_user, group: @group)

  #       # Add the current user to the group (you can adjust this logic based on your needs)
  #       @group.users.each do |member|
  #         next if member == current_user  # Skip adding themselves as a friend
  #         Friendship.create(user: current_user, friend: member)
  #         Friendship.create(user: member, friend: current_user)
  #       end

  #       redirect_to @group
  #     else
  #       flash[:alert] = "Invalid invite link."
  #       redirect_to root_path
  #     end
  #   else
  #     # If the user isn't logged in, save the invite token temporarily
  #     session[:pending_group_invite_token] = params[:token]
  #     session[:inviter_id] = params[:inviter_id]  # Store the inviter's ID
  #     redirect_to login_path, alert: "Please log in first to join the group."
  #   end
  # end
  # Invite Method: Handle the group invite
  # def invite
  #   if logged_in?
  #     token = params[:token]
  #     @group = Group.find_by(invite_token: token)

  #     if @group
  #       flash[:notice] = "You have successfully joined the group!"
        
  #       # Add the current user to the group
  #       GroupMembership.create(user: current_user, group: @group)

  #       # Add the user to the friend list of all existing group members
  #       @group.users.each do |member|
  #         next if member == current_user  # Skip adding themselves as a friend
  #         Friendship.create(user: current_user, friend: member)
  #         Friendship.create(user: member, friend: current_user)
  #       end

  #       # Redirect to the group page
  #       redirect_to @group
  #     else
  #       flash[:alert] = "Invalid invite link."
  #       redirect_to root_path
  #     end
  #   else
  #     # If the user isn't logged in, save the invite token temporarily
  #     session[:pending_group_invite_token] = params[:token]
  #     redirect_to login_path, alert: "Please log in first to join the group."
  #   end
  # end
 # Invite Method: Handle the group invite
#  def invite
#   if logged_in?
#     # When the user is logged in
#     token = params[:token]
#     @group = Group.find_by(invite_token: token)

#     if @group
#       flash[:notice] = "You have successfully joined the group!"
      
#       # Add the current user to the group
#       GroupMembership.create(user: current_user, group: @group)

#       # Optionally, add user to the friend list of all existing group members
#       @group.users.each do |member|
#         next if member == current_user  # Skip adding themselves as a friend
#         Friendship.create(user: current_user, friend: member)
#         Friendship.create(user: member, friend: current_user)
#       end

#       redirect_to @group
#     else
#       flash[:alert] = "Invalid invite link."
#       redirect_to root_path
#     end
#   else
#     # If the user isn't logged in, save the invite token temporarily
#     session[:pending_group_invite_token] = params[:token]
#     redirect_to login_path, alert: "Please log in first to join the group."
#   end
# end
 # Invite Method to handle the token
 def invite
  token = params[:token]  # Grab the token from the URL path

  if logged_in?
    # User is logged in, attempt to find the group using the invite token
    @group = Group.find_by(invite_token: token)
Rails.logger.debug "invte function called!!!"
    if @group
      # Successfully join the group
      flash[:notice] = "You have successfully joined the group!😍"

      # Add the current user to the group
      GroupMembership.create(user: current_user, group: @group)
      Rails.logger.debug "Group membership created after invite link"
      # Add the user to the friend list of existing group members
      @group.users.each do |member|
        next if member == current_user  # Skip adding themselves as a friend
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
    # User is not logged in, save the token in the session and redirect to login page
    session[:pending_group_invite_token] = token
    redirect_to login_path, alert: "Please log in first to join the group."
  end
end
  # Handle Group Creation
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

  # Show Group
  def show
    @members = @group.users
    @expenses = @group.expenses.includes(:paid_by)
    @friends = current_user.all_friends - @members

  end

  # Destroy Group (Only allowed by creator)
  def destroy
    @group = Group.find(params[:id])

    if @group.created_by == current_user.id
      # Delete all associated memberships first
      @group.group_memberships.destroy_all

      # Then delete the group itself
      @group.destroy
      redirect_to dashboard_path, notice: "Group deleted successfully."
    else
      redirect_to dashboard_path, alert: "You are not authorized to delete this group."
    end
  end
  # Send invitation email
  def add_member_email
    email = params[:email].downcase.strip

    # Send the invitation email
    FriendRequestMailer.invite_to_group(current_user, email, @group).deliver_now

    # Flash message and redirect
    # flash[:notice] = "An invitation has been sent to #{email}."
    redirect_to group_path(@group), notice: "An invitation has been sent to #{email}" 
  end
  # Add Member to Group
  def add_member
    user = User.find(params[:user_id])

    if @group.users.include?(user)

      redirect_to group_path(@group), alert: "#{user.name} is already a member of the group."
    else
      GroupMembership.create(user: user, group: @group)
      redirect_to group_path(@group), notice: "#{user.name} was added to the group!"
      # Add user to the friend list of all existing group members (if not already a friend)
      @group.users.each do |member|
        next if member == user  # Skip adding themselves as a friend
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
end

