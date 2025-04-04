class DashboardController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
    @recent_expenses = @user.expenses.order(created_at: :desc).limit(5)
    @groups = @user.groups.presence || []
    total_balances = @groups.map { |group| @user.group_balances(group).values.sum }
    @balance_owed = total_balances.select { |balance| balance > 0 }.sum
    @balance_due = total_balances.select { |balance| balance < 0 }.map(&:abs).sum
    # @balance_owed = calculate_balance_owed
    # @balance_due = calculate_balance_due

    @friends = @user.all_friends
    @friend_balances = calculate_friend_balances
    # @friend_balances = @friends.map { |friend| [friend, @user.friend_balance(friend)] }.to_h

    @transactions = TransactionHistory
                      .where(payer: @user)
                      .or(TransactionHistory.where(receiver: @user))
                      .order(created_at: :desc)
    Rails.logger.info "Final Friend Balances: #{@friend_balances.map { |f, b| "#{f.name}: #{b}" }.join(', ')}"
  end

  private

  def calculate_balance_owed
    @user.expense_shares.sum(:amount_owed)
  end

  def calculate_balance_due
    @user.expenses.sum(:amount) - @user.expense_shares.sum(:amount_owed)
  end

  # def calculate_friend_balances(user)
  #   balances = {}
  #   user.all_friends.each do |friend|
  #     amount_owed = amount_owed_to(friend, user)
  #     amount_due = amount_owed_to(user, friend)
  #     balances[friend] = amount_due - amount_owed
  #   end
  #   balances
  # end
  # def calculate_friend_balances
  #   balances = {}
  #   @friends.each do |friend|
  #     # Find groups where both user and friend are members
  #     shared_groups = @groups.joins(:group_memberships)
  #                           .where(group_memberships: { user_id: friend.id })
      
  #     # Sum the balances for this friend across all shared groups
  #     total_balance = shared_groups.sum do |group|
  #       group_balances = @user.group_balances(group)
  #       group_balances[friend.id] || 0 # Balance with this friend, default to 0 if not present
  #     end
  #     balances[friend] = total_balance
  #   end
  #   balances
  # end
  def calculate_friend_balances
    balances = {}
    Rails.logger.info "Starting friend balance calculation for user: #{@user.name}"
    
    # Iterate through each group the user is part of
    @groups.each do |group|
      Rails.logger.info "Processing group: #{group.name} (ID: #{group.id})"
      
      # Check if the friend is a member of this group
      @friends.each do |friend|
        # Check if the friend is a member of the group
        if group.users.include?(friend)
          Rails.logger.info "Friend #{friend.name} (ID: #{friend.id}) is a member of the group '#{group.name}'"
          
          # Get the balance of the user in the group
          group_balances = @user.group_balances(group)
          Rails.logger.info "Group '#{group.name}' balances: #{group_balances.inspect}"
          
          # Get the balance of the friend in the group
          friend_balance = group_balances[friend.id] || 0
          Rails.logger.info "Friend's balance in '#{group.name}': #{friend_balance}"
          
          # Add the friend's balance to the total balance for that friend
          balances[friend] ||= 0  # Initialize if not already present
          balances[friend] += -friend_balance  # Subtract friend's balance from total balance
        else
          Rails.logger.info "Friend #{friend.name} (ID: #{friend.id}) is NOT a member of the group '#{group.name}'"
        end
      end
    end
    
    Rails.logger.info "Completed friend balances: #{balances.map { |f, b| "#{f.name}: #{b}" }.join(', ')}"
    balances
  end
  
  def amount_owed_to(user, friend)
    ExpenseShare
      .joins(:expense)
      .where(user: friend, expenses: { paid_by: user })
      .sum(:amount_owed)
  end

  def require_login
    redirect_to login_path, alert: "Please log in first" unless logged_in?
  end
end
