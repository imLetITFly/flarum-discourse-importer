# frozen_string_literal: true

module FlarumImport
  # Centralizes source-post processing so later formatting changes do not leak
  # into topic and reply orchestration.
  module MarkdownHelper
    def process_flarum_post(raw, _import_id)
      raw.dup
    end
  end
end
