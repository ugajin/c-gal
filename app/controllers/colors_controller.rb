class ColorsController < ApplicationController

  def index
    @colors = Color.all
  end

  def new
    @color = Color.new
  end

  def create
    @color = Color.new(color_params)
    respond_to do |format|
      if @color.save
        format.html { redirect_to colors_path, notice: 'new color added'  }
        format.json { render :show, status: :created, location: @color }
      else
        format.html { render :new }
        format.json { render json: @color.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def set_color
    @color = Color.find(params[:id])
  end

  def color_params
    params.require(:color).permit(
      :name, 
      :color_code
    )
  end

end
