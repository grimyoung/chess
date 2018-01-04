module Chess
  class Piece
    attr_accessor :pos, :defended, :moves, :path_to_king
    attr_reader :piece, :color
    def initialize(color, pos)
      @pos = pos
      @color = color
      @defended = false
      @moves = []
      @path_to_king = []
    end

    def possible_moves(board_state)
      moves = []
      path_to_king = []
      @unit_move.each do |step|
        a,b = pos[0] + step[0], pos[1] + step[1]
        move_step = [a,b]
        path = []
        blocked = false
        king_found = false
        while(board_state.in_bounds?(move_step) && !blocked)
          if board_state.square_empty?(move_step)
            path.push(move_step)
          elsif board_state.enemy_square?(color,move_step)
            piece = board_state.grid[move_step[0]][move_step[1]]
            if piece.is_a?(King) && piece.color != self.color
              king_found = true
            end
            path.push(move_step)
            blocked = true
          else
            board_state.grid[move_step[0]][move_step[1]].defended = true
            blocked = true
          end
          a,b = move_step[0] + step[0], move_step[1] + step[1]
          move_step = [a,b]
        end
        if king_found
          @path_to_king.push(*path)
          #removes king position
          @path_to_king = @path_to_king[0...-1]
          #adds the piece's position
          @path_to_king.unshift(self.pos)
        end
        moves.push(*path)
      end
      return moves
    end
  end

  class Rook < Piece
    attr_reader :has_moved
    def initialize(color, pos)
      @piece = color + "R"
      @unit_move = [[1,0], [-1,0], [0,1],[0,-1]]
      @has_moved = false
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
          if (board_state.square_empty?(move_step) || board_state.enemy_square?(color,move_step))
            moves.push(move_step)
          else
            board_state.grid[move_step[0]][move_step[1]].defended = true
          end
        end
      end
      return @moves
    end
  end


  class Pawn < Piece
    attr_accessor :p_attack
    def initialize(color, pos)
      @piece = color + "P"
      @p_attack = []
      super
    end

    def possible_moves(board_state)
      @moves = []
      x,y = pos
      if color == "w"
        move_one = [x-1,y]
        move_two = [x-2,y]
        if board_state.square_empty?(move_one)
          @moves.push(move_one)
          if x == 6 && board_state.square_empty?(move_two)
            @moves.push(move_two)
          end
        end
      else
        move_one = [x+1,y]
        move_two = [x+2,y]
        if board_state.square_empty?(move_one)
          @moves.push(move_one)
          if x == 1 && board_state.square_empty?(move_two)
            @moves.push(move_two)
          end
        end
      end
      attack = pawn_attack(board_state)
      @moves = @moves + attack
      return @moves
    end

    def pawn_attack(board_state)
      x,y =  pos
      attack = []
      if color == "w"
        left_cap = [x-1,y-1]
        right_cap = [x-1,y+1]
        if board_state.in_bounds?(left_cap)
          if board_state.enemy_square?("w",left_cap)
            attack.push(left_cap)
          elsif !board_state.square_empty?(left_cap)
            board_state.grid[left_cap[0]][left_cap[1]].defended = true
          end
          @p_attack.push(left_cap)
        end
        if board_state.in_bounds?(right_cap) 
          if board_state.enemy_square?("w",right_cap)
            attack.push(right_cap)
          elsif !board_state.square_empty?(right_cap)
            board_state.grid[right_cap[0]][right_cap[1]].defended = true
          end
          @p_attack.push(right_cap)
        end
      else
        left_cap = [x+1,y-1]
        right_cap = [x+1,y+1]
        if board_state.in_bounds?(left_cap) 
          if board_state.enemy_square?("b",left_cap)
            attack.push(left_cap)
          elsif !board_state.square_empty?(left_cap)
            board_state.grid[left_cap[0]][left_cap[1]].defended = true
          end
          @p_attack.push(left_cap)
        end
        if board_state.in_bounds?(right_cap) 
          if board_state.enemy_square?("b",right_cap)
            attack.push(right_cap)
          elsif !board_state.square_empty?(right_cap)
            board_state.grid[right_cap[0]][right_cap[1]].defended = true
          end
          @p_attack.push(right_cap)
        end
      end
      return attack
    end
  end

  class King < Piece
    attr_reader :has_moved
    def initialize(color, pos)
      @piece = color + "K"
      @unit_move = [[1,1], [1,-1], [-1,1],[-1,-1],[1,0], [-1,0], [0,1],[0,-1]]
      @has_moved = false
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
      @moves = @moves.reject{ |step| attacked_squares.include?(step)}
      return @moves
    end

    def restrict_pinned_pieces(board_state)
      @unit_move.each do |step|
        a,b = pos[0] + step[0], pos[1] + step[1]
        enemy_piece = nil
        friendly_piece = nil
        path = []
        if step[0] == 0 || step[1] == 0
          diagonal = false
        else
          diagonal = true
        end
        move_step = [a,b]
        while(board_state.in_bounds?(move_step) && enemy_piece.nil?)
          if friendly_piece.nil?
            if board_state.friendly_square?(color,move_step)
              friendly_piece = board_state.grid[move_step[0]][move_step[1]]
            end
          else
            path.push(move_step)
            if board_state.friendly_square?(color, move_step)
              break
            end
            if board_state.enemy_square?(color,move_step) && enemy_piece.nil?
              enemy_piece = board_state.grid[move_step[0]][move_step[1]]
            end
          end
          a,b = move_step[0] + step[0], move_step[1] + step[1]
          move_step = [a,b]
        end
        if !enemy_piece.nil? && !friendly_piece.nil?
          if diagonal
            if enemy_piece.is_a?(Queen) || enemy_piece.is_a?(Bishop)
              if friendly_piece.is_a?(Queen) || friendly_piece.is_a?(Bishop)
                friendly_piece.moves = path
              elsif friendly_piece.is_a?(Pawn)
                friendly_piece.p_attack = friendly_piece.p_attack.select{ |move| path.include?(move)}
                friendly_piece.moves = friendly_piece.p_attack
              else
                friendly_piece.moves = []
              end
            end
          else
            if enemy_piece.is_a?(Queen) || enemy_piece.is_a?(Rook)
              if friendly_piece.is_a?(Queen) || friendly_piece.is_a?(Rook)
                friendly_piece.moves = path
              else
                friendly_piece.moves = []
              end
            end
          end
        end
      end
    end
  end
end