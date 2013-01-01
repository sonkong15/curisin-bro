class StaticPagesController < ApplicationController
  
  def home
     @posts = Post.order("created_at DESC").limit(5)
  end

  def help
  end

  def about
  end

  def contact
  end

  def terms
  end

  def privacy
  end
end
