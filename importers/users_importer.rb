# frozen_string_literal: true

module FlarumImport
  class UsersImporter
    def initialize(importer:, database:, statistics:, logger:, batch_size:)
      @importer = importer
      @database = database
      @statistics = statistics
      @logger = logger
      @batch_size = batch_size
    end

    def import
      @logger.users
      total_count = @statistics.users_count

      @importer.batches(@batch_size) do |offset|
        results = @database.query(SqlHelper.users(@batch_size, offset))

        break if results.size < 1
        next if @importer.all_records_exist? :users, results.map { |user| user["id"].to_i }

        @importer.create_users(results, total: total_count, offset: offset) do |user|
          {
            id: user["id"],
            email: user["email"],
            username: user["username"],
            name: user["username"],
            created_at: user["joined_at"],
            last_seen_at: user["last_seen_at"],
          }
        end
      end
    end
  end
end
