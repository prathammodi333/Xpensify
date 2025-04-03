class TransactionsController < ApplicationController
  before_action :require_login

  def index
    @transactions = current_user.transaction_histories_sent + current_user.transaction_histories_received
  end

  private

  def require_login
    redirect_to login_path unless logged_in?
  end
end
