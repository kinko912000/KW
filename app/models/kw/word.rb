module Kw
  class Word < Kw::Base
    scope :fetched, -> { where(fetched: true) }
    scope :unfetched, -> { where(fetched: false) }
    scope :selected, -> { where(selected: true) }
    scope :unselected, -> { where(selected: false) }
    scope :has_query_volumes, -> { where('avg_searches > 0') }
  end
end
