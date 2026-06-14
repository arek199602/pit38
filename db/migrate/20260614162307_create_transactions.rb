class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.string :broker, null: false
      t.string :transaction_type, null: false
      t.date :transacted_on, null: false
      t.string :ticker, null: false
      # Kwoty: decimal, NIGDY float (IEEE 754 gubi grosze → zły podatek).
      # scale 8 = ułamkowe akcje / krypto; precision 18 = duży zapas.
      t.decimal :quantity, precision: 18, scale: 8, null: false, default: 0
      t.decimal :price, precision: 18, scale: 8, null: false, default: 0
      t.string :currency, null: false
      t.decimal :fee, precision: 18, scale: 8, null: false, default: 0

      t.timestamps

      # Indeks pod FIFO: przetwarzamy transakcje per ticker, w kolejności dat.
      t.index [ :ticker, :transacted_on ]

      # Constraints w bazie = ostatnia linia obrony poprawności (Copeland, rozdz. 14).
      t.check_constraint "transaction_type IN ('buy', 'sell', 'dividend', 'fee')",
        name: "transactions_type_valid"
      t.check_constraint "fee >= 0", name: "transactions_fee_non_negative"
    end
  end
end
