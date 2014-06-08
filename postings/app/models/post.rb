class Post < ActiveRecord::Base
  belongs_to :user

  def visible_to user
    self.public || self.user == user
  end

  def editable_by user
    self.user == user
  end

  def self.visible_to user
    self.where self.arel_visible_to(user)
  end

  private

  def self.arel_owned_by user
    arel_table[:user_id].eq(user.id)
  end

  def self.arel_public
    arel_table[:public].eq(true)
  end

  def self.arel_visible_to user
    if user.nil?
      self.arel_public
    else
      self.arel_owned_by(user).or(self.arel_public)
    end
  end
end
