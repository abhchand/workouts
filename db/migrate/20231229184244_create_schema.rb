class CreateSchema < ActiveRecord::Migration[6.0]
  def change
    create_table :challenges do |t|
      t.timestamps null: false
      t.date :started_at, null: false
      t.date :ended_at, null: false, index: true
      t.integer :workout_target, null: false
      t.decimal :cost_per_workout, null: false
      # Foreign key added manually below
      t.references :winner, references: :people, index: true, null: true
    end

    create_table :people do |t|
      t.timestamps null: false
      # Unique index added manually below
      t.string :name, null: false, index: false
      t.string :password, null: false
    end

    create_table :person_challenges do |t|
      t.timestamps null: false
      # Compound index added manually below
      t.references :person, references: :people, index: false, null: false, foreign_key: true
      t.references :challenge, index: false, null: false, foreign_key: true
    end

    create_table :workouts do |t|
      t.timestamps null: false
      t.date :occurred_on, null: false
      t.references :person_challenge, index: true, null: false, foreign_key: true
    end

    add_index :people, :name, unique: true
    add_index :person_challenges, %i[person_id challenge_id], unique: true

    # Can't use `foreign_key:` option when using `references:` option
    # Add it explicitly
    add_foreign_key :challenges, :people, column: :winner_id
  end
end
