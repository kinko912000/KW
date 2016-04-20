class Api::WordsController < ApplicationController
  def destroy
    word = Kw::Word.find(params[:id])
    if word.update_attributes(deleted_at: Time.current)
      render json: {}, status: :ok
    else
      render json: {}, status: :bad_request
    end
  end

  def update
    word = Kw::Word.find(params[:id])
    if word.update_attributes(parse_word_params)
      render json: {}, status: :ok
    else
      render json: {}, status: :bad_request
    end
  end

  def parse_word_params
    attrs = [:selected]
    params.permit(*attrs)
  end
end
