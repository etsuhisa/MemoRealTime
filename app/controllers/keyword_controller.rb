class KeywordController < ApplicationController
  def index
    @keywords = Keyword.all
    respond_to do |format|
      format.html
      format.json { render json: @keywords.map{|x| x.keyword} }
    end
  end
end
