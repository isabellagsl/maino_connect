class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    page = params[:page].to_i || 1
    @per_page = 3
    offset = (page - 1) * @per_page
    @posts = Post.offset(offset).limit(@per_page).order(created_at: :desc)
  end


  def show
  end

  def create
    current_user = Current.user
    @post = Post.new(user: current_user, title: post_params[:title], content: post_params[:content])
    if @post.save
      redirect_to @post, notice: "Post was successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @post = Post.new
  end


  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: "Post was successfully destroyed!"
  end

  private
    def post_params
      params.expect(post: [ :title, :content ])
    end

    def set_post
      @post = Post.find(params[:id])
    end
end
