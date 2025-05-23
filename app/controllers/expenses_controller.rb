class ExpensesController < ApplicationController
  before_action :require_login
  before_action :set_group
  before_action :set_current_user
  before_action :set_expense, only: [:edit, :update] # Add for edit/update

  def new
    @expense = @group.expenses.build
    @all_members = @group.users # Include current user in the list
  end

  def create
    ActiveRecord::Base.transaction do
      @expense = @group.expenses.new(expense_params)
      @expense.paid_by = @current_user

      if @expense.save
        create_expense_shares
        redirect_to group_path(@group), notice: 'Expense created successfully!'
        return
      end
    end

    @all_members = @group.users
    render :new
  rescue ActiveRecord::RecordInvalid => e
    @all_members = @group.users
    flash.now[:alert] = "Failed to create expense: #{e.message}"
    render :new
  end

  def edit
    @all_members = @group.users # For the form to show all members
  end

  def update
    ActiveRecord::Base.transaction do
      if @expense.update(expense_params)
        # Destroy existing shares and recreate them with updated data
        @expense.expense_shares.destroy_all
        create_expense_shares
        redirect_to group_path(@group), notice: 'Expense updated successfully!'
        return
      end
    end

    @all_members = @group.users
    render :edit
  rescue ActiveRecord::RecordInvalid => e
    @all_members = @group.users
    flash.now[:alert] = "Failed to update expense: #{e.message}"
    render :edit
  end

  private

  def require_login
    redirect_to login_path, alert: "Please log in first" unless logged_in?
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_current_user
    @current_user = current_user
  end

  def set_expense
    @expense = @group.expenses.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:description, :amount)
  end

  def create_expense_shares
    total = @expense.amount.to_d  # Convert to Decimal for precision
    selected_ids = params[:member_ids] || @group.users.pluck(:id)
    members = @group.users.where(id: selected_ids.reject(&:blank?))
    return if members.empty?

    # Calculate using integer cents to avoid floating-point errors
    total_cents = (total * 100).to_i
    base_cents = total_cents / members.count
    remainder = total_cents % members.count

    members.each_with_index do |member, index|
      # Distribute remainder cents
      amount_cents = index < remainder ? base_cents + 1 : base_cents
      amount = (amount_cents / 100.0).to_d.round(2)
      next if member == @current_user # Skip payer
      @expense.expense_shares.create!(
        user: member,
        amount_owed: amount
      )
    end
  end
end