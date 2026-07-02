# frozen_string_literal: true

module FlarumImport
  # Contains the source SQL in its original form. These methods only interpolate
  # the existing pagination values; they do not alter query behavior.
  module SqlHelper
    module_function

    def users(batch_size, offset)
      "SELECT id, username, email, joined_at, last_seen_at
         FROM users
         LIMIT #{batch_size}
         OFFSET #{offset};"
    end

    def top_level_categories
      "
                              SELECT id, name, description, position
                              FROM tags
                              ORDER BY position ASC
                            "
    end

    def child_categories
      "
                                       SELECT id, name, description, position
                                       FROM tags
                                       ORDER BY position
                                      "
    end

    def posts(batch_size, offset)
      "
        SELECT p.id id,
               d.id topic_id,
               d.title title,
               d.first_post_id first_post_id,
               p.user_id user_id,
               p.content raw,
               p.created_at created_at,
               t.tag_id category_id
        FROM posts p,
             discussions d,
             discussion_tag t
        WHERE p.discussion_id = d.id
          AND t.discussion_id = d.id
        ORDER BY p.created_at
        LIMIT #{batch_size}
        OFFSET #{offset};
      "
    end
  end
end
