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
class Transaction < ApplicationRecord
  # transaction_type is a string column (+ DB CHECK constraint); the enum adds the
  # convenient API (buy?, sell!, Transaction.dividend scope). Values MUST match the
  # CHECK constraint in the migration.
  # enum + CHECK (not a lookup table) because the value set is STABLE -- buy/sell/
  # dividend/fee are fixed tax-domain concepts with no per-value attributes.
  enum :transaction_type, { buy: "buy", sell: "sell", dividend: "dividend", fee: "fee" }

  validates :broker, :transaction_type, :transacted_on, :ticker, :currency, presence: true
  validates :quantity, :price, :fee, presence: true
  validates :fee, numericality: { greater_than_or_equal_to: 0 }
end
