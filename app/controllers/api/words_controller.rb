class Api::WordsController < ApplicationController
  def destroy
    word = Kw::Word.find(params[:id])
    if word.update_attributes(deleted_at: Time.current)
      render json: {}, status: :ok
    else
      render json: {}, status: :bad_request
    end
  end
end
