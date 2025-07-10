class CreateStandaloneWorkouts < ActiveRecord::Migration[6.0]
  def change
    create_table :standalone_workouts do |t|
      t.timestamps null: false
      t.date :occurred_on, null: false
      t.references :person, index: true, null: false, foreign_key: true
    end
  end
end
