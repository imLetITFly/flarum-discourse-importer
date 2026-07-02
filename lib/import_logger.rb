# frozen_string_literal: true

module FlarumImport
  # Keeps importer progress output in one place without changing existing text.
  class ImportLogger
    def users
      puts "", "creating users"
    end

    def top_level_categories
      puts "", "importing top level categories..."
    end

    def child_categories
      puts "", "importing children categories..."
    end

    def posts
      puts "", "creating topics and posts"
    end

    def missing_parent(first_post_id, post_id, title)
      puts "Parent post #{first_post_id} doesn't exist. Skipping #{post_id}: #{title[0..40]}"
    end
  end
end
