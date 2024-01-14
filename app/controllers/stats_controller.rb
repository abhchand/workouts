get "/stats", auth: :person do
  @data = Person.all.map do |person|
    {
      name: person.name,
      record: person.record,
      win_pct: person.win_pct,
      workouts: person.total_workout_count,
      winnings: person.winnings
    }
  end.sort do |a,b|
    wins_a = a[:record].split("-").first.to_i
    wins_b = b[:record].split("-").first.to_i

    if a[:win_pct] != b[:win_pct]
      next(b[:win_pct] <=> a[:win_pct])
    end

    if wins_a != wins_b
      next(wins_b <=> wins_a)
    end

    if a[:workouts] != b[:workouts]
      next(b[:workouts] <=> a[:workouts])
    end

    if a[:winnings] != b[:winnings]
      next(b[:winnings] <=> a[:winnings])
    end

    a[:name] <=> b[:name]
  end

  erb :"stats/index"
end
