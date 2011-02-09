class CreateAnalyses < ActiveRecord::Migration
  def self.up
    create_table :analyses do |t|
      t.string :name, :null => false
      t.string :part_name
      t.string :machine_name
      t.date :date
      t.text :description
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :analyses
  end
end
