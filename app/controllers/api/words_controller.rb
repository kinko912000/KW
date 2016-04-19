class Api::WordsController < ApplicationController
  def delete
    word = Kw::Word.find(params[:id])
    if word.delete
      render json: {}, status: :ok
    else
      render json: {}, status: :bad_request
    end
  end
end
