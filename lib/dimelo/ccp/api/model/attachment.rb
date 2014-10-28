module Dimelo::CCP
  class Attachment < Dimelo::CCP::API::Model
    attributes :id, :file, :original, :question_id
  end

  class AnswerAttachment < Attachment
    path 'questions/%{question_id}/answers/%{answer_id}/attachments/%{id}'

    attributes :id, :file, :original, :answer_id, :question_id

    belongs_to :answer

    submit_attributes :file, :question_id, :answer_id
  end

  class FeedbackCommentAttachment < Attachment
    path 'feedbacks/%{feedback_id}/comments/%{comment_id}/attachments/%{id}'

    attributes :id, :file, :original, :feedback_id, :comment_id
    belongs_to :feedback_comment

    submit_attributes :file, :question_id, :answer_id
  end

  class QuestionAttachment < Attachment
    path 'questions/%{question_id}/attachments/%{id}'

    attributes :id, :file, :original, :question_id

    belongs_to :question

    submit_attributes :file, :question_id
  end

  class FeedbackAttachment < Attachment
    path 'feedbacks/%{feedback_id}/attachments/%{id}'

    attributes :id, :file, :original, :feedback_id

    belongs_to :question

    submit_attributes :file, :feedback_id
  end
end
