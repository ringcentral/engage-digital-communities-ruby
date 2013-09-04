module Dimelo
  class Attachment < Dimelo::API::Model
    QUESTION_PATH = 'questions/%{question_id}/attachments/%{id}'
    ANSWER_PATH = 'questions/%{question_id}/answers/%{answer_id}/attachments/%{id}'

    path QUESTION_PATH

    attributes :id, :file, :original, :question_id

    belongs_to :question

    submit_attributes :file, :question_id

    # hack : if criterias includes answer_id we use ANSWER_PATH
    def self.compute_path(criterias={})
      path(ANSWER_PATH) if criterias.has_key? :answer_id
      super
    ensure
      path(QUESTION_PATH)
    end
  end
end
