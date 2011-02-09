# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110117103735) do

  create_table "analyses", :force => true do |t|
    t.string   "name",               :null => false
    t.string   "part_name"
    t.string   "machine_name"
    t.date     "date"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "analysis_datas", :force => true do |t|
    t.integer  "analysis_id",                                           :null => false
    t.decimal  "cycle_time",             :precision => 10, :scale => 1, :null => false
    t.decimal  "utilization",            :precision => 10, :scale => 2, :null => false
    t.decimal  "parts_produced",         :precision => 10, :scale => 2, :null => false
    t.decimal  "annual_operating_hours", :precision => 10, :scale => 2, :null => false
    t.integer  "location_id",                                           :null => false
    t.decimal  "test_duration",          :precision => 10, :scale => 1, :null => false
    t.decimal  "energy_consumed",        :precision => 10, :scale => 2, :null => false
    t.text     "csv_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "country_energy_costs", :force => true do |t|
    t.string   "name"
    t.decimal  "energy_cost",         :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "avg_emission_factor", :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
