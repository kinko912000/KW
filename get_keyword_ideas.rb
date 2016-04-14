#!/usr/bin/env ruby
# Encoding: utf-8
#
# Copyright:: Copyright 2011, Google Inc. All Rights Reserved.
#
# License:: Licensed under the Apache License, Version 2.0 (the "License");
#           you may not use this file except in compliance with the License.
#           You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#           Unless required by applicable law or agreed to in writing, software
#           distributed under the License is distributed on an "AS IS" BASIS,
#           WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#           implied.
#           See the License for the specific language governing permissions and
#           limitations under the License.
#
# This example retrieves keywords that are related to a given keyword.

require 'adwords_api'

def get_keyword_ideas(keyword_list)
  # AdwordsApi::Api will read a config file from ENV['HOME']/adwords_api.yml
  # when called without parameters.
  adwords = AdwordsApi::Api.new

  # To enable logging of SOAP requests, set the log_level value to 'DEBUG' in
  # the configuration file or provide your own logger:
  # adwords.logger = Logger.new('adwords_xml.log')

  targeting_idea_srv = adwords.service(:TargetingIdeaService, API_VERSION)

  # see selector
  # https://developers.google.com/adwords/api/docs/reference/v201603/TargetingIdeaService.TargetingIdeaSelector#ideatype
  # Construct selector object.
  selector = {
    :idea_type => 'KEYWORD',
    :request_type => 'STATS',
    :requested_attribute_types =>
        ['KEYWORD_TEXT', 'SEARCH_VOLUME', 'CATEGORY_PRODUCTS_AND_SERVICES', 'TARGETED_MONTHLY_SEARCHES', 'AVERAGE_CPC', 'COMPETITION'],
    :search_parameters => [
      {
        # The 'xsi_type' field allows you to specify the xsi:type of the object
        # being created. It's only necessary when you must provide an explicit
        # type that the client library can't infer.
        :xsi_type => 'RelatedToQuerySearchParameter',
        :queries => keyword_list,
        # :queries => [keyword_text, '胡蝶蘭 3本立ち', '胡蝶蘭 花言葉', '胡蝶蘭 NHK']
      },
      {
        # Language setting (optional).
        # The ID can be found in the documentation:
        #  https://developers.google.com/adwords/api/docs/appendix/languagecodes
        # Only one LanguageSearchParameter is allowed per request.
        :xsi_type => 'LanguageSearchParameter',
        :languages => [{:id => 1005}]
      },
      {
        # Network search parameter (optional).
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

  # Define initial values.
  offset = 0
  results = []

  begin
    # Perform request.
    page = targeting_idea_srv.get(selector)
    results += page[:entries] if page and page[:entries]

    # Prepare next page request.
    offset += PAGE_SIZE
    selector[:paging][:start_index] = offset
  end while offset < page[:total_num_entries]

  # Display results.
  results.each do |result|
    data = result[:data]
    keyword = data['KEYWORD_TEXT'][:value]
    puts "Found keyword with text '%s'" % keyword
    products_and_services = data['CATEGORY_PRODUCTS_AND_SERVICES'][:value]
    if products_and_services
      puts "\tWith Products and Services categories: [%s]" %
          products_and_services.join(', ')
    end
    average_monthly_searches = data['SEARCH_VOLUME'][:value]
    if average_monthly_searches
      puts "\tand average monthly search volume: %d" % average_monthly_searches
    end
  end
  puts "Total keywords related to '%s': %d." % [keyword_text, results.length]
end

if __FILE__ == $0
  API_VERSION = :v201603
  PAGE_SIZE = 1000

  begin
    #keyword_text = '胡蝶蘭,胡蝶蘭 世界ラン展,胡蝶蘭 NHK,胡蝶蘭 あああああああああああ'
    keyword_text = '胡蝶蘭'
    keyword_list = [
'母の日ギフト 胡蝶蘭',
'胡蝶蘭の鉢',
'銀座 胡蝶蘭',
'退職祝い 胡蝶蘭',
'胡蝶蘭 産地',
'胡蝶蘭 メッセージカード',
'胡蝶蘭 選び方',
'胡蝶蘭 当日配送',
'就任祝い 胡蝶蘭',
'胡蝶蘭 当日配達',
'胡蝶蘭 花屋',
'胡蝶蘭 値段 相場',
'胡蝶蘭 移転祝い',
'胡蝶蘭 郵送',
'胡蝶蘭 北海道',
'胡蝶蘭 価格 相場',
'胡蝶蘭 購入',
'祝い 胡蝶蘭',
'ミディー胡蝶蘭',
'胡蝶蘭 大輪',
'青 胡蝶蘭',
'黄色の胡蝶蘭',
'黄色い胡蝶蘭',
'ブルー胡蝶蘭',
'赤い胡蝶蘭',
'ミディ胡蝶蘭 ギフト',
'割烹温泉旅館 胡蝶蘭',
'胡蝶蘭 枯れそう',
'胡蝶蘭 花言葉 色',
'胡蝶蘭 当日配達ガーデン新橋',
'胡蝶蘭 花言葉 英語',
'胡蝶蘭 あすに届けるお花屋さん',
'胡蝶蘭 元気がない',
'胡蝶蘭 水やり 冬',
'胡蝶蘭 肥料 時期',
'胡蝶蘭 毒性',
'胡蝶蘭 花言葉 赤',
'胡蝶蘭 育て方 花が終わったら',
'胡蝶蘭掲示板',
'胡蝶蘭 管理方法',
'胡蝶蘭 鉢植え 育て方',
'胡蝶蘭 読み方',
'胡蝶蘭 枯れてきたら',
'胡蝶蘭 台湾',
'胡蝶蘭の育て方花茎写真',
'胡蝶蘭が枯れたら',
'胡蝶蘭 ミズゴケ',
'胡蝶蘭 鉢植え 手入れ',
'胡蝶蘭 鳥羽市',
'胡蝶蘭 花言葉 青',
'鳥羽温泉 胡蝶蘭',
'胡蝶蘭 花言葉 ピンク',
'胡蝶蘭栽培法',
'胡蝶蘭の肥料のやり方',
'胡蝶蘭 湿度',
'胡蝶蘭舞',
'三重県 ホテル胡蝶蘭',
'胡蝶蘭のイラスト',
'胡蝶蘭 イメージ',
'胡蝶蘭の育て方 手入れの仕方',
'胡蝶蘭の花がしおれたら',
'胡蝶蘭 原産地',
'胡蝶蘭 宅急便',
'ミディ胡蝶蘭とは',
'胡蝶蘭の栽培方法',
'胡蝶蘭アート',
'お祝い胡蝶蘭相場',
'花 ギフト 胡蝶蘭',
'鳥羽 旅館 胡蝶蘭',
'胡蝶蘭 電報',
'母の日 ミニ胡蝶蘭',
'胡蝶蘭 通販 楽天',
'胡蝶蘭の育て方 夏',
'胡蝶蘭 育て方 鉢植え',
'胡蝶蘭 即日配達ガーデン',
'胡蝶蘭の育て方 葉が黄色',
'胡蝶蘭をもらったら',
'開店祝い 胡蝶蘭 なぜ',
'ミディ胡蝶蘭 母の日',
'胡蝶蘭 結婚祝い',
'胡蝶蘭生産販売',
'胡蝶蘭生産地',
'胡蝶蘭 翌日配達',
'胡蝶蘭 即日配達',
'胡蝶蘭 送料無料',
'胡蝶蘭 ピンク 値段',
'胡蝶蘭 ギフト 格安',
'胡蝶蘭 青色',
'胡蝶蘭 紫色',
'母の日 プレゼント 胡蝶蘭',
'胡蝶蘭 ネット販売',
'胡蝶蘭 値段 3本',
'母の日 胡蝶蘭 送料無料',
    ]
    get_keyword_ideas(keyword_list)

  # Authorization error.
  rescue AdsCommon::Errors::OAuth2VerificationRequired => e
    puts "Authorization credentials are not valid. Edit adwords_api.yml for " +
        "OAuth2 client ID and secret and run misc/setup_oauth2.rb example " +
        "to retrieve and store OAuth2 tokens."
    puts "See this wiki page for more details:\n\n  " +
        'https://github.com/googleads/google-api-ads-ruby/wiki/OAuth2'

  # HTTP errors.
  rescue AdsCommon::Errors::HttpError => e
    puts "HTTP Error: %s" % e

  # API errors.
  rescue AdwordsApi::Errors::ApiException => e
    puts "Message: %s" % e.message
    puts 'Errors:'
    e.errors.each_with_index do |error, index|
      puts "\tError [%d]:" % (index + 1)
      error.each do |field, value|
        puts "\t\t%s: %s" % [field, value]
      end
    end
  end
end
