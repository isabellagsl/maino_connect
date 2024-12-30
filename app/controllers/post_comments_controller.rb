class PostCommentsController < ApplicationController
  before_action :set_post_comment, only: [ :update, :destroy ]
  allow_unauthenticated_access only: %i[ create ]

  def create
    current_user = authenticated? ? Current.user : nil
    @post_comment = PostComment.new(post_comment_params.merge(user: current_user))
    if @post_comment.save
      redirect_to @post_comment.post, notice: "Post comment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post_comment.update(post_comment_params[:content])
      redirect_to @post_comment.post, notice: "Post comment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post_comment.destroy
    redirect_to @post_comment.post, notice: "Post comment was successfully destroyed."
  end

  private
    def post_comment_params
      params.require(:post_comment).permit(:content, :post_id)
    end

    def set_post_comment
      @post_comment = PostComment.find(params[:id])
    end
end
