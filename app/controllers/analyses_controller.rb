require "fastercsv"
class AnalysesController < ApplicationController
  
  before_filter :authorize

  # List all analysis.
  def overview
    @analyses = Analysis.all
  end

  # Display analysis data and graphs.
  def show
    @analysis = Analysis.find(params[:id])
  end

  # New analysis.
  def new
    @analysis = Analysis.new
    @analysis_data = AnalysisData.new
    @country_energy_costs, @country_energy_costs_array = generate_country_energy_cost_array
  end

  # Edit analysis.
  def edit
    @analysis = Analysis.find(params[:id])
    @country_energy_costs, @country_energy_costs_array = generate_country_energy_cost_array
  end

  # Create new analysis.
  def create
    @valid = true
    @invalid_csv = false

    @analysis = Analysis.new(params[:analysis])
    @analysis_data = AnalysisData.new(params[:analysis_data])

    @valid = false unless @analysis.valid?
    @valid = false unless @analysis_data.valid?

    if params[:csv_file]
      set_data_from_csv_file(params[:csv_file])
    else
      @analysis.errors.add_to_base(CSV_FILE_REQUIRED_ERROR)
      @invalid_csv = true
    end

    @analysis.analysis_data = @analysis_data
    
    @country_energy_costs, @country_energy_costs_array = generate_country_energy_cost_array
    
    respond_to do |format|
      if !@invalid_csv && @valid && @analysis.save
        format.html { redirect_to(list_analysis_path) }
      else
        @analysis.image = nil
        format.html { render :action => "new" }
      end
    end
  end

  # Update analysis.
  def update
    @valid = true
    @invalid_csv = false

    @analysis = Analysis.find(params[:id])
    @analysis.attributes = params[:analysis]
    @analysis_data = @analysis.analysis_data
    @analysis_data.attributes = params[:analysis_data]
    
    
    @country_energy_costs, @country_energy_costs_array = generate_country_energy_cost_array

    @valid = false unless @analysis.valid?
    @valid = false unless @analysis_data.valid?

    set_data_from_csv_file(params[:csv_file])
    
    @analysis.analysis_data = @analysis_data
    
    respond_to do |format|
      if !@invalid_csv && @valid && @analysis.save
        format.html { redirect_to(edit_analyses_path) }
      else
        @analysis.image = nil
        format.html { render :action => "edit" }
      end
    end
  end

  # Delete a analysis.
  def destroy
    @analysis = Analysis.find(params[:id])
    @analysis.destroy

    respond_to do |format|
      format.html { redirect_to(edit_analyses_path) }
    end
  end

  # Compare analysis.
  def compare
    @selected_analysis_ids = params[:analysis_compare][:ids].split(',')
    session[:selected_analysis_id] = @selected_analysis_ids
    @selected_analysis = []
    @analyses = analysis_list_for_comparison(session[:selected_analysis_id])
    @selected_analysis_ids.each do |analysis_id|
      @selected_analysis << Analysis.find(analysis_id)
    end
  end

  # Parse data from csv file and validate the csv file.
  def set_data_from_csv_file(csv_file)
    begin
      start_time = 0,
      end_time = 0,
      sum = 0, temp_sum = 0, index = 1,
      data = [],
      first_row = true
    
      if csv_file
        csv_data = FasterCSV.parse(csv_file)
        length = csv_data.length
        interval = 1
        until length/interval < 10000
          interval+=1
        end
        csv_data.each do |time,power_data|
          start_time = time if first_row
          end_time = time
          temp_sum = temp_sum + power_data.to_f
          
          if(index % interval == 0 )
            data << (temp_sum/interval).to_f.round(2)
            temp_sum = 0
          end
          sum = sum + power_data.to_f
          first_row = false
          index+=1
        end
        @analysis_data.csv_data = data.to_json()
        @analysis_data.test_duration = end_time.to_i - start_time.to_i
        @analysis_data.energy_consumed = sum/3600
      end
    rescue FasterCSV::MalformedCSVError
      @analysis.errors.add_to_base(INVALID_CSV_FILE_ERROR)
      @invalid_csv = true
    end
  end

  # List all analysis for editing/deleting.
  def edit_analyses
    @analyses = Analysis.all
  end

  # Adding a analysis to comparison
  def add_to_compare
    @analysis = Analysis.find(params[:analysis][:id])
    session[:selected_analysis_id] = session[:selected_analysis_id] << params[:analysis][:id]
    @analyses = analysis_list_for_comparison(session[:selected_analysis_id])
  end

  # Removing a analysis from comparison
  def remove_from_compare
    @selected_analyses = session[:selected_analysis_id]
    @selected_analyses.delete(params[:id])
    session[:selected_analysis_id] = @selected_analyses
    @analyses = analysis_list_for_comparison(session[:selected_analysis_id])
  end

  # Populating array containing the country specific energy data.
  def generate_country_energy_cost_array
    country_energy_costs = CountryEnergyCost.all()
    country_energy_costs_array = []
    country_energy_costs.each do |country_energy_cost|
      country_energy_costs_array << country_energy_cost.to_json()
    end
    return country_energy_costs, country_energy_costs_array
  end

  # Populate remaining analysis list for comparison
  def analysis_list_for_comparison(selected_analysis_ids)
    analyses = []
    Analysis.all.each do |analysis|
      unless selected_analysis_ids.index(analysis.id.to_s)
        analyses << analysis
      end
    end
    return analyses
  end
end
