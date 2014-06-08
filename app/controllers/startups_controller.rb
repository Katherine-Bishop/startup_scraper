class StartupsController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end
  	
  def create
  	@startup = Startup.new
  end

  def new
  	@startup = Startup.new(params[:startup])
  end

  def scrape
  	#!/usr/bin/env ruby

  	agent = Mechanize.new

  	page = agent.get "http://www.seed-db.com/accelerators/view?acceleratorid=2001"
  
  	links = page.links_with(:href => %r{/companies/view});
  	# logger.debug "Link text: #{link.text}"


	# logger.debug "Links: #{links}"

  	links.each do |link|
	  	@startup = Startup.new
	  	@startup.name = link.text
	  	@startup.save

	  	page2 = link.click
	  	if page2.link_with(:href => %r{/angel.co})
	  		page3 = page2.link_with(:href => %r{/angel.co}).click
	  	# angelListId = founderDiv[0]['data-id']
		  	founderProfiles = page3.search("a.profile-link")
		  	founderProfiles.each do |founder|
		  		angelListId = founder['data-id']
			  	angelProfile = agent.get "https://api.angel.co/1/users/"+angelListId
			  	parsedData = JSON.parse(/\{.*\}/.match(angelProfile.content)[0])
			  	# logger.debug "Founder Id: #{parsedData.name}"
			  	logger.debug "Founder Id: #{parsedData['name']}"
			  	@founder = Founder.new
			  	@founder.name = parsedData['name']
			  	@founder.startup_id = @startup.id
			  	@founder.save
			end  	
		end  	
  	end

  end	
  
end
