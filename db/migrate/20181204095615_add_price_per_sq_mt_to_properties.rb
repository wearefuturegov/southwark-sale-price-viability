class AddPricePerSqMtToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :price_per_sq_mt, :float
    Property.all.each do |p|
      next unless p.sq_mt&.nonzero?
      p.update_attributes(price_per_sq_mt: p.price_paid / p.sq_mt)
    end
  end
end
