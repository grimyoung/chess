module Chess
  class Board
    attr_accessor :grid

    #top left is (0,0) bottom right is (7,7), (row,column)
    def initialize
      @grid = Array.new(6){Array.new(8)}
      @grid[0] = color_pieces('b', back_rank)
      @grid[1] = color_pieces('b', pawns)
      @grid[6] = color_pieces('w', pawns)
      @grid[7] = color_pieces('w', back_rank)
    end

    #need to make this pretty
    def display_grid
      grid.each do |row|
        row.each do |square|
          if square.nil?
            print " " + "__" + " "
          else
            print " " + square + " "
          end
        end
        print "\n"
      end
    end

    #need to think about user input vs xy as parameters    
    def move_piece(start_pos, end_pos)
      a,b = pgn_to_xy(start_pos)
      x,y = pgn_to_xy(end_pos)
      piece = grid[a][b]
      puts piece
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

    def back_rank
      return ["R", "N", "B","Q", "K", "B", "N", "R"]
    end

    def pawns
      return Array.new(8, "P")
    end

    def color_pieces(color, pieces)
      return pieces.map{|e| color + e}
    end

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
      elsif grid[x][y][0] != color
        return true
      end
      return false
    end

    def valid_moves?(piece,color,pos)
      moves = []
      case piece
      when "P"
        moves = pawn_moves(color,pos)
      when "N"
        moves = knight_moves(color,pos)
      when "R"

      when "B"

      when "Q"

      when "K"

      else

      end
    end


    #todo en passant
    def pawn_moves(color,pos)
      x,y = pos
      moves = []

      if color == "w"
        move_one = [x-1,y]
        move_two = [x-2,y]
        if square_empty?(move_one)
          moves.push(move_one)
          if x == 6 && square_empty?(move_two)
            moves.push(move_two)
          end
        end

        left_cap = [x-1,y-1]
        right_cap = [x-1,y+1]
        if in_bounds?(left_cap) && enemy_square?("w",left_cap)
          moves.push(left_cap)
        end
        if in_bounds?(right_cap) && enemy_square?("w",right_cap)
          moves.push(right_cap)
        end
      else
        move_one = [x+1,y]
        move_two = [x+2,y]
        if square_empty?(move_one)
          moves.push(move_one)
          if x == 1 && square_empty?(move_two)
            moves.push(move_two)
          end
        end

        left_cap = [x+1,y-1]
        right_cap = [x+1,y+1]
        if in_bounds?(left_cap) && enemy_square?("b",left_cap)
          moves.push(left_cap)
        end
        if in_bounds?(right_cap) && enemy_square?("b",right_cap)
          moves.push(right_cap)
        end
      end
      return moves
    end

    def knight_moves(color,pos)
      x,y = pos
      moves = []
      possible = [[1,2], [1,-2], [-1,2], [-1,-2], [2,1], [2,-1], [-2,1], [-2,-1]]
      possible.each do |adj|
        a,b = x + adj[0], y + adj[1]
        pos = [a,b]
        if in_bounds?(pos) && (square_empty?(pos) || enemy_square?(color,pos))
          moves.push(pos)
        end
      end
      return moves
    end

    
  end
end

test = Chess::Board.new
test.display_grid
puts
p test.valid_moves?("N","w", [2,1])
#test.display_grid
