class TweetsController < ApplicationController

  def index
    @tweets = Tweet.all.order(created_at: :desc)#.limit(10)
    # @tweet = current_user.tweets.build(user_id: params[:user_id])
    puts "Yes, you enter index!"
    if params[:id]
      puts "This is update."
      set_tweet
    else
      puts "This is create."
      @tweet = Tweet.new
      @tweet.user = current_user
    end
    # 基於測試規格，必須講定變數名稱，請用此變數中存放關注人數 Top 10 的使用者資料
    @users = User.order(followers_count: :desc).limit(10)
  end

  def new
    @tweet = Tweet.new
  end
  
  def create
    raise
    puts "Yes. You enter the create."
    @tweet = Tweet.new(tweet_params)
    @tweet.save
    # if @tweet.save

    #   flash[:notice] = "tweet was successfully created"
    #   redirect_to root_path

    # else
    #   flash.now[:notice] = "WTF"
    #   @tweets = Tweet.all
    #   render :index
    # end
  end

  def update
    puts "WTF"
    
  end

  def like
  end

  def unlike
  end

  private

  def tweet_params
    puts "enter the strong params"
    params.require(:tweet).permit(:description)
  end

end
