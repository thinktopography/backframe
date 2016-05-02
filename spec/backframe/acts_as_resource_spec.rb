require 'spec_helper'

describe 'Backframe::ActsAsResource', type: :controller do
  controller do
    include Backframe::ActsAsAPI
    include Backframe::ActsAsResource

    acts_as_api
    acts_as_resource 'Example', allowed: [:a, :b, :c]

    def base_api_url
      '/example'
    end
  end

  describe '#index' do
    it 'responds with 200 status' do
      get :index, format: :json
      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    let(:params) { attributes_for(:example).merge(format: :json) }

    it 'responds with 201 status' do
      post :create, params
      expect(response.status).to eq 201
    end

    it 'creates record' do
      expect { post :create, params }.to change { Example.count }.by 1
    end

    it 'responds with record' do
      post :create, params
      expect(json_response).to eq serialize(Example.last).stringify_keys
    end

    context 'when save fails' do
      before do
        allow_any_instance_of(Example).to receive(:save) { false }
      end

      it 'responds with 422 status' do
        post :create, params
        expect(response.status).to eq 422
      end

      it 'does not create record' do
        expect { post :create, params }.to change { Example.count }.by 0
      end

      it 'responds with errors' do
        post :create, params
        expect(json_response[:errors]).to be
        expect(json_response[:message]).to be
        expect(json_response[:status]).to eq 422
      end
    end
  end

  describe '#show' do
    let!(:record) { create(:example) }

    it 'responds with 200 status' do
      get :show, id: record.id
      expect(response.status).to eq 200
    end

    it 'responds with record' do
      get :show, id: record.id
      expect(json_response).to eq serialize(record).stringify_keys
    end
  end

  describe '#edit' do
    let!(:record) { create(:example) }

    it 'responds with 200 status' do
      get :edit, id: record.id
      expect(response.status).to eq 200
    end

    it 'responds with record' do
      get :edit, id: record.id
      expect(json_response).to eq serialize(record).stringify_keys
    end
  end

  describe '#update' do
    let!(:record) { create(:example) }
    let(:params) { attributes_for(:example).merge(id: record.id) }

    it 'responds with 200 status' do
      patch :update, params
      expect(response.status).to eq 200
    end

    it 'udpates record' do
      patch :update, params
      expect(json_response[:a]).to eq params[:a]
    end

    it 'responds with updated record' do
      patch :update, params
      expect(json_response).to eq serialize(record.reload).stringify_keys
    end

    context 'when save fails' do
      before do
        allow_any_instance_of(Example).to receive(:save) { false }
        patch :update, params
      end

      it 'responds with 422 status' do
        expect(response.status).to eq 422
      end

      it 'does not update record' do
        expect(record.a).to eq record.reload.a
      end

      it 'responds with errors' do
        expect(json_response[:errors]).to be
        expect(json_response[:message]).to be
        expect(json_response[:status]).to eq 422
      end
    end
  end

  describe '#update_all' do
    let!(:records) { create_list(:example, 3) }
    let(:attrs) { records.map { |record| { id: record.id, a: 'a' } } }
    let(:params) { ActionController::Parameters.new(records: attrs, format: :json) }

    before do
      routes.draw { post :update_all, to: 'anonymous#update_all' }
      post :update_all, params
    end

    it 'responds with 200 status' do
      expect(response.status).to eq 200
    end

    it 'updates all records' do
      records.each { |record| expect(record.reload.a).to eq 'a' }
    end
  end

  describe '#destroy' do
    let!(:record) { create(:example) }

    it 'responds with 204 status' do
      delete :destroy, id: record.id
      expect(response.status).to eq 204
    end

    it 'deletes record' do
      expect { delete :destroy, id: record.id }.to change { Example.count }.by(-1)
    end

    context 'when delete fails' do
      before do
        allow_any_instance_of(Example).to receive(:destroy) { false }
      end

      it 'responds with 422 status' do
        delete :destroy, id: record.id
        expect(response.status).to eq 422
      end

      it 'does not delete record' do
        expect { delete :destroy, id: record.id }.to change { Example.count }.by 0
      end
    end
  end
end
