class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_numbers
      t.date :date_of_joining
      t.bigint :salary
      t.timestamps
    end

    add_index :employees, :email, unique: true  end
end
