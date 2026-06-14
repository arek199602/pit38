class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.string :broker, null: false
      t.string :transaction_type, null: false
      t.date :transacted_on, null: false
      t.string :ticker, null: false
      # Money: decimal, NEVER float (IEEE 754 loses cents -> wrong tax).
      # scale 8 = fractional shares / crypto; precision 18 = plenty of headroom.
      t.decimal :quantity, precision: 18, scale: 8, null: false, default: 0
      t.decimal :price, precision: 18, scale: 8, null: false, default: 0
      t.string :currency, null: false
      t.decimal :fee, precision: 18, scale: 8, null: false, default: 0

      t.timestamps

      # Index for FIFO: transactions are processed per ticker, ordered by date.
      t.index [ :ticker, :transacted_on ]

      # DB constraints = the last line of defense for correctness (Copeland, ch. 14).
      t.check_constraint "transaction_type IN ('buy', 'sell', 'dividend', 'fee')",
        name: "transactions_type_valid"
      t.check_constraint "fee >= 0", name: "transactions_fee_non_negative"
    end
  end
end
