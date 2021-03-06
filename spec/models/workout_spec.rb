require 'rails_helper'

RSpec.describe Workout, type: :model do

  before :each do
    create(:user, kind: :user)
    create(:exercise)
    create(:training_routine)
  end

  describe 'when without required values' do
    before(:each) { @workout = build(:workout) }
    after(:each) { expect(@workout).to be_invalid }
    it 'is invalid when without name' do
      @workout.name = ""
    end
    it 'is invalid when without training_routine' do
      @workout.training_routine = nil
    end
    it 'is invalid when without workout_exercises' do
      @workout.workout_exercises = []
    end
  end

  it 'is invalid when training_routine already have a workout with same name' do
    create(:workout, name: 'A')
    workout = build(:workout, name: 'A')
    expect(workout).to be_invalid
  end

  it 'ok case' do
    workout = create(:workout)
    expect(workout).to be_valid
  end

  it 'is expected to have default status as :progress' do
    workout = build(:workout, status: nil)
    expect(workout).to be_valid
    expect(workout.progress?).to be_truthy
  end

end
