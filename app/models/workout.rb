class Workout < ActiveRecord::Base
  belongs_to :person_challenge
  has_one :challenge, through: :person_challenge
  has_one :participant, through: :person_challenge, source: :person, inverse_of: :workouts

  validates :occurred_on, presence: true
  validates :person_challenge_id, presence: true
  validate :ocurred_within_challenge_range

  after_create { |w| w.challenge.recalculate_winner! }
  after_destroy { |w| w.challenge.recalculate_winner! }

  private

  def ocurred_within_challenge_range
    return if occurred_on >= challenge.started_at && occurred_on <= challenge.ended_at

    errors.add(
      :occurred_on,
      "Workout does not fall between Challenge start and end dates"
    )
  end
end
