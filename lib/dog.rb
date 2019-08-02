class Dog

  attr_accessor :name, :breed, :id

  def initialize(id=nil, name, breed)
    @id = id 
    @breed = breed
    @name = name
  end


  def self.create_table
  end

  def self.drop_table

  end


end
