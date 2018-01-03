module Chess
  class Board
    attr_accessor :grid,:white_attack,:black_attack,:white_castled,:black_castled,:enpassant, :enpassant_file

    #top left is (0,0) bottom right is (7,7), (row,column)
    def initialize
      @grid = Array.new(6){Array.new(8)}
      @grid[0] = back_rank('b', [0,0])
      @grid[1] = pawns('b', [1,0])
      @grid[6] = pawns('w', [6,0])
      @grid[7] = back_rank('w', [7,0])
      @white_attack = []
      @black_attack = []
      @white_castled = false
      @black_castled = false
      @enpassant = false
      @enpassant_file = nil
    end

    #need to make this pretty
    def display_grid
      row_num = 8
      grid.each do |row|
       print row_num.to_s + " "
        row.each do |square|
          if square.nil?
            print " " + "__" + " "
          else
            print " " + square.piece + " "
          end
        end
        row_num = row_num - 1
        print "\n"
      end
      print_bottom
      puts
    end

    def print_bottom
      print " " * 3
      col_letter = "a"
      8.times do 
        print col_letter + " " * 3
        col_letter = (col_letter.ord + 1).chr
      end
    end

    def inspect
      grid.each do |row|
        row.each do |square|
          if !square.nil?
            p square
            print "\n"
          end
        end
      end
    end


    #user input is pgn, code logic uses xy (row,col)
    #
    def move_piece(start_pgn, end_pgn)
      a,b = pgn_to_xy(start_pgn)
      x,y = pgn_to_xy(end_pgn)
      piece = grid[a][b]
      color = piece.color
      grid[a][b] = nil
      set_enpassant(piece,x,a,b)
      if piece.is_a?(Pawn) && (x == 0 || x == 7)
        piece = get_promotion(color)
      end

      grid[x][y] = piece
      piece.pos = [x,y]
    end

    def set_enpassant(piece,x,a,b)
      if piece.is_a?(Pawn) && (x-a).abs == 2
        self.enpassant = true
        self.enpassant_file = b
      elsif self.enpassant == true
        self.enpassant = false
        self.enpassant_file = nil
      end
    end

    def remove_piece(pgn)
      x,y = pgn_to_xy(pgn)
      grid[x][y] = nil
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
      pawn_rank = []
      col = 0
      8.times do
        pawn_rank.push(Pawn.new(color,[pos[0],pos[1]+col]))
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

    def friendly_square?(color, pos)
      if !enemy_square?(color,pos) && !square_empty?(pos)
        return true
      end
      return false
    end

    #true if square occupied by opposite color otherwise false
    def enemy_square?(color,pos)
      x,y = pos
      if grid[x][y].nil?
        return false
      elsif grid[x][y].color != color
        return true
      end
      return false
    end

    def square_attacked?(pos, attacked)
      if attacked.include?(pos)
        return true
      end
      return false
    end


    def attacked_squares
      grid.each do |row|
        row.each do |square|
          if !square.nil?
            square.moves = square.possible_moves(self)
            if square.color == "w"
              if square.piece.is_a?(Pawn)
                self.white_attack = self.white_attack + square.p_attack
              else
                self.white_attack = self.white_attack + square.moves
              end
            else
              if square.piece.is_a?(Pawn)
                self.black_attack = self.black_attack + square.p_attack
              else
                self.black_attack = self.black_attack + square.moves
              end
            end
          end
        end
      end
    end

    def reset_defended
      grid.each do |row|
        row.each do |square|
          if !square.nil?
            square.defended = false
          end
        end
      end
    end


    def add_castling(color,king_piece)
      #piece = grid[king_piece[0]][king_piece[1]]
      piece = king_piece
      if ks_castle_possible?(color)
        if color == "w"
          piece.moves.push([7,6])
        else
          piece.moves.push([0,6])
        end
      end
      if qs_castle_possible?(color)
        if color == "w"
          piece.moves.push([7,2])
        else
          piece.moves.push([0,2])
        end
      end
    end

    def update_board(turn_color)
      reset_defended
      attacked_squares
      king_pos = king_position
      if turn_color == "w"
        king_piece = grid[king_pos[0][0]][king_pos[0][1]]
        king_piece.remove_attack_squares(black_attack)
      else
        king_piece = grid[king_pos[1][0]][king_pos[1][1]]
        king_piece.remove_attack_squares(white_attack)
      end
      #if castling is possible add castling moves to king move
      add_castling(turn_color,king_piece)
      king_piece.restrict_pinned_pieces(self)
      #if enpassant is possible add it to pawns on right and left file on the 4th or 5th rank

    end

    #[white king position, black king position]
    def king_position
      king_pieces = [nil,nil]
      grid.each do |row|
        row.each do |square|
          if square.is_a?(King)
            if square.color == "w"
              king_pieces[0] = square.pos
            else
              king_pieces[1] = square.pos
            end
          end
        end
      end
      return king_pieces
    end

    def king_checked?(color)
      white_king_pos, black_king_pos = king_position
      if color == "w"
        if black_attack.include?(white_king_pos)
          return true
        end
      else
        if white_attack.include?(black_king_pos)
          return true
        end
      end
      return false
    end

    def ks_castle_possible?(color)
      white_back_rank = grid[7]
      black_back_rank = grid[0]
      if king_checked?(color)
        return false
      end
      if color == "w" 
        if white_castled == false
          if white_back_rank[4].is_a?(King) && white_back_rank[4].has_moved == false
            if white_back_rank[7].is_a?(Rook) && white_back_rank[7].has_moved == false
              if square_empty?([7,5]) && !square_attacked?([7,5],black_attack) &&
                  square_empty?([7,6]) && !square_attacked?([7,6],black_attack)
                return true
              end
            end
          end
        end
      else
        if black_castled == false
          if black_back_rank[4].is_a?(King) && black_back_rank[4].has_moved == false
            if black_back_rank[7].is_a?(Rook) && black_back_rank[7].has_moved == false
              if square_empty?([0,5]) && !square_attacked?([0,5],white_attack) &&
                  square_empty?([0,6]) && !square_attacked?([0,6],white_attack)
                return true
              end
            end
          end
        end
      end
      return false
    end


    def qs_castle_possible?(color)
      white_back_rank = grid[7]
      black_back_rank = grid[0]
      if king_checked?(color)
        return false
      end
      if color == "w" 
        if white_castled == false
          if white_back_rank[4].is_a?(King) && white_back_rank[4].has_moved == false
            if white_back_rank[0].is_a?(Rook) && white_back_rank[0].has_moved == false
              if square_empty?([7,1]) && !square_attacked?([7,1],black_attack) &&
                  square_empty?([7,2]) && !square_attacked?([7,2],black_attack) &&
                  square_empty?([7,3]) && !square_attacked?([7,3],black_attack)
                return true
              end
            end
          end
        end
      else
        if black_castled == false
          if black_back_rank[4].is_a?(King) && black_back_rank[4].has_moved == false
            if black_back_rank[0].is_a?(Rook) && black_back_rank[0].has_moved == false
              if square_empty?([0,1]) && !square_attacked?([0,1],white_attack) &&
                  square_empty?([0,2]) && !square_attacked?([0,2],white_attack) &&
                  square_empty?([0,3]) && !square_attacked?([0,3],white_attack)
                return true
              end
            end
          end
        end
      end
      return false
    end

    def get_promotion(color)
      puts "Pawn Promotion!"
      puts "What piece do you wish to promote to?"
      puts "Q R B N"
      piece = gets.chomp.upcase
      while !["Q","R","B","N"].include?(piece)
        puts "Invalid choice"
        puts "Q R B N"
      end
      return create_piece(piece,color)
    end

    def create_piece(piece,color)
      case piece
      when "Q"
        return Queen.new(color,nil)
      when "R"
        return Rook.new(color,nil)
      when "B"
        return Bishop.new(color,nil)
      when "N"
        return Knight.new(color,nil)
      end
    end

    # def valid_moves?(piece,color,pos)
    #   moves = []
    #   case piece
    #   when "P"
    #     moves = pawn_moves(color,pos)
    #   when "N"
    #     moves = knight_moves(color,pos)
    #   when "R"
    #     moves = rook_moves(color,pos)
    #   when "B"
    #     moves = bishop_moves(color,pos)
    #   when "Q"
    #     moves = queen_moves(color,pos)
    #   when "K"

    #   else

    #   end
    # end
  end
end

