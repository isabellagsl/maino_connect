class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    post_title = query_params[:post_title]
    post_tags = query_params[:post_tags]
    page = (query_params[:page] || 1).to_i
    @per_page = 3
    offset = (page - 1) * @per_page
    @posts = Post.filter_by_title(post_title).filter_by_tags(post_tags).offset(offset).limit(@per_page).order(created_at: :desc)
  end


  def show
  end

  def create
    @post = Post.new(user: Current.user, title: post_params[:title], content: post_params[:content])
    if @post.save
      post_tags = get_post_tags_from_params
      add_post_tags(@post, post_tags)
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
      post_tags = get_post_tags_from_params
      current_tags = @post.post_tags.map(&:name)
      new_tags = post_tags - current_tags
      removed_tags = current_tags - post_tags
      add_post_tags(@post, new_tags)
      remove_post_tags(@post, removed_tags)
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
    def set_post
      @post = Post.find(params[:id])
    end

    def query_params
      params.permit(:page, :post_title, :post_tags)
    end

    def post_params
      params.expect(post: [ :title, :content ])
    end

    def post_tags_params
      params.require(:post).permit(:post_tags)
    end

    def get_post_tags_from_params
      post_tags_params[:post_tags].split(",")
    end

    def add_post_tags(post, post_tags)
      post_tags.each do |post_tag|
        tag = PostTag.find_or_create_by(name: post_tag)
        PostTagging.create(post: post, post_tag: tag)
      end
    end

    def remove_post_tags(post, post_tags)
      post_tags.each do |post_tag|
        PostTagging.where(post: post, post_tag: PostTag.find_by(name: post_tag)).destroy_all
      end
    end
end
