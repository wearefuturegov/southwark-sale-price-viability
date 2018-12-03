# frozen_string_literal: true

class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.string :pao
      t.string :sao
      t.string :street
      t.string :locality
      t.string :town
      t.string :postcode
      t.st_point :latlng
      t.integer :price_paid
      t.integer :sq_mt

      t.timestamps
    end
  end
end
