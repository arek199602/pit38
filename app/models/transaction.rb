class Transaction < ApplicationRecord
  # transaction_type is a string column (+ DB CHECK constraint); the enum adds the
  # convenient API (buy?, sell!, Transaction.dividend scope). Values MUST match the
  # CHECK constraint in the migration.
  enum :transaction_type, { buy: "buy", sell: "sell", dividend: "dividend", fee: "fee" }

  validates :broker, :transaction_type, :transacted_on, :ticker, :currency, presence: true
  validates :quantity, :price, :fee, presence: true
  validates :fee, numericality: { greater_than_or_equal_to: 0 }
end
