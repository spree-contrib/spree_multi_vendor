Spree::Order.class_eval do
  belongs_to :vendor

  state_machine.after_transition to: :complete, do: :split_with_splitter!

  def clone
    self.class.new(attributes.except('id', 'number', 'updated_at', 'created_at'))
  end

  def split_with_splitter!
    Spree::OrderSplitter.new(self).split!
  end
end
