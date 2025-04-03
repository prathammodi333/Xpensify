class DashboardController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
    @recent_expenses = @user.expenses.order(created_at: :desc).limit(5)
    @groups = @user.groups.presence || []
    @balance_owed = calculate_balance_owed
    @balance_due = calculate_balance_due

    @friends = @user.all_friends
    @friend_balances = calculate_friend_balances(@user)

    @transactions = TransactionHistory
                      .where(payer: @user)
                      .or(TransactionHistory.where(receiver: @user))
                      .order(created_at: :desc)
  end

  private

  def calculate_balance_owed
    @user.expense_shares.sum(:amount_owed)
  end

  def calculate_balance_due
    @user.expenses.sum(:amount) - @user.expense_shares.sum(:amount_owed)
  end

  def calculate_friend_balances(user)
    balances = {}
    user.all_friends.each do |friend|
      amount_owed = amount_owed_to(friend, user)
      amount_due = amount_owed_to(user, friend)
      balances[friend] = amount_due - amount_owed
    end
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
