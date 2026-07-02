# frozen_string_literal: true

module FlarumImport
  class CategoriesImporter
    def initialize(importer:, database:, logger:)
      @importer = importer
      @database = database
      @logger = logger
    end

    def import
      import_top_level_categories
      import_child_categories
    end

    private

    def import_top_level_categories
      @logger.top_level_categories
      categories = @database.query(SqlHelper.top_level_categories).to_a

      @importer.create_categories(categories) do |category|
        { id: category["id"], name: category["name"] }
      end
    end

    def import_child_categories
      @logger.child_categories
      categories = @database.query(SqlHelper.child_categories).to_a

      @importer.create_categories(categories) do |category|
        {
          id: "child##{category["id"]}",
          name: category["name"],
          description: category["description"],
        }
      end
    end
  end
end
