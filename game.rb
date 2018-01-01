lib_path = File.expand_path(File.dirname(__FILE__))
Dir[lib_path + "/**/*.rb"].each {|file| require file}

module Chess
  class Game
    attr_accessor :board, :turn, :current_player
    def initialize
      board = Board.new
      turn = 0
      current_player = "w"
    end

    def play
    end

    def in_check?(board_state)
      if current_player == "w"
        if board_state.black_attack.include?board_state.king_position[0]
          return true
        end
      else
        if board_state.white_attack.include?board_state.king_position[1]
          return true
        end
      end
      return false
    end

    def change_player
      if current_player == "w"
        current_player = "b"
      else
        current_player = "w"
      end
    end

  end
end

test = Chess::Board.new
test.display_grid
puts
#p test.valid_moves?("P","w", [2,1])