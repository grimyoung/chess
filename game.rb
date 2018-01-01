lib_path = File.expand_path(File.dirname(__FILE__))
Dir[lib_path + "/**/*.rb"].each {|file| require file}

module Chess
  class Game
    
  end
end

test = Chess::Board.new
test.display_grid
puts
#p test.valid_moves?("P","w", [2,1])