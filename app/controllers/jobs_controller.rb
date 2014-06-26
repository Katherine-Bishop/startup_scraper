class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

    def scrape
    	#!/usr/bin/env ruby

    	@founders = Founder.all

    	@founders.each do |founder|
    		next if ! founder.linkedin_url

	    	agent = Mechanize.new

    		linkedinProfile = agent.get founder.linkedin_url

    		jobDivs = linkedinProfile.search("div#profile-experience div.content div div div.position")

    		jobDivs.each do |jobDiv|
    			@job = Job.new
    			@job.founder_id = founder.id
    			@job.position = jobDiv.search("div.postitle span.title").text
    			@job.company = jobDiv.search("div.postitle span.org").text
    			@job.company_description = jobDiv.search("p.orgstats").text
    			@job.save
    		end	
  		end  	
    end	  

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render action: 'show', status: :created, location: @job }
      else
        format.html { render action: 'new' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:founder_id, :position, :company, :company_description)
    end
end
