module Dspace
  module Resources
    class CollectionResource < ResourceKit::Resource

      resources do
        default_handler(401) { raise NotAuthorizedError, 'This request requires authentication' }

        action :all, 'GET /rest/collections' do
          query_keys :expand
          handler(200) do |response|
            Dspace::Builders::ModelBuilder.build_collections(JSON.parse(response.body))
          end
        end

        action :find, 'GET /rest/collections/:id' do
          query_keys :expand
          handler(200) do |response|
            Dspace::Collection.new(JSON.parse(response.body))
          end
        end

        action :update, 'PUT /rest/collections/:id' do
          body { |object| JSON.generate(object.to_h) }
          handler(200, 201) { |response| true }
        end

        action :delete, 'DELETE /rest/collections/:id' do
          handler(200, 201, 204) { |response| true }
        end

        action :delete_item, 'DELETE /rest/collections/:id/items/:item_id' do
          handler(200, 201, 204) { |response| true }
        end

        action :items, 'GET /rest/collections/:id/items' do
          query_keys :expand, :limit, :offset
          handler(200) do |response|
            Dspace::Builders::ModelBuilder.build_items(JSON.parse(response.body))
          end
        end

        action :create_item, 'POST /rest/collections/:id/items' do
          body { |object| JSON.generate(object.to_h) }
          handler(200, 201) { |response| true }
        end

      end
    end
  end
end