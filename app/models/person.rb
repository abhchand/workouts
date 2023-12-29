class Person < ActiveRecord::Base
  has_many :person_challenges
  has_many :challenges, through: :person_challenges
  has_many :workouts, through: :person_challenges


  validates :name, presence: true

  before_validation :canonicalize_name

  private

  def canonicalize_name
    name.downcase! if name
  end
end
