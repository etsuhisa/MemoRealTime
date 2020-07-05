class HashTagController < ApplicationController
  def index
    @tags = HashTag.all
    respond_to do |format|
      format.html
      format.json { render json: @tags.map{|x| x.tag} }
    end
  end
end
