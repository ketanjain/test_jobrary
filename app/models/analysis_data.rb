class AnalysisData < ActiveRecord::Base

  belongs_to :analysis

  validates_numericality_of :cycle_time, :utilization, :parts_produced, :annual_operating_hours, :greater_than => 0, :message => "should be a number and greater than 0."

  def location
    return CountryEnergyCost.find(self.location_id).name || ''
  end

  def energy_cost
    return CountryEnergyCost.find(self.location_id).energy_cost || 0.0
  end

  def avg_emission_factor
    return CountryEnergyCost.find(self.location_id).avg_emission_factor || 0.0
  end

  def specific_energy_consumed_per_part
    return self.energy_consumed / self.parts_produced
  end

  def carbon_footprint_per_part
    return self.specific_energy_consumed_per_part * self.avg_emission_factor
  end

  def energy_cost_per_part
    return self.carbon_footprint_per_part * self.energy_cost
  end

  def process_energy_usage_per_part
    return (self.energy_consumed * (self.parts_produced * self.cycle_time / self.test_duration))/self.parts_produced
  end

  def idle_energy_usage_per_part
    return self.specific_energy_consumed_per_part - self.process_energy_usage_per_part
  end

  def annual_energy_usage
    return (self.annual_operating_hours * self.energy_consumed) / (self.test_duration / 3600)
  end

  def annual_footprint_for_year
    return self.annual_energy_usage * self.avg_emission_factor
  end

  def annual_energy_cost
    return self.annual_energy_usage * self.energy_cost
  end

  def annual_process_energy_usage
    return (self.parts_produced * self.annual_operating_hours) / (self.test_duration / 3600) * self.process_energy_usage_per_part
  end

  def annual_idle_energy_usage
    return self.annual_energy_usage - self.annual_process_energy_usage
  end

  def utilization_display
    return self.utilization.round(2)
  end

  def cycle_time_display
    return self.cycle_time.to_i
  end
  
  def carbon_footprint_per_part_display
    return self.carbon_footprint_per_part.round(2)
  end

  def energy_cost_per_part_display
    return self.energy_cost_per_part.round(2)
  end

  def process_energy_usage_per_part_display
    return self.process_energy_usage_per_part.round(3)
  end

  def annual_energy_usage_display
    return self.annual_energy_usage.to_i
  end

  def annual_footprint_for_year_display
    return self.annual_footprint_for_year.to_i
  end

  def annual_energy_cost_display
    return self.annual_energy_cost.to_i
  end

  def annual_process_energy_usage_display
    return self.annual_process_energy_usage.round(3)
  end

  def annual_idle_energy_usage_display
    return self.annual_idle_energy_usage.round(3)
  end

  def specific_energy_consumed_per_part_display
    return self.specific_energy_consumed_per_part.round(2)
  end

  def maximum_utilization
    return 95
  end

  def incremental_factor
    return ((self.maximum_utilization - self.utilization) / 3).round(2)
  end
  
  def utilization_improvement
    uti_improvements = []
    incremental_factor = self.incremental_factor
    proposed_uti = self.utilization + incremental_factor

    while(proposed_uti <= self.maximum_utilization)
      uti_improvements << UtilizationImprovement.new(self.utilization, proposed_uti, self.annual_energy_usage, self.annual_idle_energy_usage, self.energy_cost, self.avg_emission_factor)
      proposed_uti = proposed_uti + incremental_factor
    end
    
    return uti_improvements
  end

  def ct_reduction
    reduction_percents = [5.0,10.0,20.0]
    ct_reductions = []
    reduction_percents.each do |percent|
      ct_reductions << CT_Reduction.new(self.cycle_time, self.specific_energy_consumed_per_part, percent)
    end

    return ct_reductions
  end

  def ct_reduction_chart_values
    ct_reductions = self.ct_reduction
    values = []
    ct_reductions.each do |ct_reduction|
      values << {:savings => ct_reduction.savings_in_energy_consumption, :percent => ct_reduction.percent}
    end
    return values.to_json()
  end

  def utilization_improvement_chart_values
    utilization_improvements = self.utilization_improvement
    values = []
    utilization_improvements.each do |utilization_improvement|
      values << {:savings => utilization_improvement.annual_cost_savings, :percent => utilization_improvement.proposed_utilization}
    end
    return values.to_json()
  end

  def annual_energy_usage_chart_values
    values = []
    
    values << self.annual_process_energy_usage
    values << self.annual_idle_energy_usage
    
    return values.to_json()
  end

  class UtilizationImprovement
    attr_accessor :present_utilization,
      :proposed_utilization,
      :present_annual_energy_use,
      :present_annual_idle_energy_consumption,
      :energy_cost,
      :avg_emission_factor

    def initialize(present_utilization,proposed_utilization, present_annual_energy_use, present_annual_idle_energy_consumption, energy_cost, avg_emission_factor)
      @present_utilization, @proposed_utilization, @present_annual_energy_use, @present_annual_idle_energy_consumption, @energy_cost, @avg_emission_factor = present_utilization, proposed_utilization, present_annual_energy_use, present_annual_idle_energy_consumption, energy_cost,avg_emission_factor
    end

    def annual_energy_use
      return (self.present_annual_energy_use / self.present_utilization) * self.proposed_utilization
    end

    def annual_process_energy_consumption
      return self.annual_energy_use * (self.proposed_utilization) / 100
    end

    def annual_idle_energy_consumption
      return (1 - (self.proposed_utilization / 100)) * self.annual_energy_use
    end

    def annual_idle_energy_savings
      return self.present_annual_idle_energy_consumption - self.annual_idle_energy_consumption
    end

    def annual_cost_savings
      return self.annual_idle_energy_savings * self.energy_cost
    end

    def annual_carbon_savings
      return self.annual_idle_energy_savings * self.avg_emission_factor
    end
    
  end

  class CT_Reduction
    attr_accessor :present_cycle_time,
      :present_SEC,
      :percent

    def initialize(present_cycle_time, present_SEC, percent)
      @present_cycle_time, @present_SEC, @percent = present_cycle_time, present_SEC, percent
    end

    def cycle_time
      return (self.present_cycle_time - ((self.percent/100) * self.present_cycle_time))
    end

    def energy_consumption_per_part
      return (self.present_SEC / self.present_cycle_time) * self.cycle_time
    end

    def savings_in_energy_consumption
      return self.present_SEC - self.energy_consumption_per_part
    end
    
  end
end
