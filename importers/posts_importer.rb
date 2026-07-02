# frozen_string_literal: true

module FlarumImport
  class PostsImporter
    def initialize(importer:, database:, statistics:, logger:, batch_size:)
      @importer = importer
      @database = database
      @statistics = statistics
      @logger = logger
      @batch_size = batch_size
    end

    def import
      @logger.posts
      total_count = @statistics.posts_count

      @importer.batches(@batch_size) do |offset|
        results = @database.query(SqlHelper.posts(@batch_size, offset)).to_a

        break if results.size < 1
        next if @importer.all_records_exist? :posts, results.map { |post| post["id"].to_i }

        @importer.create_posts(results, total: total_count, offset: offset) do |post|
          map_post(post)
        end
      end
    end

    private

    def map_post(post)
      mapped = {
        id: post["id"],
        user_id: @importer.user_id_from_imported_user_id(post["user_id"]) || -1,
        raw: process_flarum_post(post["raw"], post["id"]),
        created_at: Time.zone.at(post["created_at"]),
      }

      if post["id"] == post["first_post_id"]
        mapped[:category] =
          @importer.category_id_from_imported_category_id("child##{post["category_id"]}")
        mapped[:title] = CGI.unescapeHTML(post["title"])
      else
        parent = @importer.topic_lookup_from_imported_post_id(post["first_post_id"])
        if parent
          mapped[:topic_id] = parent[:topic_id]
        else
          @logger.missing_parent(post["first_post_id"], post["id"], post["title"])
          return nil
        end
      end

      mapped
    end

    # Retained as the single extension point for source post processing.
    def process_flarum_post(raw, _import_id)
      raw.dup
    end
  end
end
