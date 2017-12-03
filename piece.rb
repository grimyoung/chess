module Chess
  class Piece
    def initialize(color, pgn_position)
      @color = color
      @pgn_position = pgn_position
    end
  end

  class Rook < Piece

  end

  class Knight < Piece

  end

  class Bishop < Piece

  end

  class Queen < Piece

  end

  class Pawn < Piece
    def en_passant
    end

    def promote
    end
  end

  class King < Piece
    def is_check?
    end
  end
end