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
      intro
      while game_over?(board)
        puts player_color(current_player) + " please make a move"
        user_move = gets.chomp
        while ! valid_input(user_move)
          puts "That was not a valid input."
          puts "Please try again: "
          user_move = gets.chomp
        end
        #now the input is valid 
        #check if input is a legal move
        
      end
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
      #current player is in check and 0 legal_moves
    end

    def legal_moves(current_player)
      #hash with object + moves
    end

    def stalemate?(board_state)
      if turn - last_captured_or_pawn_moved >= 50
        puts "Game over - Stalemate: Over fifty moves without piece capture or pawn moved"
        return true
      end
      if draw_proposal == true
        puts "Game over- Stalemate: Drawn by agreement"
        return true
      end
      #no legal moves but not in check
      #Threefold Repetition
      #Insufficient Mating Material
      return false
    end

    def game_over?(board_state)
      if check_mate?(board_state)
        puts "Game_over by check_mate!"
        return true
      elsif stalemate?(board_state)
        return true
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

    def intro
      puts "Welcome to chess"
      puts "Moves are in the form letternumber e.g. a1"
    end

    def player_color(text)
      if text == "w"
        return "white"
      end
      return "black"
    end

    def valid_input(string)
      if string.length == 2 && string[0] =~ /[[:alpha:]]/ && string[1] =~ /[[:digit:]]/
        return true
      end
      return false
    end
  end
end

test = Chess::Board.new
test.display_grid
# test.remove_piece("f8")
# test.remove_piece("g8")
# test.remove_piece("f1")
# test.remove_piece("g1")

#test.update_board
test.move_piece("d2", "d5")
test.move_piece("f2", "f5")
test.move_piece("e7", "e5")
#test.move_piece("d8", "d7")
test.update_board("w")
p test.grid[3][3].moves
p test.grid[3][5].moves
test.move_piece("c1","c2")
test.update_board("w")
p test.grid[3][3].moves
p test.grid[3][5].moves
#test.attacked_squares
# puts test.ks_castle_possible?("w")
test.display_grid
#test.attacked_squares
#test.inspect