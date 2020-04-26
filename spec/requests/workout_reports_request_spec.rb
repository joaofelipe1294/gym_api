require 'rails_helper'

RSpec.describe "WorkoutReports", type: :request do

  before :each do
    create(:exercise)
    sign_in create(:user, kind: :user)
    create(:training_routine)
    create(:workout)
  end

  describe '#create' do
    
    context 'when request data is invalid' do
      before :each do
        post '/workout_reports', params: { workout_report: { workout_id: 404} }
      end
      it 'is expected to retur status :unprocessable_entity' do
        expect(response).to have_http_status :unprocessable_entity
      end
      it 'is expected to return error message' do
        response_body = JSON.parse response.body
        expect(response_body["errors"].first).to match "Treino é obrigatório(a)"
      end
    end

    context 'when request data is ok' do
      before :each do
        workout = Workout.last
        post '/workout_reports', params: { workout_report: { workout_id: workout.id }}
      end
      it 'is expected to return status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'is expected to return workout_report' do
        response_body = JSON.parse response.body
        workout_report = response_body["workout_report"]
        expect(workout_report["workout_id"]).to eq Workout.last.id
        expect(workout_report["date"]).to eq Date.current.to_s
      end
    end
  end

  describe 'progress' do
    
    context 'when user doesent have a workout_report in progress' do
      it 'is expected to return status not_found' do
        get '/workout_reports/404/progress'
        expect(response).to have_http_status :not_found
      end
    end

    context 'when user has a workout_report in progress' do
      before :each do
        workout_report = create(:workout_report)
        user = User.user.last
        get "/workout_reports/#{user.id}/progress"
      end
      it 'is expected to return status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'is expected to return workout_report' do
        response_body = JSON.parse response.body 
        workout_report = response_body["workout_report"]
        expect(workout_report["id"]).to eq WorkoutReport.last.id
        expect(workout_report["workout_id"]).to eq WorkoutReport.last.workout_id
      end
    end

  end

end
