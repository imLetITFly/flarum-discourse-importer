# frozen_string_literal: true

require "mysql2"

module FlarumImport
  # Owns the connection to the source Flarum database.
  class Database
    def initialize(host:, username:, password:, database:)
      @client =
        Mysql2::Client.new(
          host: host,
          username: username,
          password: password,
          database: database,
        )
    end

    def query(sql)
      @client.query(sql, cache_rows: false)
    end
  end
end
