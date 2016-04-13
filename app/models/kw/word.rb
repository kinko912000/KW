module Kw
  class Word < Kw::Base
    scope :fetched, -> { where(fetched: true) }
    scope :unfetched, -> { where(fetched: false) }
    scope :selected, -> { where(selected: true) }
    scope :unselected, -> { where(selected: false) }
  end
end
