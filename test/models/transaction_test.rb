# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  broker           :string           not null
#  currency         :string           not null
#  fee              :decimal(18, 8)   default(0.0), not null
#  price            :decimal(18, 8)   default(0.0), not null
#  quantity         :decimal(18, 8)   default(0.0), not null
#  ticker           :string           not null
#  transacted_on    :date             not null
#  transaction_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_transactions_on_ticker_and_transacted_on  (ticker,transacted_on)
#
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

  test "money fields are BigDecimal, not float (tax precision)" do
    assert_kind_of BigDecimal, transactions(:aapl_buy).price
    assert_kind_of BigDecimal, transactions(:aapl_buy).quantity
  end

  test "requires broker, ticker, currency and date" do
    t = Transaction.new
    assert_not t.valid?
    assert t.errors[:broker].any?
    assert t.errors[:ticker].any?
    assert t.errors[:currency].any?
    assert t.errors[:transacted_on].any?
  end

  test "fee cannot be negative" do
    t = transactions(:aapl_buy)
    t.fee = -1
    assert_not t.valid?
  end

  test "transaction_type enum provides buy?/sell? methods" do
    assert transactions(:aapl_buy).buy?
    assert transactions(:aapl_sell).sell?
  end
end
