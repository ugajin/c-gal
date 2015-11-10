class PicturesController < ApplicationController

  def index
    @pictures = Picture.all
  end

  def show
  end

  def create
    path = 'public/images'
    picture = Picture.create

    File.open("#{Rails.root}/#{path}/#{picture.id}.png", "wb") do |f|
      f.write Base64.decode64(params[:data].sub!('data:image/png;base64,', ''))
    end

    redirect_to :action => "index"
    render :nothing => true
  end
end
