require 'cgi/escape'
require 'fileutils'

class MemosController < ApplicationController
  before_action :set_memo, only: [:show, :edit, :update, :destroy]
  RE_URL = /((?:http:\/\/|https:\/\/|ftp:\/\/|mailto:|news:\/\/|file:\/\/)[A-Za-z0-9_\#\$%&\-=~@;\+:\.\/\?\\]+)/
  RE_IMG = /\[img:([A-Za-z0-9_\#\$%&\-=~@;\+\.\/\?\\]+):([^\]]+)\]/

  # GET /memos
  # GET /memos.json
  def index
    @keyword = ""
    if params[:keyword] then
      @keyword = params[:keyword]
      Keyword.create(keyword: @keyword) unless Keyword.find_by(keyword: @keyword)
      @memos = Memo.where(['text like ?', "%#{@keyword}%"])
    elsif params[:hashtag] then
      @hashtag = params[:hashtag]
      memo_ids = HashTag.where(tag: @hashtag).select(:memo_id)
      @memos = Memo.where(id: memo_ids)
    elsif params[:category] then
      @category = Category.find(params[:category])
      category_ids = @category.descendants
      @memos = Memo.where(category_id: category_ids).order(:category_id)
    else
      @memos = Memo.all
    end
    @category_paths = Category.pluck(:id, :path).to_h
  end

  # GET /memos/1
  # GET /memos/1.json
  def show
    @pretext = CGI::escapeHTML(@memo.text)
      .gsub(RE_URL){ %Q[<a href="#{$1}" target="_blank">#{$1}</a>] }
      .gsub(RE_IMG){ %Q[<div><img src="#{$1}" width="#{$2}" /></div>] }
      .html_safe
  end

  # GET /memos/new
  def new
    @memo = Memo.new
    @memo.color = Memo::COLORS.first[:code]
  end

  # GET /memos/1/edit
  def edit
  end

  # POST /memos
  # POST /memos.json
  def create
    @memo = Memo.new(memo_params)
    @memo.add_category(params[:category_new])

    respond_to do |format|
      if @memo.save
        format.html { redirect_to @memo, notice: 'Memo was successfully created.' }
        format.json { render :show, status: :created, location: @memo }
      else
        format.html { render :new }
        format.json { render json: @memo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memos/1
  # PATCH/PUT /memos/1.json
  def update
    respond_to do |format|
      if @memo.update(memo_params)
        format.html { redirect_to @memo, notice: 'Memo was successfully updated.' }
        format.json { render :show, status: :ok, location: @memo }
      else
        format.html { render :edit }
        format.json { render json: @memo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memos/1
  # DELETE /memos/1.json
  def destroy
    @memo.destroy
    respond_to do |format|
      format.html { redirect_to memos_url, notice: 'Memo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    file = params["file"]
    newurl = "/images/"+Time.now.strftime("%Y%m%d%H%M%S%L_")+file.original_filename
    newfile = "public"+newurl
    FileUtils.cp(file.tempfile.path, newfile)
    render plain: newurl
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_memo
      @memo = Memo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def memo_params
      params.require(:memo).permit(:title, :text, :color, :category_id)
    end
end
