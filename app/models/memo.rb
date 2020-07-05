class Memo < ApplicationRecord
  COLORS = [
    {name: "white",   code: "#ffffff"},
    {name: "red",     code: "#ffc0c0"},
    {name: "green",   code: "#c0ffc0"},
    {name: "blue",    code: "#c0c0ff"},
    {name: "yellow",  code: "#ffffc0"},
    {name: "purple",  code: "#ffc0ff"},
    {name: "skyblue", code: "#c0ffff"}
  ]

  belongs_to :category
  has_many :hash_tags, dependent: :destroy
  #before_save :add_category
  after_save :save_file, :update_hashtag
  validate :check_time, on: :update
  def check_time
    cur = Memo.find(self.id)
    errors.add :updated_at, "Memo already changed."  if cur.updated_at != self.updated_at
  end
  def update_hashtag
    tags = self.text.scan(/[#]([^#\s]+)/).flatten.uniq.map{|x| HashTag::new(memo_id:self.id, tag:x)}
    HashTag.where(memo_id: self.id).delete_all
    HashTag.import(tags)
  end
  def save_file
    fpath = "text/#{self.id}.txt"
    File::open(fpath, "w") do |f|
      f.puts self.title
      f.puts "-"*80
      self.text.each_line do |line|
        f.puts line.chomp
      end
    end
  end
  def add_category(category_new)
    return true if category_new.nil? || category_new.empty?
    category = Category.create(name: category_new, parent: self.category_id)
    self.category_id = category.id
    return true
  end
end
