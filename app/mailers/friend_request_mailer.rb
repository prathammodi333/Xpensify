class FriendRequestMailer < ApplicationMailer
    default from: 'no-reply@xpensify.com'
  
    def request_existing_user(sender, recipient)
      @sender = sender
      @recipient = recipient
      @accept_url = accept_friend_requests_url(sender_id: sender.id)
  
      mail(to: @recipient.email, subject: "#{@sender.name} wants to be your friend on Xpensify!")
    end
  
    def invite_new_user(sender, invited_email)
      @sender = sender
      @signup_url = signup_url(inviter_id: sender.id)
  
      mail(to: invited_email, subject: "#{@sender.name} invited you to join Xpensify!")
    end
      # Method for inviting a user to join the group
      def invite_to_group(sender, invited_email, group)
        @sender = sender
        @group = group
        @invite_link = group_invite_url(token: @group.invite_token)  # Generates the group invite URL
    
        mail(to: invited_email, subject: "#{@sender.name} invited you to join #{@group.name} on Xpensify!")
      end
  end
  