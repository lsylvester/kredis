class Contact
  include GlobalID::Identification

  def initialize(id)
    @id = id.to_i
  end

  attr_reader :id

  def self.find(id)
    new(id)
  end

  def self.where(id:)
    id.map{ |id| new(id) }
  end

  def ==(other)
    other.is_a?(self.class) && id == other.try(:id)
  end

end
