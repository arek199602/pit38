require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "valid transaction saves" do
    t = Transaction.new(
      broker: "trading212", transaction_type: "buy",
      transacted_on: Date.new(2024, 3, 15), ticker: "AAPL",
      quantity: 10, price: 172.50, currency: "USD", fee: 0
    )
    assert t.valid?
    assert t.save
  end

  test "kwoty są BigDecimal, nie float (precyzja podatkowa)" do
    assert_kind_of BigDecimal, transactions(:aapl_buy).price
    assert_kind_of BigDecimal, transactions(:aapl_buy).quantity
  end

  test "wymaga brokera, tickera, waluty i daty" do
    t = Transaction.new
    assert_not t.valid?
    assert t.errors[:broker].any?
    assert t.errors[:ticker].any?
    assert t.errors[:currency].any?
    assert t.errors[:transacted_on].any?
  end

  test "prowizja nie może być ujemna" do
    t = transactions(:aapl_buy)
    t.fee = -1
    assert_not t.valid?
  end

  test "enum transaction_type daje metody buy?/sell?" do
    assert transactions(:aapl_buy).buy?
    assert transactions(:aapl_sell).sell?
  end
end
