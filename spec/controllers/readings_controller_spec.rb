require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  before do
    @r1 = create(:reading)
    @r2 = create(:reading)
  end

  describe 'get' do
    it 'returns the reading details' do
      get :get, params: {
          id: @r1.id
      }

      expect(response.status).to eq(200)

      expect(response.body).to eq(@r1.to_json)
    end

    it 'returns client error when reading id is invalid' do
      get :get, params: {
          id: 'invalid_reading'
      }

      expect(response.status).to eq(400)
    end

    it 'returns not found when reading id does not exist' do
      get :get, params: {
          id: -1
      }

      expect(response.status).to eq(404)
    end

    it 'returns not found when reading is deleted' do
      @r1.destroy

      get :get, params: {
        id: @r1.id
      }

      expect(response.status).to eq(404)
    end
  end

  describe 'all' do
    it 'reads all readings' do
      get :all

      expect(response.status).to eq(200)

      expect(response.body).to eq(Reading.all.to_json)
    end

    it 'reads all readings excludes deleted readings' do
      @r1.destroy

      get :all

      expect(response.status).to eq(200)

      expect(Reading.count).to eq(Reading.with_deleted.count - 1)
      expect(response.body).to eq(Reading.all.to_json)
    end
  end

  describe 'approved' do
    it 'reads approved readings' do
      @r1.approve!

      get :approved

      expect(response.status).to eq(200)
      expect(json_response).to eq(JSON.parse([@r1].each.to_json))
    end

    it 'approved readings do not show deleted' do
      @r1.approve!
      @r2.approve!
      @r2.destroy

      get :approved

      expect(response.status).to eq(200)
      expect(json_response).to eq(JSON.parse([@r1].each.to_json))
    end
  end

  describe 'pending' do
    it 'reads pending readings' do
      @r1.approve!

      get :pending

      expect(response.status).to eq(200)
      expect(response.body).to eq(Reading.pending.to_json)
      expect(json_response).not_to include {|r| r['id'] == @r1.id}
    end

    it 'pending readings do not show deleted' do
      @r2.destroy

      get :pending

      expect(response.status).to eq(200)
      expect(response.body).to eq(Reading.pending.to_json)
      expect(json_response).not_to include {|r| r['id'] == @r2.id}
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end