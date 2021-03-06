class DashboardController < ApplicationController
  def show

	require 'mongo'
	mongo_client = Mongo::Connection.new("ds039301.mongolab.com", 39301)
	db = mongo_client.db("ruby_dashboard")
	auth = db.authenticate("user", "password")
	coll = db.collection("archives")

	#db[:archives].find(:type => 'WatchEvent').each do |document|
	#	print document["id"]
  	#end

	listOfTypeEvent = db[:archives].distinct('type')

	@DictNbEvent = Hash.new
	listOfTypeEvent.each do |typeEvent|
		@DictNbEvent[typeEvent] = db[:archives].find(:type=>typeEvent).count
	end

	listEvent = db[:archives].find(:type=>'WatchEvent')
	@DictActor = Hash.new
	@maxName=""
	@max = 0
	listEvent.each do |event|
		if @DictActor[event['actor']['login']] == nil
			@DictActor[event['actor']['login']] = 1
		else
			@DictActor[event['actor']['login']] += 1
			if @max < @DictActor[event['actor']['login']]
				@max = @DictActor[event['actor']['login']]
				@maxName = event['actor']['login']
			end
		end
	end
	tempDictActor = @DictActor
	tempDictActor.each do |actor, value|
		if value < 5
			@DictActor.delete(actor)
		end
	end
	@DictActor=@DictActor.sort_by {|key, value| value}.reverse
  end
end
