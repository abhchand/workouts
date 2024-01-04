return if Challenge.count > 0

puts "\t=== Seeding Challenge"
c1 = Challenge.create!(
  started_at: "2023-10-01",
  ended_at: "2023-12-31",
  workout_target: 30,
  cost_per_workout: 5
)

puts "\t=== Seeding People"
p1 = Person.create!(name: "Aria",   password: "sekrit")
p2 = Person.create!(name: "Anjali", password: "sekrit")

pc1 = PersonChallenge.create!(person: p1, challenge: c1)
pc2 = PersonChallenge.create!(person: p2, challenge: c1)


puts "\t=== Seeding Workouts"
w11 = Workout.create!(occurred_on: "2023-11-13", person_challenge: pc1)
w11 = Workout.create!(occurred_on: "2023-11-24", person_challenge: pc1)
w21 = Workout.create!(occurred_on: "2023-12-02", person_challenge: pc2)
w21 = Workout.create!(occurred_on: "2023-12-09", person_challenge: pc2)
