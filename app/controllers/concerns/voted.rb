module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_up, :vote_down, :remove_vote]
  end

  def vote_up
    if current_user && current_user.owner_of?(@votable)
      render nothing: true, status: 403
    else
      @votable.vote_up(current_user)
      render json: { model: model_klass.to_s.downcase, id: @votable.id, rating: @votable.rating, voted: true}
    end
  end

  def vote_down
    if current_user && current_user.owner_of?(@votable)
      render nothing: true, status: 403
    else
      @votable.vote_down(current_user)
      render json: { model: model_klass.to_s.downcase, id: @votable.id, rating: @votable.rating, voted: true}
    end
  end

  def remove_vote
    if current_user && current_user.owner_of?(@votable)
      render nothing: true, status: 403
    else
      @votable.remove_vote(current_user)
      render json: { model: model_klass.to_s.downcase, id: @votable.id, rating: @votable.rating, voted: false}
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end
end
