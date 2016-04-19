require 'adwords_api'
module AdwordsFetcher
  API_VERSION = :v201603
  PAGE_SIZE = 1000

  def self.update_keyword_query_volumes
    Kw::Word.unfetched.find_in_batches(batch_size: 100) do |words|
      keyword_list = words.map { |word| word.name }
      results = get_keyword_ideas(keyword_list)

      ActiveRecord::Base.transaction do
        results.each { |result| update_query_volumes!(result[:data]) }
        Kw::Word.where(id: words.map(&:id)).update_all(fetched: true)
      end

      puts "Total keywords related to %d." % results.length
    end
  end

  def self.get_keyword_ideas(keyword_list)
    adwords = AdwordsApi::Api.new

    targeting_idea_srv = adwords.service(:TargetingIdeaService, API_VERSION)

    selector = generate_selector_params(keyword_list)
    offset = 0
    results = []

    begin
      page = targeting_idea_srv.get(selector)
      results += page[:entries] if page and page[:entries]

      offset += PAGE_SIZE
      selector[:paging][:start_index] = offset
    end while offset < page[:total_num_entries]
    results
  end

  def self.update_query_volumes!(data)
    keyword = data['KEYWORD_TEXT'][:value]

    if word = Kw::Word.find_by(name: keyword).presence
      word_params = {
        avg_searches: data['SEARCH_VOLUME'][:value],
        competition: data['COMPETITION'][:value],
      }
      word.update_attributes(word_params)
    else
      puts "Could not find: #{keyword}"
    end
  end

  def self.generate_selector_params(keyword_list)
    requested_attribute_types = [
      'KEYWORD_TEXT',
      'SEARCH_VOLUME',
      'COMPETITION'
    ]

    {
      :idea_type => 'KEYWORD',
      :request_type => 'STATS',
      :requested_attribute_types => requested_attribute_types,
      :search_parameters => [
          {
            :xsi_type => 'RelatedToQuerySearchParameter',
            :queries => keyword_list,
          },
          {
            :xsi_type => 'LanguageSearchParameter',
            :languages => [{:id => 1005}]
          },
          {
            :xsi_type => 'NetworkSearchParameter',
            :network_setting => {
              :target_google_search => true,
              :target_search_network => false,
              :target_content_network => false,
              :target_partner_search_network => false,
            }
          }
        ],
        :paging => {
          :start_index => 0,
          :number_results => PAGE_SIZE
        }
    }
  end
end
AdwordsFetcher.update_keyword_query_volumes
