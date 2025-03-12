class TweetsController < ApplicationController
  def index
    per_page = (params[:per_page] || 10).to_i
    cursor = params[:cursor] # Timestamp do último tweet carregado
    user_id = params[:user_id] # ID do usuário para filtrar os tweets

    tweets = Tweet.order(created_at: :desc)
    tweets = tweets.where('created_at < ?', Time.at(cursor.to_i)) if cursor.present?
    tweets = tweets.where(user_id: user_id) if user_id.present?
    tweets = tweets.limit(per_page)

    next_cursor = tweets.last&.created_at&.to_i

    render json: { tweets: tweets, next_cursor: next_cursor }
  end
end

