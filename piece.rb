module Chess
  class Piece
    attr_accessor :pos, :defended
    def initialize(color, pos)
      @color = color
      @pos = pos
      @piece = ""
      @defended = false
      @unit_move = []
    end

    def possible_moves(board_state)
      @moves = []
      @unit_move.each do |step|
        a,b = pos[0] + step[0], pos[1] + step[1]
        move_step = [a,b]
        while(board_state.in_bounds?(move_step) && !blocked)
          if board_state.square_empty?(move_step)
            @moves.push(move_step)
          elsif board_state.enemy_square?(color,pos)
            @moves.push(pos)
            blocked = true
          else
            board_state.grid[move_step[0]][move_step[1]].defended = true
            blocked = true
          end
          a,b = move_step[0] + step[0], move_step[1] + step[1]
          move_step = [a,b]
        end
      end
      return @moves
    end

  end

  class Rook < Piece
    def initialize(color, pos)
      @piece = color + "R"
      @unit_move = [[1,0], [-1,0], [0,1],[0,-1]]
      super
    end
  end


  class Bishop < Piece
    def initialize(color, pos)
      @piece = color + "B"
      @unit_move = [[1,1], [1,-1], [-1,1],[-1,-1]]
      super
    end
  end

  class Queen < Piece
    def initialize(color, pos)
      @piece = color + "Q"
      @unit_move = [[1,1], [1,-1], [-1,1],[-1,-1],[1,0], [-1,0], [0,1],[0,-1]]
      super
    end
  end

  class Knight < Piece
    def initialize(color, pos)
      @piece = color + "N"
      @unit_move = [[1,2], [1,-2], [-1,2], [-1,-2], [2,1], [2,-1], [-2,1], [-2,-1]]
      super
    end

    def possible_moves(board_state)
      @moves = []
      x,y = pos
      @unit_move.each do |step|
        a,b = x + step[0], y + step[1]
        move_step = [a,b]
        if board_state.in_bounds?(move_step)
          if (board_state.square_empty?(move_step) || board_state.enemy_square?(color,pos))
            moves.push(pos)
          else
            board_state.grid[move_step[0]][move_step[1]].defended = true
          end
        end
      end
      return @moves
    end
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