class Transaction < ApplicationRecord
  # Typ transakcji: string w bazie (+ CHECK constraint), tu wygodne API:
  # buy?, sell!, scope Transaction.dividend itd. Wartości MUSZĄ zgadzać się z CHECK w migracji.
  enum :transaction_type, { buy: "buy", sell: "sell", dividend: "dividend", fee: "fee" }

  validates :broker, :transaction_type, :transacted_on, :ticker, :currency, presence: true
  validates :quantity, :price, :fee, presence: true
  validates :fee, numericality: { greater_than_or_equal_to: 0 }
end
