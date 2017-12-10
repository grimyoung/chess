module Chess
  class Board
    attr_accessor :grid
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



  end
end

test = Chess::Board.new
test.display_grid
