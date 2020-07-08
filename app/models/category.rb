class Category < ApplicationRecord
  has_many :memos
  before_save :create_path
  def create_path
    if self.parent && self.parent != -1 &&
      (parent = Category.find_by(id: self.parent)) then
      self.path = parent.path + " / " + self.name
    else
      self.path = self.name
    end
    return true
  end
  def descendants
    categories = Category.all.to_a
    parents = w_parents = [self.id]
    loop do
      w_parents = Category.children(w_parents, categories).map{|x| x.id}
      return parents if w_parents.empty?
      parents += w_parents
    end
    return parents
  end
  def Category.children(parents, categories)
    if Array === parents then
      return categories.select{|x| parents.include?(x.parent)}
    else
      return categories.select{|x| parents == x.parent}
    end
  end
  def Category.tree(parent=-1, categories=nil)
    categories = Category.all unless categories
    children(parent, categories).map{|x| [x, tree(x.id, categories)]}
  end
end
