class StandaloneWorkout < ActiveRecord::Base
  belongs_to :person

  validates :occurred_on, presence: true
  validates :person_id, presence: true
end
