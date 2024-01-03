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

  def active?
    Time.now <= ended_at
  end

  def participants_as_str(medals: false)
    participants.map do |participant|
      next(participant.name) if !medals || winner.blank?

      str = participant.name
      str += " 🏅" if participant == winner

      str
    end.sort.join(", ")
  end

  def recalculate_winner!
    counts =
      person_challenges.includes(:person).map do |pc|
        [pc.person, workouts.where(person_challenge: pc).count]
      end.sort_by(&:last).reverse

    # If the first count is not strictly greater, we have a tie. In that case,
    # don't return a winner.
    (update!(winner: nil) and return) if counts[0][1] <= counts[1][1]

    update!(winner: counts[0][0])
  end

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
