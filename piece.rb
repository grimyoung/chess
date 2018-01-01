module Chess
  class Piece
    attr_accessor :pos, :defended
    attr_reader :piece, :color
    def initialize(color, pos)
      @color = color
      @pos = pos
      @defended = false
      @moves = []
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
    def initialize(color, pos)
      @piece = color + "P"
      super
    end


    def possible_moves(board_state)
      @moves = []
      x,y = pos
      if color == "w"
        move_one = [x-1,y]
        move_two = [x-2,y]
        if square_empty?(move_one)
          @moves.push(move_one)
          if x == 6 && square_empty?(move_two)
            @moves.push(move_two)
          end
        end
      else
        move_one = [x+1,y]
        move_two = [x+2,y]
        if square_empty?(move_one)
          @moves.push(move_one)
          if x == 1 && square_empty?(move_two)
            @moves.push(move_two)
          end
        end
      end
      attack = pawn_attack(board_state)
      @moves = @moves + attack
      return @moves
    end

    #mark defended
    def pawn_attack(board_state)
      x,y =  pos
      attack = []
      if color == "w"
        left_cap = [x-1,y-1]
        right_cap = [x-1,y+1]
        if board_state.in_bounds?(left_cap) && board_state.enemy_square?("w",left_cap)
          attack.push(left_cap)
        end
        if board_state.in_bounds?(right_cap) && board_state.enemy_square?("w",right_cap)
          attack.push(right_cap)
        end
      else
        left_cap = [x+1,y-1]
        right_cap = [x+1,y+1]
        if board_state.in_bounds?(left_cap) && board_state.enemy_square?("b",left_cap)
          attack.push(left_cap)
        end
        if board_state.in_bounds?(right_cap) && board_state.enemy_square?("b",right_cap)
          attack.push(right_cap)
        end
      end
      return attack
    end
  end

  class King < Piece
    def initialize(color, pos)
      @piece = color + "K"
      @unit_move = [[1,1], [1,-1], [-1,1],[-1,-1],[1,0], [-1,0], [0,1],[0,-1]]
      super
    end

    def possible_moves(board_state)
      @moves = []
      x,y = pos
      @unit_move.each do |step|
        a,b = x + step[0], y + step[1]
        move_step = [a,b]
        if board_state.in_bounds?(move_step)
          if board_state.enemy_square?(color,move_step)
            if board_state.grid[move_step[0]][move_step[1]].defended == false
              @moves.push(move_step)
            end
          elsif board_state.square_empty?(move_step)
            @moves.push(move_step)
          else
            board_state.grid[move_step[0]][move_step[1]].defended = true
          end
        end
      end
      return @moves
    end

    def remove_attack_squares(attacked_squares)
      @move = @moves.reject{ |step| attacked_squares.include?(step)}
      return @moves
    end

  end
end