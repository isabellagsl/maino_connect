class PostsController < ApplicationController
  def index
    @posts = Post.all
  end


  def show
    @post = Post.find(params[:id])
  end


  def create
    current_user = Current.user
    @post = Post.new(user: current_user, title: post_params[:title], content: post_params[:content])
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end


  def edit
  end

  def update
  end

  def destroy
  end

  private
    def post_params
      params.expect(post: [ :title, :content ])
    end

end
