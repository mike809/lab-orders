class OrderPresenter < SimpleDelegator
  attr_reader :view

  def initialize(model, view_context)
    @view = view_context
    super(model)
  end

  def balance
    view.number_to_currency(super, unit: 'RD$')
  end
end