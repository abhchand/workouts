post "/standalone-workouts/:id/destroy", auth: :person do
  workout = StandaloneWorkout.find(params["id"])

  # If you're trying to destroy someone else's workout...
  if workout.person != @person
    flash[:error] = "Insufficient permissions to remove workout"
    redirect back
  end

  workout.destroy!
  redirect back
end
