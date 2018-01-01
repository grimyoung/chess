require_relative "board.rb"
require_relative "piece.rb"

module Chess
  class Game
    attr_accessor :board, :turn, :current_player, :last_captured_or_pawn_moved, :draw_proposal
    def initialize
      board = Board.new
      turn = 0
      current_player = "w"
      last_captured_or_pawn_moved = 0
      draw_proposal = 0
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

    def check_mate?(board_state)
      
    end

    def stalemate?(board_state)
      if turn - last_captured_or_pawn_moved >= 50
        puts "Game over - Stalemate: Over fifty moves without piece capture or pawn moved"
      end
      if draw_proposal == true
        puts "Game over- Stalemate: Drawn by agreement"
      end
      #no legal moves but not in check
      #Threefold Repetition
      #Insufficient Mating Material
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
test.attacked_squares
test.inspect