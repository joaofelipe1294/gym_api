class WorkoutExercise < ApplicationRecord
  belongs_to :exercise
  belongs_to :workout
  validates_presence_of :repetitions, :rest_time, :series_number
  has_many :exercise_reports
end
