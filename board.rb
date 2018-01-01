module Chess
  class Board
    attr_accessor :grid, :white_attack, :black_attack

    #top left is (0,0) bottom right is (7,7), (row,column)
    def initialize
      @grid = Array.new(6){Array.new(8)}
      @grid[0] = back_rank('b', [0,0])
      @grid[1] = pawns('b', [1,0])
      @grid[6] = pawns('w', [6,0])
      @grid[7] = back_rank('w', [7,0])

      white_attack = []
      black_attack = []
    end

    #need to make this pretty
    def display_grid
      grid.each do |row|
        row.each do |square|
          if square.nil?
            print " " + "__" + " "
          else
            print " " + square.piece + " "
          end
        end
        print "\n"
      end
    end

    #need to think about user input vs xy as parameters    
    #also en passant
    def move_piece(start_pos, end_pos)
      a,b = pgn_to_xy(start_pos)
      x,y = pgn_to_xy(end_pos)
      piece = grid[a][b]
      color = piece[0]
      #check if king is in check
      #check if valid move
      grid[a][b] = nil
      grid[x][y] = piece
    end

    def pgn_to_xy(pgn)
      column = {'a' => 0,'b' => 1,'c' => 2,'d' => 3,'e' => 4,'f' => 5,'g' => 6,'h' => 7}
      y = column[pgn[0]]
      x = (pgn[1].to_i-8).abs
      return [x,y]
    end

    #part of board set up
    def back_rank(color, pos)
      rank = [Rook.new(color, pos), 
        Knight.new(color,pos), 
        Bishop.new(color,pos),
        Queen.new(color,pos), 
        King.new(color,pos),
        Bishop.new(color,pos),
        Knight.new(color,pos),
        Rook.new(color, pos)]
      col = 0
      rank.each do |piece|
        piece.pos = [pos[0],pos[1]+col]
        col = col + 1
      end
      return rank
    end

    def pawns(color,pos)
      pawn_rank = Array.new(8, Pawn.new(color,pos))
      col = 0
      pawn_rank.each do |piece|
        piece.pos = [pos[0],pos[1]+col]
        col = col + 1
      end
      return pawn_rank
    end

    #end of board setup

    def in_bounds?(pos)
      x,y = pos
      if x >=0 && x <=7 && y >=0 && y <=7
        return true
      end
      return false
    end

    def square_empty?(pos)
      x,y = pos
      if grid[x][y].nil?
        return true
      end
      return false
    end

    def enemy_square?(color,pos)
      x,y = pos
      if grid[x][y].nil?
        return false
      elsif grid[x][y].color != color
        return true
      end
      return false
    end

    def attacked_squares
      grid.each do |row|
        row.each do |square|
          if !square.nil?
            if square.color == "w"
              if square.piece.is_a?(Pawn)
                white_attack = white_attack + square.pawn_attack(grid)
              else
                white_attack = white_attack + square.possible_moves(grid)
              end
            else
                if square.piece.is_a?(Pawn)
                black_attack = black_attack + square.pawn_attack(grid)
              else
                black_attack = black_attack + square.possible_moves(grid)
              end
            end
          end
        end
      end
    end



    def valid_moves?(piece,color,pos)
      moves = []
      case piece
      when "P"
        moves = pawn_moves(color,pos)
      when "N"
        moves = knight_moves(color,pos)
      when "R"
        moves = rook_moves(color,pos)
      when "B"
        moves = bishop_moves(color,pos)
      when "Q"
        moves = queen_moves(color,pos)
      when "K"

      else

      end
    end



  end
end

test = Chess::Board.new
test.display_grid
puts
p test.valid_moves?("P","w", [2,1])
#test.display_grid
