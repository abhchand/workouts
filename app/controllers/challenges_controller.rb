get "/challenges/new", auth: :person do
  erb :"challenges/new"
end

get "/challenges/:challenge_id", auth: :person do
  @challenge = Challenge.find(params['challenge_id'])
  @participants = @challenge.participants.includes(:workouts).order(:name)
  @workouts = @challenge.workouts.includes(:participant).order(occurred_on: :desc)

  erb :"challenges/show"
end

post "/challenges", auth: :person do
  participants = params["challenge"]["participant_id"].values.map { |id| Person.find(id) }

  if participants.count != 2 || participants.uniq.count != 2
    flash[:error] = "Please select unique participants"
    redirect back
  end

  challenge_params = params["challenge"].dup
  challenge_params.delete("participant_id")
  challenge_params["started_at"] = Time.parse(challenge_params["started_at"])
  challenge_params["ended_at"] = Time.parse(challenge_params["ended_at"])

  challenge = Challenge.new(challenge_params)

  if !challenge.valid?
    flash[:error] = challenge.error_messages
    redirect back
  end

  challenge.save!
  challenge = Challenge.last
  participants.each do |participant|
    PersonChallenge.create!(person: participant, challenge: challenge)
  end

  flash[:success] = "Challenge created"
  redirect "/"
end
