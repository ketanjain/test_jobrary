class CreateAnalysisDatas < ActiveRecord::Migration
  def self.up
    create_table :analysis_datas do |t|

      t.integer :analysis_id, :null => false
      t.decimal :cycle_time, :precision => 10, :scale => 1, :null => false
      t.decimal :utilization, :precision => 10, :scale => 2, :null => false
      t.decimal :parts_produced, :precision => 10, :scale => 2, :null => false
      t.decimal :annual_operating_hours, :precision => 10, :scale => 2, :null => false
      t.integer :location_id, :null => false
      t.decimal :test_duration, :precision => 10, :scale => 1, :null => false
      t.decimal :energy_consumed, :precision => 10, :scale => 2, :null => false
      t.text :csv_data
      t.timestamps
    end
  end

  def self.down
    drop_table :analysis_datas
  end
end
