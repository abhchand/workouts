class PersonChallenge < ActiveRecord::Base
  belongs_to :person
  belongs_to :challenge
  has_many :workouts

  validates :person_id, presence: true
  validates :challenge_id, presence: true
end
