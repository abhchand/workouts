post "/workouts", auth: :person do
  challenge_id = params["workout"]["challenge_id"]
  person_id = params["workout"]["person_id"]
  occurred_on = params["workout"]["occurred_on"]

  if person_id.blank?
    flash[:error] = "Select a participant"
    redirect back
  end

  if occurred_on.blank?
    flash[:error] = "Select a workout date"
    redirect back
  end

  pc = PersonChallenge.find_by(challenge_id: challenge_id, person_id: person_id)

  if pc.blank?
    flash[:error] = "This participant is not involved in this challenge"
    redirect back
  end

  workout = Workout.new(occurred_on: occurred_on, person_challenge_id: pc.id)

  if !workout.valid?
    flash[:error] = workout.error_messages
    redirect back
  end

  workout.save!
  redirect back
end

post "/workouts/:id/destroy", auth: :person do
  workout = Workout.find(params["id"])
  workout.destroy!

  redirect back
end
