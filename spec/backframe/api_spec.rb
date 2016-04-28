require 'spec_helper'

describe 'Backframe::API', type: :controller do
  controller do
    include Backframe::API
    acts_as_api

    def base_api_url
      '/example'
    end
  end

  describe 'error handlng' do
    before { get :index }

    context 'resource not found' do
      controller do
        def index
          raise ActiveRecord::RecordNotFound
        end
      end

      it 'responds with 404 status' do
        expect(response.status).to eq 404
      end

      it 'responds with JSON body' do
        expect(json_response[:error][:status]).to eq 404
        expect(json_response[:error][:message]).to be
      end
    end

    context 'route not found' do
      controller do
        def index
          raise ActionController::RoutingError, ''
        end
      end

      it 'responds with 404 status' do
        expect(response.status).to eq 404
      end

      it 'responds with JSON body' do
        expect(json_response[:error][:status]).to eq 404
        expect(json_response[:error][:message]).to be
      end
    end

    context 'unauthenticated' do
      controller do
        def index
          raise Backframe::Exceptions::Unauthenticated
        end
      end

      it 'responds with 401 status' do
        expect(response.status).to eq 401
      end

      it 'responds with JSON body' do
        expect(json_response[:error][:status]).to eq 401
        expect(json_response[:error][:message]).to be
      end
    end

    context 'unauthorized' do
      controller do
        def index
          raise Backframe::Exceptions::Unauthorized
        end
      end

      it 'responds with 403 status' do
        expect(response.status).to eq 403
      end

      it 'responds with JSON body' do
        expect(json_response[:error][:status]).to eq 403
        expect(json_response[:error][:message]).to be
      end
    end
  end

  describe 'headers' do
    controller do
      def index
        render nothing: true
      end
    end

    it 'responds with Last-Modified header' do
      get :index

      # FIXME: Use timecop here
      expect(response.headers['Last-Modified']).to eq Time.now.httpdate
    end
  end

  describe '#page' do
    let!(:records) { create_list(:example, 10) }

    controller do
      def index
        page(Example.all, nil)
      end
    end

    it 'responds with 200 status' do
      get :index, format: :json
      expect(response.status).to eq 200
    end

    it 'responds with records' do
      get :index, format: :json
      expect(json_response[:records].length).to eq 10
    end

    it 'responds with links' do
      get :index, format: :json
      expect(json_response[:links]).to be
      expect(json_response[:links][:self]).to eq '/example/anonymous.json?page=1'
    end

    context 'with pagination params' do
      before { get :index, page: 2, per_page: 3, format: :json }

      it 'serializes one page of records' do
        expect(json_response[:records].length).to eq 3

        serialized = serialize(Example.sort(Example)[3]).stringify_keys
        expect(json_response[:records].first).to eq serialized
      end

      it 'includes pagination metadata' do
        expect(json_response[:total_records]).to eq 10
        expect(json_response[:total_pages]).to eq 4
        expect(json_response[:current_page]).to eq 2
      end
    end

    context 'without pagination params' do
      before { get :index, format: :json }

      it 'serializes all records' do
        expect(json_response[:records].length).to eq 10

        serialized = serialize(Example.sort(Example).first).stringify_keys
        expect(json_response[:records].first).to eq serialized
      end

      it 'includes pagination metadata' do
        expect(json_response[:total_records]).to eq 10
        expect(json_response[:total_pages]).to eq 1
        expect(json_response[:current_page]).to eq 1
      end
    end

    context 'with sort params' do
      controller do
        def index
          page(Example.all)
        end
      end

      context 'with single param' do
        before do
          create_list(:example, 10)
          get :index, sort: 'a', format: :json
        end

        it 'responds with records sorted ascending' do
          values = json_response[:records].map { |record| record[:a] }
          expect(values).to eq values.sort
        end
      end

      context 'with negated param' do
        before do
          create_list(:example, 10)
          get :index, sort: '-a', format: :json
        end

        it 'responds with records sorted descending' do
          values = json_response[:records].map { |record| record[:a] }
          expect(values).to eq values.sort.reverse
        end
      end

      context 'with multiple params' do
        before do
          create_list(:example, 10, a: 'a')
          create_list(:example, 10)
          get :index, sort: 'a,b', format: :json
        end

        it 'responds with records sorted by both fields' do
          values = json_response[:records].map { |record| [record[:a], record[:b]] }
          expect(values).to eq values.sort
        end
      end
    end

    context 'with field params' do
      let!(:records) { create_list(:example, 10) }

      before { get :index, fields: 'a,b', format: :json }

      it 'only responds with given fields' do
        expect(json_response[:records].first).to eq serialize(Example.sort(Example).first, fields: [:a, :b]).stringify_keys
      end
    end

    context 'with exclude ids params' do
      let!(:records) { create_list(:example, 10) }
      let(:exclude_ids) { records.take(5).map(&:id).join(',') }

      before { get :index, exclude_ids: exclude_ids, format: :json }

      it 'responds with unexcluded records' do
        expect(json_response[:records].length).to eq 5
      end
    end
  end
end
