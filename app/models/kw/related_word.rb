module Kw
  class RelatedWord < Kw::Base
    def self.related_word(parent_id, child_id)
      Kw::RelatedWord.find_by(parent_id: parent_id, child_id: child_id) ||
        Kw::RelatedWord.find_by(parent_id: child_id, child_id: parent_id)
    end

    def self.related_words(id)
      Kw::RelatedWord.where(parent_id: id).concat(Kw::RelatedWord.where(child_id: id)).uniq
    end
  end
end
