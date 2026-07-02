# frozen_string_literal: true

module FlarumImport
  # Reads source record totals used by BaseImporter's progress reporting.
  class Statistics
    def initialize(database)
      @database = database
    end

    def users_count
      @database.query("SELECT count(*) count FROM users;").first["count"]
    end

    def posts_count
      @database.query("SELECT count(*) count from posts").first["count"]
    end
  end
end
