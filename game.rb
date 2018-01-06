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
      while !game_over?(board.game_over?(current_player))
        board.update_board
        board.display_grid
        player_check(board)
        puts player_color(current_player) + " please make a move"
        move = get_user_input 
        #check if input is a legal move
        while !board.legal_move?(current_player, move[0],move[1])
          puts "That was not a legal move for that piece"
          puts "Try again"
          move = get_user_input
        end
        board.move_piece[move[0],move[1]]
        change_player
      end
    end

    def player_check(board_state)
      if board_state.king_checked?(current_player)
        puts player_color(current_player) + "is in check!"
      end
    end

    #defined in board.rb
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

    def valid_loop
      user_move = gets.chomp
      while ! valid_input(user_move)
        puts "That was not a valid input."
        puts "Please try again: "
        user_move = gets.chomp
      end
      return user_move
    end

    def get_user_input
      puts "Starting square:"
      start_square = valid_loop
      puts "Ending square:"
      end_square = valid_loop
      return [start_square,end_square]
    end

  end
end

test = Chess::Game.new
test.play
