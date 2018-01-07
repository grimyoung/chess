require_relative "board.rb"
require_relative "piece.rb"

module Chess
  class Game
    attr_accessor :board, :turn, :current_player, :last_captured_or_pawn_moved, :draw_proposal
    def initialize
      @board = Board.new
      @turn = 0
      @current_player = "w"
      @last_captured_or_pawn_moved = 0
      @draw_proposal = 0
    end

    def play
      intro
      board.update_board(current_player)
      while true
        board.update_board(current_player)
        board.display_grid
        player_check(board)
        if board.game_over(current_player)
          game_over_message(current_player)
          puts
          return
        end

        puts player_color(current_player) + " please make a move:"
        move = get_user_input 
        #check if input is a legal move
        while !board.legal_move?(current_player, move[0],move[1])
          board.display_grid
          puts "That was not a legal move for that piece"
          puts "Try again"
          puts
          move = get_user_input
        end
        board.move_piece(move[0],move[1])
        change_player
        
      end
    end

    def player_check(board_state)
      if board_state.king_checked?(current_player)
        puts player_color(current_player) + " is in check!"
      end
    end

    def game_over_message(turn_color)
      color = player_color(turn_color)
      if board.game_over(turn_color) == :checkmate
        puts "Checkmate! " + color + " has lost by checkmate!"
      elsif board.game_over(turn_color) == :stalemate
        puts "Stalemate! " + color + " has no legal moves"
      end
    end

    #defined in board.rb
    def stalemate?(board_state)
      # 50 moves since last capture or pawn moved
      # drawn by agreement
      # no legal moves but not in check
      # Threefold Repetition
      # Insufficient Mating Material
    end

    def change_player
      if self.current_player == "w"
        self.current_player = "b"
      else
        self.current_player = "w"
      end
    end

    def intro
      puts "Welcome to chess"
      puts "Moves are in the form letternumber e.g. a1a2"
    end

    def player_color(text)
      if text == "w"
        return "white"
      end
      return "black"
    end

    def valid_input(string)
      letters = string[0] + string[2]
      nums = string[1] + string[3]
      if string.length == 4 && letters =~ /[[:alpha:]]/ && nums =~ /[[:digit:]]/
        return true
      end
      return false
    end

    def valid_loop
      user_move = gets.chomp
      while ! valid_input(user_move)
        board.display_grid
        puts "That was not a valid input."
        puts "Please try again:"
        user_move = gets.chomp
      end
      return user_move
    end

    def get_user_input
      move = valid_loop
      return [move[0..1],move[2..3]]
    end

  end
end

test = Chess::Game.new.play
# test = Chess::Board.new
# test.move_piece("e2","e4")
# test.move_piece("e7","e5")
# test.move_piece("f1","c4")
# test.move_piece("b8","c6")
# test.move_piece("d1","h5")
# test.move_piece("g8","f6")
# test.move_piece("h5","f7")
# test.display_grid
# test.update_board("b")
