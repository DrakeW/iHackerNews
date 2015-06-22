class HackerNewsPostsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create] 

  INCORRECT_PARAMETER_ERROR = "Incorrect parameters passed in"

  def index
    @posts = HackerNewsPost.all
    render :json => {:success => true, :info => @posts.order("created_at DESC")}
  end

  # posts/:id
  def show
    if params[:id]
      selected_post = HackerNewsPost.find(params[:id])
      render :json => {:success => true, :info => selected_post}
    else
      render :json => {:success => false, :error => INCORRECT_PARAMETER_ERROR}
    end
  end

  def new
  end

  ## create new post && new relation between user and hackernews post ##
  def create
    if authenticate_post_params
      user = User.find_by_id(params[:user_id])
      new_starred_post = HackerNewsPost.new :url => params[:post_url], :title => params[:post_title], :urlDomain => params[:post_url_domain]
      if new_starred_post.save
        # new_user_post_relation = UsersHackerNewsPostsJoin.new :user_id => user.id, :post_id => new_starred_post.id
        user.hacker_news_posts << new_starred_post
        render :json => {:success => true }
      else
        render :json => {:success => false, :error => new_starred_post.errors.full_messages.to_sentence}
      end
    else
      render :json => {:success => false, :error => INCORRECT_PARAMETER_ERROR}
    end
  end

  def edit; end

  def update; end

  ## destroy relation bewteen given post and user ##
  def destroy
    if authenticate_destroy_params
      post_id = HackerNewsPost.find_by_url(params[:post_url]).id
      user_post_relation = UsersHackerNewsPostsJoin.find({:post_id => post_id, :user_id => params[:user_id]})
      if user_post_relation.destroy
        render :json => {:success => true}
      else
        render :json => {:success => false, :error => user_post_relation.errors.full_messages.to_sentence}
      end
    else
      render :json => {:success => false, :error => INCORRECT_PARAMETER_ERROR}
    end
  end

  protected

  def authenticate_post_params
    params[:post_url].nil? || params[:user_id].nil? || params[:post_url_domain].nil? || params[:post_title].nil? ? false : true
  end

  def authenticate_destroy_params
    params[:post_url].nil? || params[:user_id].nil? ? false : true
  end
end

