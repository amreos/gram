class PicsController < ApplicationController

  before_action :find_pic, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @pics = Pic.all.order("created_at DESC")
  end

  def show

  end

  def new
    @pic = current_user.pics.build
  end

  def create
    @pic = current_user.pics.build(pic_params)
    if @pic.save
      redirect_to @pic,notice: "Yesss! It was posted!"
    else
      render 'new'
    end
  end

  def edit

  end

  def update
      @user ||= User.find_by(id: session[:user_id])

    if @pic.user_id == current_user.id
        
        @pic.update(pic_params)
      redirect_to @pic, notice: "Congrats! Pic was updated"
    elsif  @pic.user_id != current_user.id
    redirect_to root_path, notice: "You are not allowed to do that!!"
else
      render 'edit'
    end
  end

  def destroy
       if @pic.user_id == current_user.id
    @pic.destroy
    redirect_to root_path
     elsif  @pic.user_id != current_user.id
    redirect_to root_path, notice: "You are not allowed to do that!!"
else
          redirect_to root_path

    end
  end

  def upvote
    @pic.upvote_by current_user
    redirect_to :back
  end

  private

  def pic_params
    params.require(:pic).permit(:title,:description, :image)
  end

  def find_pic
    @pic = Pic.find(params[:id])
  end

end