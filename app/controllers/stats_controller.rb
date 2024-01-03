get "/stats", auth: :person do
  @data = Person.all.order(:name).map do |person|
    {
      name: person.name,
      record: person.record,
      workouts: person.total_workout_count,
      winnings: person.winnings
    }
  end.sort { |a,b| b[:workouts] <=> a[:workouts] }

  erb :"stats/index"
end
