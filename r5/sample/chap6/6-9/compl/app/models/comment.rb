class Comment < ApplicationRecord
    after_commit do
         BroadcastCommentJob.perform_later(self) 
    end
end
