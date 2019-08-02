class Dog

  attr_accessor :name, :breed, :id

  def initialize(attributes)
    attributes.each {|key, value| self.send(("#{key}="), value)}
      self.id ||= nil
  end

  def self.create_table
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
          id INTEGER PRIMARY KEY,
          name TEXT,
          breed TEXT
        )
        SQL

        DB[:conn].execute(sql)
    end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
           DROP TABLE dogs
         SQL
        DB[:conn].execute(sql)
  end

  def self.create(hash_of_attributes)
        dog = self.new(hash_of_attributes)
        dog.save

        dog
    end

    def self.find_by_id(id)
      sql = <<-SQL
        SELECT * FROM dogs WHERE id = ?
      SQL

      DB[:conn].execute(sql, id).map do |row|
binding.pry
        self.new_from_db(row)
      
      end.first

    end

  def self.find_or_create_by(name:, breed:)
      dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
      if !dog.empty?
        dog_data = dog[0]
        dog = Dog.new(dog_data[0], dog_data[1], dog_data[2])
      else
        dog = self.create(name: name, breed: breed)
      end
      dog
    end

end
