# frozen_string_literal: true

require_relative "database"
require_relative "import_logger"
require_relative "statistics"
require_relative "../helpers/sql_helper"
require_relative "../helpers/markdown_helper"
require_relative "../importers/users_importer"
require_relative "../importers/categories_importer"
require_relative "../importers/posts_importer"

# Coordinates each import phase while leaving Discourse's BaseImporter lifecycle
# (including #perform and progress handling) in control.
class ImportScripts::FLARUM < ImportScripts::Base
  FLARUM_HOST = ENV["FLARUM_HOST"] || "db_host"
  FLARUM_DB = ENV["FLARUM_DB"] || "db_name"
  BATCH_SIZE = 1000
  FLARUM_USER = ENV["FLARUM_USER"] || "db_user"
  FLARUM_PW = ENV["FLARUM_PW"] || "db_user_pass"

  def initialize
    super
    database = FlarumImport::Database.new(
      host: FLARUM_HOST,
      username: FLARUM_USER,
      password: FLARUM_PW,
      database: FLARUM_DB,
    )
    logger = FlarumImport::ImportLogger.new
    statistics = FlarumImport::Statistics.new(database)

    # Import order is significant: posts depend on imported users and categories.
    @importers = [
      FlarumImport::UsersImporter.new(
        importer: self, database: database, statistics: statistics,
        logger: logger, batch_size: BATCH_SIZE,
      ),
      FlarumImport::CategoriesImporter.new(importer: self, database: database, logger: logger),
      FlarumImport::PostsImporter.new(
        importer: self, database: database, statistics: statistics,
        logger: logger, batch_size: BATCH_SIZE,
      ),
    ]
  end

  def execute
    @importers.each(&:import)
  end
end
