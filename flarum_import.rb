# frozen_string_literal: true

require "time"
require "date"

require_relative "base"
require_relative "lib/flarum_importer"

ImportScripts::FLARUM.new.perform
