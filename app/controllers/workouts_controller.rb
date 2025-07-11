get "/workouts", auth: :person do
  @workouts = @person.all_workouts.sort_by(&:occurred_on).reverse

  erb :"workouts/index"
end

post "/workouts", auth: :person do
  person_id = @person.id
  occurred_on = params["workout"]["occurred_on"]

  if occurred_on.blank?
    flash[:error] = "Select a workout date"
    redirect back
  end

  # Find the challenge associated with this workout
  challenge =
    @person
    .challenges
    .where("started_at <= ?", occurred_on)
    .where("ended_at >= ?", occurred_on)
    .first

  if challenge.blank?
    # create standalone workout
    standalone_workout = StandaloneWorkout.new(person: @person, occurred_on: occurred_on)

    if !standalone_workout.valid?
      flash[:error] = standalone_workout.error_messages
      redirect back
      return
    end

    standalone_workout.save!

  else
    # create workout

    pc = PersonChallenge.find_by(challenge: challenge, person: person)
    workout = Workout.new(occurred_on: occurred_on, person_challenge_id: pc.id)

    if !workout.valid?
      flash[:error] = workout.error_messages
      redirect back
      return
    end

    workout.save!
  end

  redirect back
end

post "/workouts/:id/destroy", auth: :person do
  workout = Workout.find(params["id"])

  # If you're trying to destroy someone else's workout...
  if workout.participant != @person
    flash[:error] = "Insufficient permissions to remove workout"
    redirect back
  end

  workout.destroy!
  redirect back
end
