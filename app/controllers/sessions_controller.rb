# class SessionsController < ApplicationController
  
#   # def create
#   #   if params[:email].blank? || params[:password].blank?
#   #     flash.now[:alert] = "Email and password cannot be blank"
#   #     render :new, status: :unprocessable_entity
#   #     return
#   #   end
  
#   #   user = User.find_by(email: params[:email])
  
#   #   if user&.authenticate(params[:password])
#   #     session[:user_id] = user.id
  
#   #     # 👥 Auto-accept pending friend request if sender_id is stored in session
#   #     if session[:pending_friend_request_sender_id]
#   #       sender = User.find_by(id: session[:pending_friend_request_sender_id])
#   #       if sender && !user.all_friends.include?(sender)
#   #         Friendship.create(user: user, friend: sender)
#   #         flash[:notice] = "#{sender.name} has been added to your friend list!"
#   #       end
#   #       session.delete(:pending_friend_request_sender_id)
#   #     end
  
#   #     redirect_to dashboard_path, notice: "Logged in successfully"
#   #   else
#   #     flash.now[:alert] = "Invalid email or password"
#   #     render :new, status: :unprocessable_entity
#   #   end
#   # end
#   def create
#     if params[:email].blank? || params[:password].blank?
#       flash.now[:alert] = "Email and password cannot be blank"
#       render :new, status: :unprocessable_entity
#       return
#     end
  
#     user = User.find_by(email: params[:email])
  
#     if user&.authenticate(params[:password])
#       session[:user_id] = user.id
  
#       # 🔥 Check for pending friendship request
#       if session[:pending_friend_request_sender_id]
#         sender_id = session.delete(:pending_friend_request_sender_id)
#         sender = User.find_by(id: sender_id)
  
#         if sender && !user.all_friends.include?(sender)
#           Friendship.create(user: user, friend: sender)
#           flash[:notice] = "You are now friends with #{sender.name}!"
#         end
#       else
#         flash[:notice] = "Logged in successfully"
#       end
  
#       redirect_to dashboard_path
#     else
#       flash.now[:alert] = "Invalid email or password"
#       render :new, status: :unprocessable_entity
#     end
#   end
  
  
#     def destroy
#       session[:user_id] = nil
#       redirect_to login_path, notice: "Logged out successfully!"
#     end
#   end
  
# class SessionsController < ApplicationController
#   def create
#     # Check if email or password is blank
#     if params[:email].blank? || params[:password].blank?
#       flash.now[:alert] = "Email and password cannot be blank"
#       render :new, status: :unprocessable_entity
#       return
#     end
  
#     # Find the user by email
#     user = User.find_by(email: params[:email])
  
#     if user&.authenticate(params[:password])
#       session[:user_id] = user.id
  
#       # Handle any pending friendship request
#       if session[:pending_friend_request_sender_id]
#         sender_id = session.delete(:pending_friend_request_sender_id)
#         sender = User.find_by(id: sender_id)
  
#         if sender && !user.all_friends.include?(sender)
#           Friendship.create(user: user, friend: sender)
#           flash[:notice] = "You are now friends with #{sender.name}!"
#         end
#       end
  
#       # Handle group invitation if token is present
#       if params[:token].present?
#         group = Group.find_by(invite_token: params[:token])
  
#         if group && !group.users.include?(user)
#           GroupMembership.create(user: user, group: group)
#           flash[:notice] ||= "You have successfully joined the group!"
  
#           # Add the user to the friend list of each member of the group
#           group.users.each do |member|
#             next if member == user
#             # Add friendship in both directions
#             Friendship.find_or_create_by(user: user, friend: member)
#             Friendship.find_or_create_by(user: member, friend: user)
#           end
#         else
#           flash[:alert] = "Invalid invite link or you are already a member of the group."
#         end
#       end
  
#       # Redirect to the dashboard
#       redirect_to dashboard_path, notice: flash[:notice] || "Logged in successfully"
#     else
#       flash.now[:alert] = "Invalid email or password"
#       render :new, status: :unprocessable_entity
#     end
#   end
  
#   def destroy
#     session[:user_id] = nil
#     redirect_to login_path, notice: "Logged out successfully!"
#   end
# end
class SessionsController < ApplicationController
  # def create
  #   # Check if email or password is blank
  #   if params[:email].blank? || params[:password].blank?
  #     flash.now[:alert] = "Email and password cannot be blank"
  #     render :new, status: :unprocessable_entity
  #     return
  #   end

  #   # Find the user by email
  #   user = User.find_by(email: params[:email])

  #   if user&.authenticate(params[:password])
  #     session[:user_id] = user.id

  #     # Handle any pending friendship request
  #     if session[:pending_friend_request_sender_id]
  #       sender_id = session.delete(:pending_friend_request_sender_id)
  #       sender = User.find_by(id: sender_id)

  #       if sender && !user.all_friends.include?(sender)
  #         Friendship.create(user: user, friend: sender)
  #         flash[:notice] = "You are now friends with #{sender.name}!"
  #       end
  #     end

  #     # Handle group invitation if token is present
  #     if session[:pending_group_invite_token].present?
  #       token = session.delete(:pending_group_invite_token)
  #       group = Group.find_by(invite_token: token)

  #       if group && !group.users.include?(user)
  #         GroupMembership.create(user: user, group: group)
  #         flash[:notice] ||= "You have successfully joined the group!"

  #         # Add the user to the friend list of each member of the group
  #         group.users.each do |member|
  #           next if member == user  # Skip adding themselves as a friend
  #           Friendship.find_or_create_by(user: user, friend: member)
  #           Friendship.find_or_create_by(user: member, friend: user)
  #         end
  #       else
  #         flash[:alert] = "Invalid invite link or you are already a member of the group."
  #       end
  #     end

  #     # Redirect to the dashboard
  #     redirect_to dashboard_path, notice: flash[:notice] || "Logged in successfully"
  #   else
  #     flash.now[:alert] = "Invalid email or password"
  #     render :new, status: :unprocessable_entity
  #   end
  # end
  # def create
  #   # Check if email or password is blank
  #   if params[:email].blank? || params[:password].blank?
  #     flash.now[:alert] = "Email and password cannot be blank"
  #     render :new, status: :unprocessable_entity
  #     return
  #   end

  #   # Find the user by email
  #   user = User.find_by(email: params[:email])

  #   if user&.authenticate(params[:password])
  #     session[:user_id] = user.id

  #     # Check for pending group invite
  #     if session[:pending_group_invite_token]
  #       token = session.delete(:pending_group_invite_token)
  #       group = Group.find_by(invite_token: token)

  #       if group && !group.users.include?(user)
  #         # Add user to group
  #         GroupMembership.create(user: user, group: group)
  #         flash[:notice] ||= "You have successfully joined the group!"
        
  #         # Add the user to the friend list of each member of the group
  #         group.users.each do |member|
  #           next if member == user
  #           Friendship.find_or_create_by(user: user, friend: member)
  #           Friendship.find_or_create_by(user: member, friend: user)
  #         end
  #       else
  #         flash[:alert] = "Invalid invite link or you are already a member of the group."
  #       end
  #     end

  #     # Handle any pending friendship request (same as your original logic)
  #     if session[:pending_friend_request_sender_id]
  #       sender_id = session.delete(:pending_friend_request_sender_id)
  #       sender = User.find_by(id: sender_id)

  #       if sender && !user.all_friends.include?(sender)
  #         Friendship.create(user: user, friend: sender)
  #         flash[:notice] = "You are now friends with #{sender.name}!"
  #       end
  #     end

  #     redirect_to dashboard_path, notice: flash[:notice] || "Logged in successfully"
  #   else
  #     flash.now[:alert] = "Invalid email or password"
  #     render :new, status: :unprocessable_entity
  #   end
  # end
  def create
    if params[:email].blank? || params[:password].blank?
      flash.now[:alert] = "Email and password cannot be blank"
      render :new, status: :unprocessable_entity
      return
    end

    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      # Handle any pending group invite
      if session[:pending_group_invite_token]
        token = session.delete(:pending_group_invite_token)
        group = Group.find_by(invite_token: token)

        if group && !group.users.include?(user)
          # Add user to the group
          GroupMembership.create(user: user, group: group)
          flash[:notice] ||= "You have successfully joined the group!"
          Rails.logger.debug "Checking friendship between #{group.users}"
          # Add the user to the friend list of each member of the group
          group.users.each do |member|
            next if member == user  # Skip adding themselves as a friend
            unless user.all_friends.include?(member)
              Rails.logger.debug "Creating friendship between #{user.name} and #{member.name}"
              Friendship.create(user: user, friend: member) unless Friendship.exists?(user: user, friend: member)
              Friendship.create(user: member, friend: user) unless Friendship.exists?(user: member, friend: user)
            end
          end
        else
          flash[:alert] = "Invalid invite link or you are already a member of the group."
        end
      end

      redirect_to dashboard_path, notice: flash[:notice] || "Logged in successfully"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out successfully!"
  end
end
