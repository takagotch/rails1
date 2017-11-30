class BroadcastCommentJob < ApplicationJob
  queue_as :default

    def perform(comment_obj)
        ActionCable.server.broadcast "chat_channel",
        add_comment: comment_obj.content
    end
end
