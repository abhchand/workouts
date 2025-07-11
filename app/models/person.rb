class Person < ActiveRecord::Base
  has_many :person_challenges
  has_many :challenges, through: :person_challenges
  has_many :workouts, through: :person_challenges
  has_many :standalone_workouts


  validates :name, presence: true
  validates :password, presence: true

  before_validation :canonicalize_name

  def all_workouts
    workouts.includes(challenge: :participants) + standalone_workouts
  end

  def workout_count(challenge: nil)
    query = workouts
    query = query.where("person_challenges.challenge_id = ?", challenge.id) if challenge

    query.count
  end

  def cost_of(challenge)
    other_participant = challenge.participants.where.not(id: id).first

    my_workout_count    = workout_count(challenge: challenge)
    other_workout_count = other_participant.workout_count(challenge: challenge)

    # Stop counting after reaching the original target
    my_workout_count    = challenge.workout_target if my_workout_count > challenge.workout_target
    other_workout_count = challenge.workout_target if other_workout_count > challenge.workout_target

    (my_workout_count - other_workout_count) * challenge.cost_per_workout
  end

  def record
    [
      challenges.inactive.where(winner: self).count,
      challenges.inactive.where.not(winner: nil).where.not(winner: self).count,
      challenges.inactive.where(winner: nil).count
    ].join("-")
  end

  def win_pct
    win = challenges.inactive.where(winner: self).count
    loss = challenges.inactive.where.not(winner: nil).where.not(winner: self).count
    ties = challenges.inactive.where(winner: nil).count

    total = win + loss + ties
    return 0.to_f if total == 0

    100 * ((win + (0.5 * ties)).to_f / total)
  end

  def winnings
    challenges.inactive.map { |c| cost_of(c) }.sum
  end

  def total_workout_count
    challenges.inactive.map { |c| workout_count(challenge: c) }.sum
  end

  private

  def canonicalize_name
    name.downcase! if name
  end
end
