module WordSearchService
  class Searcher
    def initialize(params = {})
      @params = params

      if @params.has_key?(:with_deleted) && @params[:with_deleted].to_b
        @relation = Kw::Word.all
      else
        @relation = Kw::Word.enable
      end
    end

    def result
      if @params.has_key?(:fetched)
        @relation = @params[:fetched].to_b ? @relation.fetched : @relation.unfetched
      end

      if @params.has_key?(:selected)
        @relation = @params[:selected].to_b ? @relation.selected : @relation.unselected
      end

      @relation = @relation.search(name_cont: @params[:name]).result if @params.has_key?(:name)
      @relation = @relation.merge(WordSearchService::Order.sort_by_key(@params[:sort_key]))
      @relation
    end
  end

  module Order
    def self.sort_by_key(sort_key)
      case sort_key.try(:to_sym)
      when :rank
        Kw::Word.where('rank > 0').order(rank: :asc)
      when :query_volumes
        Kw::Word.order(avg_searches: :desc)
      end
    end
  end
end
