class CreateGuardarropa < ActiveRecord::Migration[6.0]
  def change
    create_table :guardarropas do |t|
       t.string :nombre
    end
  end
end
