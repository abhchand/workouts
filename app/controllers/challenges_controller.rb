get "/challenges" do
  @challenges = Challenge.includes(:participants).order(started_at: :desc)

  erb :"challenges/index"
end

get "/challenges/:challenge_id" do
  @challenge = Challenge.find(params['challenge_id'])
  @participants = @challenge.participants.includes(:workouts).order(:name)
  @workouts = @challenge.workouts.includes(:participant).order(occurred_on: :desc)

  erb :"challenges/show"
end
