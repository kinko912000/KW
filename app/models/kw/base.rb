module Kw
  class Base < ActiveRecord::Base
    self.abstract_class = true

    def model_name
      self.class.to_s.gsub('::', '_').underscore
    end
  end
end