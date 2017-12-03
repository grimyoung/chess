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
      grid.each{|e| p e}
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