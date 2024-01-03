class Person < ActiveRecord::Base
  has_many :person_challenges
  has_many :challenges, through: :person_challenges
  has_many :workouts, through: :person_challenges


  validates :name, presence: true

  before_validation :canonicalize_name

  def workout_count(challenge: nil)
    query = workouts
    query = query.where("person_challenges.challenge_id = ?", challenge.id) if challenge

    query.count
  end

  def cost_of(challenge)
    other_participant = challenge.participants.where.not(id: id).first

    my_workout_count = workout_count(challenge: challenge)
    other_workout_count = other_participant.workout_count(challenge: challenge)

    (my_workout_count - other_workout_count) * challenge.cost_per_workout
  end

  private

  def canonicalize_name
    name.downcase! if name
  end
end
