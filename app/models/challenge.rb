class Challenge < ActiveRecord::Base
  has_many :person_challenges
  has_many :participants, through: :person_challenges, source: :person, inverse_of: :challenges
  has_many :workouts, through: :person_challenges
  belongs_to  :winner, class_name: 'Person'

  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :workout_target, presence: true, numericality: { greater_than: 0 }
  validates :cost_per_workout, presence: true, numericality: { greater_than: 0 }
  validate :it_starts_before_it_ends
  validate :winner_is_a_participant

  private

  def it_starts_before_it_ends
    return if started_at < ended_at

    errors.add(:started_at, "Start date must be before End date")
  end

  def winner_is_a_participant
    return if winner.blank?
    return if participants.include?(winner)

    errors.add(:winner_id, "Winner must be one of the participants")
  end
end
