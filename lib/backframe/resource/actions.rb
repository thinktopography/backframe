module Backframe
  module Resource
    module Actions
      module Index
        def index
          page(resource.includes(self.class.resource_opts[:include]), nil)
        end
      end

      module Create
        def create
          @item = resource.new(allowed_params)
          if @item.save
            if @item.respond_to?(:activities)
              Activity.create!(subject: current_user, text: 'created {object1}', object1: @item)
            end

            render json: @item, status: 201, adapter: Backframe::API::Adapter
          else
            resource_error_response(@item, 422)
          end
        end
      end

      module Show
        def show
          render json: @item, adapter: Backframe::API::Adapter
        end
      end

      module Edit
        def edit
          json = {}
          self.class.resource_opts[:allowed].each do |attribute|
            if(attribute.is_a?(Hash))
              attribute.each do |key,val|
                json[key] = @item.send(key)
              end
            else
              json[attribute] = @item.send(attribute)
            end
          end
          render json: json
        end
      end

      module Update
        def update
          if @item.update_attributes(allowed_params)
            if @item.respond_to?(:activities)
              Activity.create!(subject: current_user, text: 'updated {object1}', object1: @item)
            end

            render json: @item, adapter: Backframe::API::Adapter
          else
            resource_error_response(@item, 422)
          end
        end
      end

      module UpdateAll
        def update_all
          records = []

          ActiveRecord::Base.transaction do
            records = update_all_params.map(&method(:update_record))
          end

          render json: records, adapter: Backframe::API::Adapter
        end

        private

        def update_record(attrs)
          attrs = attrs.with_indifferent_access
          record = resource.find(attrs[:id])
          record.attributes = attrs
          record.save!
          record
        end

        def update_all_params
          permitted = self.class.resource_opts[:allowed] << :id
          params.permit(records: permitted)[:records] || []
        end
      end

      module Destroy
        def destroy
          if @item.destroy
            render nothing: true, status: 204
          else
            resource_error_response(@item, 422)
          end
        end
      end
    end
  end
end
