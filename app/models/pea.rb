class Pea < ActiveRecord::Base
  validates_presence_of :long_url
  validates_uniqueness_of :key, :long_url

  after_create :build_key

  protected

  def build_key
    self.update_attribute :key, KeyGenerator.generate(self.id)
  end
end
