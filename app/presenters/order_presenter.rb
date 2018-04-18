class OrderPresenter < SimpleDelegator
  attr_reader :view

  def initialize(model, view_context)
    @view = view_context
    super(model)
  end

  def order_balance
    view.number_to_currency(balance, unit: 'RD$')
  end
end