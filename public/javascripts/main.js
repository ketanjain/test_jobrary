// Rounding a number to any number of decimal places.
if (!Number.toFixed) {
    Number.prototype.toFixed=function(x) {
      var temp=this;
      temp=Math.round(temp*Math.pow(10,x))/Math.pow(10,x);
      return temp;
    }}

// Function to populate the country wise data based on the country selected.
function populateCountryWiseData(id, country_energy_costs)
  {
    country_energy_costs.each(function(idx) {
      var data = idx.evalJSON();
      if(data.country_energy_cost.id == id)
      {
        $('analysis_data_energy_cost').value = data.country_energy_cost.energy_cost
        $('analysis_data_avg_emission_factor').value = data.country_energy_cost.avg_emission_factor
        $('analysis_data_location_id').value = data.country_energy_cost.id
      }
    })
  }