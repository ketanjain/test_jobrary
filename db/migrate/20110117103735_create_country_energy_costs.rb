class CreateCountryEnergyCosts < ActiveRecord::Migration
  def self.up
    create_table :country_energy_costs do |t|
      t.string :name
      t.decimal :energy_cost, :default => 0,:precision => 10, :scale => 2
      t.decimal :avg_emission_factor, :default => 0,:precision => 10, :scale => 2

      t.timestamps
    end

    CountryEnergyCost.reset_column_information
    CountryEnergyCost.create(:name => 'China', :energy_cost => 0.064, :avg_emission_factor => 2.05)
    CountryEnergyCost.create(:name => 'France', :energy_cost => 0.12, :avg_emission_factor => 0.22)
    CountryEnergyCost.create(:name => 'Germany', :energy_cost => 0.16, :avg_emission_factor => 1.43)
    CountryEnergyCost.create(:name => 'India', :energy_cost => 0.13, :avg_emission_factor => 1.76)
    CountryEnergyCost.create(:name => 'US', :energy_cost => 0.09, :avg_emission_factor => 1.32)

  end

  def self.down
    drop_table :country_energy_costs
  end
end
