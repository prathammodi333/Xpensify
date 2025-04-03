# class SettlementsController < ApplicationController
#   before_action :require_login
#   before_action :set_group
#   before_action :set_payee, only: [:new, :create]

#   def new
#     @settlement = Settlement.new
#     @amount_owed = current_user.group_balances(@group)[@payee.id] || 0
#   end

#   def create
#     @settlement = Settlement.new(
#       payer: current_user,
#       payee: @payee,
#       amount: params[:settlement][:amount],
#       group: @group
#     )

#     if @settlement.save
#       redirect_to group_balance_path(@group), notice: 'Payment recorded successfully'
#     else
#       @amount_owed = current_user.group_balances(@group)[@payee.id] || 0
#       render :new
#     end
#   end

#   private

#   def set_group
#     @group = Group.find(params[:group_id])
#   end

#   def set_payee
#     @payee = User.find(params[:payee_id])
#   rescue ActiveRecord::RecordNotFound
#     redirect_to group_balance_path(@group), alert: 'User not found'
#   end
 

#   def settlement_params
#     params.require(:settlement).permit(:amount)
#   end

class SettlementsController < ApplicationController
  before_action :require_login
  before_action :set_group
  before_action :set_payee, only: [:new, :create]

  def new
    @settlement = Settlement.new
    @amount_owed = current_user.group_balances(@group)[@payee.id] || 0
  end

  def create
    @settlement = current_user.settlements_paid.new(
      payee: @payee,
      amount: params[:settlement][:amount],
      group: @group
    )

    if @settlement.save
      redirect_to group_balance_path(@group), notice: 'Payment recorded successfully'
    else
      @amount_owed = current_user.group_balances(@group)[@payee.id] || 0
      render :new
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_payee
    @payee = User.find(params[:payee_id])  # Now comes from URL params
  rescue ActiveRecord::RecordNotFound
    redirect_to group_balance_path(@group), alert: 'User not found'
  end

  # Remove the duplicate settlement_params method
  def settlement_params
    params.require(:settlement).permit(:amount)
  end
  def require_login
    redirect_to login_path, alert: "Please log in first" unless logged_in?
  end
end