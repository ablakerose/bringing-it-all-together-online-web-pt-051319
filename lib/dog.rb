class Dog

  attr_accessor :name, :breed, :id

  def initialize(id=nil, name:, breed:)
    @id = id
    @breed = breed
    @name = name
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
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

  def self.find_or_create_by(name:, breed:)
      dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND album = ?", name, album)
      if !song.empty?
        song_data = song[0]
        song = Song.new(song_data[0], song_data[1], song_data[2])
      else
        song = self.create(name: name, album: album)
      end
      song
    end

end
