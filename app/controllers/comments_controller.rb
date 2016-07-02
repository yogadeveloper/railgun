class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: [:create]

  authorize_resource

  respond_to :json, only: [:vote_up, :vote_down, :remove_vote]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      PrivatePub.publish_to "/comments",
                            comment: @comment.to_json,
                            comment_author: @comment.user.email.to_json
      render nothing: true
    else
      render json: { errors: @comment.errors.full_messages }
    end
  end

  private

  def model_klass
    commentable_name.classify.constantize
  end

  def commentable_name
    params[:commentable].singularize
  end

  def find_commentable
    @commentable = model_klass.find(params["#{commentable_name}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
