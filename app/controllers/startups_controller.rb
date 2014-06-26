class StartupsController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  require 'csv'

  def input_startups
    agent = Mechanize.new

    companyListPage = agent.get "http://www.seed-db.com/accelerators/view?acceleratorid=2001"
   
    companyLinks = companyListPage.links_with(:href => %r{/companies/view});

    companyLinks.each do |companyLink|
      @startup = Startup.new
      @startup.name = companyLink.text
      @startup.accelerator = "500 Startups"


      begin
        companyProfile = companyLink.click
      rescue Mechanize::ResponseCodeError => exception
        companyProfile = companyLink.click
      end

      if companyProfile.link_with(:href => %r{/angel.co})
        @startup.angellist_url = companyProfile.link_with(:href => %r{/angel.co}).href
      end  

      @startup.save
    end   
  end  

  def input_angellist

@startups = [['TokyoOtakuMode', 'https://angel.co/tokyo-otaku-mode'],
['Meloncard', 'https://angel.co/safe-shepherd'],
['DailyAisle', 'https://angel.co/dailyaisle'],
['PicCollage', 'https://angel.co/piccollage'],
['Redeemr', 'https://angel.co/postrocket'],
['WillCall', 'https://angel.co/willcall'],
['Whale Path', 'https://angel.co/whale-path'],
['InterviewMaster', 'https://angel.co/interview-master'],
['AwayFind', 'https://angel.co/awayfind'],
['ChirpMe', 'https://angel.co/chirpme-com'],
['CoderBuddy', 'https://angel.co/coderbuddy'],
['Console.fm', 'https://angel.co/console-fm'],
['Craft Coffee', 'https://angel.co/craftcoffee'],
['From.us', 'https://angel.co/from-us'],
['Ginzametrics', 'https://angel.co/ginzametrics'],
['Inductly', 'https://angel.co/inductly'],
['Loku', 'https://angel.co/loku'],
['Lumific', 'https://angel.co/lumific'],
['Manpacks', 'https://angel.co/manpacks'],
['Motion Math', 'https://angel.co/motion-math'],
['myGengo', 'https://angel.co/gengo-1'],
['NativeAD', 'https://angel.co/nativead'],
['Saygent', 'https://angel.co/saygent'],
['Social Stork', 'https://angel.co/social-stork'],
['Tinfoil Security', 'https://angel.co/tinfoil-security'],
['Unda', 'https://angel.co/unda']]
  
  @startups.each do |startup|
    companyName = startup[0]
    angelListUrl = startup[1]

    startupResults = Startup.where(:name => companyName, :accelerator => '500 Startups')
    startup = Startup.find(startupResults[0].id)
    startup.angellist_url = angelListUrl
    startup.save
  end  
 
end    

  def change_names
    # startupNames = [['3Sourcing', '3sourcing']]
# startupNames = [['955 Dreams', '955dreams']]
startupNames = [['Anyadir Education', 'anyadir education'],
['Baydin', 'baydin'],
['Binpress', 'binpress'],
['Bluefields', 'Bluefields.com'],
['BrightNest', 'brightnest'],
['BTCJam', 'BTCjam'],
['Cadee', 'cadee'],
['Central.ly', 'central.ly'],
['Chalkable', 'chalkable'],
['Culture Kitchen', 'culturekitchen'],
['DailyAisle', 'Daily Aisle'],
['eSpark Learning', 'eSparkLearning'],
['Everbill', 'everbill'],
['Femeninas', 'femeninas'],
['Fitocracy', 'fitocracy'],
['Fontacto', 'fontacto'],
['GazeMetrix', 'gazeMetrix'],
['Giveit100', 'GiveIt100'],
['Groupiter', 'groupiter'],
['Hapyrus', 'hapyrus'],
['iDreamBooks', 'IDreamBooks'],
['Kibin', 'kibin'],
['LaunchRock', 'launchrock'],
['Já Entendi', 'Ja Entendi'],
['Meloncard', 'MelonCard'],
['Ninua', 'ninua'],
['POPAPP', 'PopApp'],
['PublikDemand', 'Publikdemand'],
['Reclip.It', 'ReclipIt'],
['Rewardli', 'rewardli'],
['RotaDosConcursos', 'Rota Dos Concursos'],
['ShareRoot Inc.', 'ShareRoot Inc'],
['Silverpush', 'SilverPush'],
['Spoondate', 'spoondate'],
['STORYPANDA', 'Storypanda'],
['Switchcam', 'switchcam'],
['Talkdesk', 'TalkDesk'],
['Teamly', 'teamly'],
['TeliportMe', 'teliportme'],
['Tie Society', 'TieSociety'],
['TokyoOtakuMode', 'TokoyoOtakuMade'],
['TwitMusic', 'twitmusic'],
['VidCaster', 'vidcaster'],
['Visual.ly', 'visual.ly'],
['Welcu', 'welcu'],
['Whale Path', 'WhalePath'],
['WHILL', 'Whill']]

  startupNames.each do |startup|
    currentCompanyName = startup[1]
    newComanyName = startup[0]

    startupResults = Startup.where(:name => currentCompanyName, :accelerator => '500 Startups')
    startup = Startup.find(startupResults[0].id)
    startup.name = newComanyName
    startup.save
  end
    
  end

  def index
    @angellistUrls = []
    @startups_with_zero_results = 0
    @startups_with_one_result = 0
    @startups_with_multiple_results = 0

    @startups = Startup.where(:accelerator=>'500 Startups', :angellist_url=>nil)
    agent = Mechanize.new

    @startups.each do |startup|
      angelApiData = agent.get "https://api.angel.co/1/search?query="+startup.name+"&type=Startup"
      parsedData = JSON.parse angelApiData.content

      parsedData.each do |result|
        @angellistUrls.push result['url']
      end
        
      if parsedData.count == 0
        @startups_with_zero_results+=1
      elsif parsedData.count == 1
        @startups_with_one_result+=1
      elsif parsedData.count > 1  
        @startups_with_multiple_results+=1
      end  
    end
      
  end

  def add_startups
    # newStartups = ['Appetizer']
newStartups = ['AwayFind',
'ChirpMe',
'CoderBuddy',
'Console.fm',
'Craft Coffee',
'DailyGobble',
'Evoz',
'From.us',
'Ginzametrics',
'Glyder',
'Inductly',
'Loku',
'Lumific',
'Manpacks',
'Motion Math',
'myGengo',
'NativeAD',
'ReadyForZero',
'Saygent',
'SingBoard',
'Skipola',
'Social Stork',
'Tinfoil Security',
'Unda',
'WorkersNow']


    newStartups.each do |newStartup|
      @startup = Startup.new
      @startup.name = newStartup
      @startup.accelerator = "500 Startups"
      @startup.save
    end  
  end
#   def index
#   	@startups = Startup.all

#   	@startups_with_founders = 0
#   	@startups_with_no_founders = 0
#   	# @startups_with_angel_link = 0
#   	# @startups_without_angel_link = 0

#   	@startups.each do |startup|
#   		@founders = Founder.where(:startup_id => startup.id)
#   		if @founders.count > 0
#   			@startups_with_founders+=1
#   		else
#   			@startups_with_no_founders+=1	
#   		end
#   	end		  		

#   end
  	
#   def create
#   	@startup = Startup.new
#   end

#   def new
#   	@startup = Startup.new(params[:startup])
#   end

#   	def search

#   		# csv_string = CSV.generate do |csv|
#   		#   csv << ["startup_name", "angellist_url"]
#   		#   csv << ["another", "row"]
#   		#   # ...
#   		# end

#   		# send_data csv_string,
#   		#    :type => 'text/csv; charset=iso-8859-1; header=present',
#   		#    :disposition => "attachment; filename=users.csv"


#   		# @startups_with_zero_results = 0
#   		# @startups_with_one_result = 0
#   		# @startups_with_multiple_results = 0

#   	  	# agent = Mechanize.new
#   		# @startups = Startup.all

#   		# # csv_string = CSV.generate do |csv|
#   		# #   csv << ["startup_name", "angellist_url"]

# 	  	#   	@startups.each do |startup|
# 	  	#   		@founders = Founder.where(:startup_id => startup.id)
# 	  	#   		next if @founders.count > 0
	  	  		
# 		  # 	  	angelApiData = agent.get "https://api.angel.co/1/search?query="+startup.name+"&type=Startup"
# 		  # 	  	parsedData = JSON.parse angelApiData.content

# 		  # 	  	if parsedData.count == 0
# 		  # 	  		@startups_with_zero_results+=1
# 		  # 	  	elsif parsedData.count == 1
# 		  # 	  		@startups_with_one_result+=1

# 		# companyArray = [['Sqoot', 'https://angel.co/sqoot-2']]
# companyArray = [['Intercom', 'https://angel.co/intercom'],
# ['[crowd:rally]', 'https://angel.co/curios-me'],
# ['Tiny Review', 'https://angel.co/tiny-post'],
# ['OneSchool', 'https://angel.co/oneschool-1'],
# ['storytree', 'https://angel.co/simpleprints'],
# ['Ovia', 'https://angel.co/wepow'],
# ['Roam & Wander', 'https://angel.co/roam-wander-1'],
# ['Sidelines', 'https://angel.co/sidelines'],
# ['Teaman & Company', 'https://angel.co/teaman-company'],
# ['BTCjam', 'https://angel.co/btcjam'],
# ['VenueSpot', 'https://angel.co/venuespot'],
# ['Bounty Hunter', 'https://angel.co/bountyhunter'],
# ['KangaDo', 'https://angel.co/kangado'],
# ['Builk', 'https://angel.co/builk'],
# ['Pop Up Archive', 'https://angel.co/pop-up-archive'],
# ['Goods', 'https://angel.co/shortcut'],
# ['Vessel', 'https://angel.co/vessel'],
# ['DOZ', 'https://angel.co/doz'],
# ['Doorman', 'https://angel.co/doorman-1'],
# ['Remark', 'https://angel.co/remark'],
# ['AbbeyPost', 'https://angel.co/abbeypost'],
# ['Bonafide', 'https://angel.co/bonafide'],
# ['Stitch', 'https://angel.co/stitch'],
# ['Sales Beach', 'https://angel.co/sales-beach'],
# ['Grata', 'https://angel.co/grata'],
# ['Survmetrics', 'https://angel.co/survmetrics'],
# ['Friend Trusted', 'https://angel.co/friend-trusted'],
# ['Unwind Me', 'https://angel.co/unwind-me'],
# ['RealtyShares', 'https://angel.co/realtyshares'],
# ['Share Some Style', 'https://angel.co/share-some-style'],
# ['Quest', 'https://angel.co/quest'],
# ['Populr', 'https://angel.co/populr-me'],
# ['WishPlz', 'https://angel.co/wishplz']]  	

# companyArray = [['Buzzstarter', 'https://angel.co/buzzstarter'],
# ['Buzzstarter',	'https://angel.co/fandrop']]

# 		companyArray.each do |company|
# 			companyName = company[0]
# 			angelListUrl = company[1]
# 			logger.debug "name: #{companyName}"
# 			logger.debug "angel list url: #{angelListUrl}"
# 			startup = Startup.where(:name => companyName)
# 			startupId = startup[0].id
# 			logger.debug "startup id: #{startupId}"

#   	  		angelListProfile = agent.get angelListUrl
#   		  	founderDivs = angelListProfile.search("div.founders div.name a.profile-link")
#   		  	logger.debug "Number of founders: #{founderDivs.count}"
#   		  	founderDivs.each do |founder|
#   		  		angelListId = founder['data-id']
#   			  	angelApiData = agent.get "https://api.angel.co/1/users/"+angelListId
#   			  	parsedData = JSON.parse(/\{.*\}/.match(angelApiData.content)[0])
#   			  	linkedinUrl = parsedData['linkedin_url']
#   			  	logger.debug "Linkedin Profile: #{linkedinUrl}"

#   			  	@founder = Founder.new
#   			  	@founder.name = parsedData['name']
#   			  	@founder.startup_id = startupId
#   			  	@founder.save
#   			  	logger.debug "name #{parsedData['name']}"

#   			  	# make sure linkedinUrl is not null not or an empty string
#   			  	if linkedinUrl && linkedinUrl != '' 

#   				  	begin
#   					  	linkedinProfile = agent.get linkedinUrl
#   				  	rescue Mechanize::ResponseCodeError => exception
#   				  	  next
#   				  	end

#   				  	@founder.linkedin_url = linkedinUrl

#   				  	connections = linkedinProfile.search(".overview-connections p strong").text
#   				  	logger.debug "Connections: #{connections}"
#   				  	@founder.connections = connections.to_i
#   				  	@founder.save
#   				end  	
  			  		
#   			end  	
# 		end	

# 	  	  		 #  	logger.debug "Company name: #{startup.name}"


# 	  	  			#   	# linkedinProfile = agent.get parsedData['linkedin_url']

# 	  	  			# end  	






		  	  		
# 		  	  # 	elsif parsedData.count > 1
# 		  	  # 		# parsedData.each do |result|
# 			  	 #  	# 	csv << [startup.name, result['url']]
# 		  	  # 		# end	
# 		  	  # 		@startups_with_multiple_results+=1
# 		  	  # 	end	  	
# 	  	  	# end
# 	  	# end

# 	  	# send_data csv_string,
# 	  	#    :type => 'text/csv; charset=iso-8859-1; header=present',
# 	  	#    :disposition => "attachment; filename=startup_angellist_urls_multiple.csv"  		
#   	end		

  def scrape
  	#!/usr/bin/env ruby

  	agent = Mechanize.new
  	companyListPage = agent.get "http://www.seed-db.com/accelerators/view?acceleratorid=2001"
 
  	companyLinks = companyListPage.links_with(:href => %r{/companies/view});

  	companyLinks.each do |companyLink|
	  	@startup = Startup.new
	  	@startup.name = companyLink.text
	  	@startup.save

	  	companyProfile = companyLink.click
	  	if companyProfile.link_with(:href => %r{/angel.co})
		  	logger.debug "Type of object: #{companyProfile}"


		  	begin
		  		companyAngelList = companyProfile.link_with(:href => %r{/angel.co}).click
		  	rescue Mechanize::ResponseCodeError => exception
		  	  next
		  	end

		  	founderDivs = companyAngelList.search("div.founders div.name a.profile-link")
		  	logger.debug "Number of founders: #{founderDivs.count}"

		  	founderDivs.each do |founder|
		  		angelListId = founder['data-id']
			  	angelApiData = agent.get "https://api.angel.co/1/users/"+angelListId
			  	parsedData = JSON.parse(/\{.*\}/.match(angelApiData.content)[0])
			  	linkedinUrl = parsedData['linkedin_url']
			  	logger.debug "Linkedin Profile: #{linkedinUrl}"

			  	@founder = Founder.new
			  	@founder.name = parsedData['name']
			  	@founder.startup_id = @startup.id

			  	# make sure linkedinUrl is not null not or an empty string
			  	if linkedinUrl && linkedinUrl != '' 

				  	begin
					  	linkedinProfile = agent.get linkedinUrl
				  	rescue Mechanize::ResponseCodeError => exception
				  	  next
				  	end

				  	@founder.linkedin_url = linkedinUrl

				  	connections = linkedinProfile.search(".overview-connections p strong").text
				  	logger.debug "Connections: #{connections}"
				  	@founder.connections = connections.to_i
				end  	
			  		
			  	@founder.save

			  	# linkedinProfile = agent.get parsedData['linkedin_url']

			end  	
		end  	
  	end

  end

#   def compare
#   	startupNames = ['InternMatch',
#   	'Spoondate',
#   	'Punchd',
#   	'Rewardli',
#   	'Visual.ly',
#   	'Wednesdays',
#   	'YongoPal',
#   	'Ninua',
#   	'Crowdrally',
#   	'Baydin',
#   	'SpeakerGram',
#   	'955 Dreams',
#   	'myGengo',
#   	'Ginzametrics',
#   	'Saygent',
#   	'Volta',
#   	'AwayFind',
#   	'Social Stork',
#   	'Evoz',
#   	'WorkersNow',
#   	'Motion Math',
#   	'ReadyForZero',
#   	'ToutApp',
#   	'VidCaster',
#   	'ChirpMe',
#   	'DailyAisle',
#   	'From.us',
#   	'Kibin',
#   	'Welcu',
#   	'Ovia',
#   	'Console.fm',
#   	'BugHerd',
#   	'Zerply',
#   	'Skipola',
#   	'WillCall',
#   	'LaunchBit',
#   	'Volta',
#   	'Appetizer',
#   	'Tinfoil Security',
#   	'Culture Kitchen',
#   	'Manpacks',
#   	'Snapette',
#   	'StoryTree',
#   	'PicCollage',
#   	'DailyGobble',
#   	'CoderBuddy',
#   	'Vayable',
#   	'Craft Coffee',
#   	'SingBoard',
#   	'Loku',
#   	'LaunchRock',
#   	'300milligrams',
#   	'72Lux',
#   	'BrandBoards',
#   	'BrightNest',
#   	'Cadee',
#   	'Central.ly',
#   	'Chorus',
#   	'ContaAzul',
#   	'Contactually',
#   	'DressRush',
#   	'eSpark Learning',
#   	'Farmeron',
#   	'Fileboard',
#   	'Fitocracy',
#   	'Forrst',
#   	'Gizmo',
#   	'GoVoluntr',
#   	'Hapyrus',
#   	'HighScore House',
#   	'Intercom',
#   	'LookAcross',
#   	'LoveWithFood',
#   	'Meloncard',
#   	'MeMeTales',
#   	'MoPix',
#   	'OneSchool',
#   	'PayByGroup',
#   	'Redeemr',
#   	'RotaDosConcursos',
#   	'Spinnakr',
#   	'Switchcam',
#   	'Talkdesk',
#   	'Tiny Review',
#   	'WeddingLovely',
#   	'ActivityHero',
#   	'Bluefields',
#   	'Bombfell',
#   	'Network',
#   	'Chalkable',
#   	'Fontacto',
#   	'Groupiter',
#   	'Happy Inspector',
#   	'Ingresse',
#   	'Monogram',
#   	'Glyder',
#   	'PublikDemand',
#   	'Reclip.It',
#   	'Sqoot',
#   	'STORYPANDA',
#   	'Teamly',
#   	'TeliportMe',
#   	'TenderTree',
#   	'Tie Society',
#   	'Timbuktu Labs',
#   	'TokyoOtakuMode',
#   	'Toshl',
#   	'TwitMusic',
#   	'UmbaBox',
#   	'Tuckernuck',
#   	'Wanderable',
#   	'Yogome',
#   	'BabyList',
#   	'Chewse',
#   	'Cinemacraft',
#   	'Club W',
#   	'CompStak',
#   	'Cubie',
#   	'Cuponomia',
#   	'Curious Hat',
#   	'Dealflicks',
#   	'Everbill',
#   	'Femeninas',
#   	'GazeMetrix',
#   	'Hunie',
#   	'Iconfinder',
#   	'iDreamBooks',
#   	'Instamojo',
#   	'Kickfolio',
#   	'LaunchGram',
#   	'Markerly',
#   	'Pick1',
#   	'Privy',
#   	'Qual Canal',
#   	'Repairy',
#   	'SupplyHog',
#   	'Tealet',
#   	'TouristEye',
#   	'TradeBriefs',
#   	'Traity',
#   	'Translate Abroad',
#   	'UniPay',
#   	'WalletKit',
#   	'Wideo',
#   	'WhoAPI',
#   	'AppSocially',
#   	'Binpress',
#   	'BoxC',
#   	'Credii',
#   	'Dakwak',
#   	'Dropifi',
#   	'Feast',
#   	'Floqq',
#   	'Flyer',
#   	'Geekatoo',
#   	'GreenGar',
#   	'InstaGIS',
#   	'KiteReaders',
#   	'Koemei',
#   	'Mayvenn',
#   	'NativeAD',
#   	'PinMyPet',
#   	'POPAPP',
#   	'PriceBaba',
#   	'Reesio',
#   	'School Admissions',
#   	'Seat 14A',
#   	'SeMeAntoja',
#   	'Sverve',
#   	'Tamatem',
#   	'TRDATA',
#   	'Tushky',
#   	'Unda',
#   	'WHILL',
#   	'3Sourcing',
#   	'AdEspresso',
#   	'Anyadir Education',
#   	'Bounty Hunter',
#   	'Buzzstarter',
#   	'BTCJam',
#   	'Builk',
#   	'Carreira Beauty',
#   	'Cityblis',
#   	'EquityZen',
#   	'Goods',
#   	'Grata',
#   	'LaunchTrack',
#   	'MailLift',
#   	'OLSET',
#   	'Partender',
#   	'PlateJoy',
#   	'Popbasic',
#   	'Populr',
#   	'RealtyShares',
#   	'Sales Beach',
#   	'Shopeando',
#   	'Shopseen',
#   	'Sidelines',
#   	'Silverpush',
#   	'uBiome',
#   	'ViralGains',
#   	'WePlann',
#   	'WishPlz',
#   	'ZBoard',
#   	'BidAway',
#   	'primeloop',
#   	'CultureAlley',
#   	'Doorman',
#   	'DOZ',
#   	'Enchanted Diamonds',
#   	'Equipboard',
#   	'FameBit',
#   	'Friend Trusted',
#   	'Guidekick',
#   	'Holidog',
#   	'i3zif.com (Play for Music Limited)',
#   	'Já Entendi',
#   	'Pijon',
#   	'PredictionIO',
#   	'Quest',
#   	'Raisy',
#   	'rapt.fm',
#   	'Remark',
#   	'Roam & Wander',
#   	'ShareRoot Inc.',
#   	'Shippo',
#   	'Simmr',
#   	'SoundBetter',
#   	'Unwind Me',
#   	'VenueSpot',
#   	'Whale Path',
#   	'WUZZUF',
#   	'AbbeyPost',
#   	'ArtCorgi',
#   	'Bohemian Guitars',
#   	'Bonafide',
#   	'click2stream',
#   	'Coinalytics',
#   	'Giveit100',
#   	'GogoCoin',
#   	'GoRefi',
#   	'Hobobe',
#   	'Inductly',
#   	'InterviewMaster',
#   	'KangaDo',
#   	'Lumific',
#   	'Monetsu',
#   	'Neuroware',
#   	'pinshape',
#   	'Pop Up Archive',
#   	'Puzzlium',
#   	'Share Some Style',
#   	'Solidarium',
#   	'Sourceasy',
#   	'Sporthold',
#   	'Stitch',
#   	'Survmetrics',
#   	'TargetingMantra',
#   	'Teaman & Company',
#   	'Thinknum',
#   	'Totspot',
#   	'Vessel',
#   	'Zootrock']

#   	@startupsNotFoundCount = 0
#   	@startupsNotMatchedCount = 0

#   	@startupsNotFound = []
#   	@startupsNotMatched = []

#   	startupNames.each do |startupName|
#   		foundStartup = Startup.where(:name => startupName)

#   		if foundStartup.count == 0
#   			@startupsNotFound.push(startupName)
#   			logger.debug "not found: #{startupName}"
#   			@startupsNotFoundCount+=1
#   		end	
#   	end
  	
#   	logger.debug "startups not found: #{@startupsNotFoundCount}"

#   	@startups = Startup.all

#   	@startups.each do |startup|
#   		if startupNames.include? startup.name
#   		else
#   			@startupsNotMatched.push(startup.name)
#   			@startupsNotMatchedCount+=1
#   		end		
#   	end
  		
#   end	
  
end
