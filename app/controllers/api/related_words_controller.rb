class Api::RelatedWordsController < ApplicationController
  def create
    word = Kw::RelatedWord.related_word(params[:parent_id], params[:child_id]) || Kw::RelatedWord.new
    if word.update_attributes(parse_related_word_params)
      render json: {}, status: :ok
    else
      render json: {}, status: :bad_request
    end
  end

  def parse_related_word_params
    attr = [:parent_id, :child_id, :same]
    params.permit(*attr)
  end
end
