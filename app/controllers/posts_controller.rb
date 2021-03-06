class PostsController < ApplicationController
   before_filter :authenticate_user!, :except => [ :index, :show ,:searchposts ]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  respond_to :html

def myposts


        @posts= Post.where(user_id: current_user.id)

end

def searchposts
  #@posts = Post.paginate(:page => params[:page], :per_page => 3)
@posts = Post.search(params[:search])

#@search = Post.search(params[:search])
  # make name the default sort column
 # @search.sorts = 'title' if @search.sorts.empty?
 # @posts = @search.paginate(params[:page])

  
end


  def index
    @posts = Post.all
    respond_with(@posts)
  end

  def show
      @comment =Comment.new
      @post = Post.find_by_permalink(params[:id])
  end

  def new
       @category = Category.find_by_permalink(params[:category_id])
    #raise @category.inspect
    @post = Post.new
    @all_tags =Tag.all
    @post_tag = @post.posttags.build
  end

  def edit

      #raise params.inspect

      @category  = Category.find(params[:category_id])
      @post = Post.find_by_permalink(params[:id])

      @all_tags =Tag.all
    @post_tag = @post.posttags.build

      #raise @post.inspect
  end

  def create
     # raise params.inspect
    user_id = current_user.id
    params["post"].merge!(user_id: current_user.id)


    @post = Post.new(post_params)
    @post.save

      some_hash = params.require(:tags)

      s = some_hash["id"].size
      for i in 0..s
      ch = some_hash["id"][i]
        if ch.to_s.empty?
        else
          
          @tag = Posttag.new(:post_id => @post.id , :tag_id => ch.to_i )
          @tag.save
      end
    end
     redirect_to categories_path
  end

  def update
    @post.update(post_params)
   redirect_to categories_path
  end

  def destroy
    @post.destroy
   redirect_to categories_path
  end

  private
    def set_post
      @post = Post.find_by_permalink(params[:id])
    end

    def post_params
     params["post"].merge!(user_id: current_user.id)
      params.require(:post).permit(:title, :description , :user_id , :category_id , :image )

    end
end
