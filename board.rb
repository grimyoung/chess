module Chess
  class Board
    attr_accessor :grid,:white_attack,:black_attack

    #top left is (0,0) bottom right is (7,7), (row,column)
    def initialize
      @grid = Array.new(6){Array.new(8)}
      @grid[0] = back_rank('b', [0,0])
      @grid[1] = pawns('b', [1,0])
      @grid[6] = pawns('w', [6,0])
      @grid[7] = back_rank('w', [7,0])
      @white_attack = []
      @black_attack = []
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


    #user input is pgn, code logic uses xy
    #valid input is checked by game.rb
    def move_piece(start_pgn, end_pgn)
      a,b = pgn_to_xy(start_pgn)
      x,y = pgn_to_xy(end_pgn)
      piece = grid[a][b]
      grid[a][b] = nil
      grid[x][y] = piece
      piece.pos = [x,y]
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
            square.moves = square.possible_moves(self)
            if square.color == "w"
              if square.piece.is_a?(Pawn)
                self.white_attack = self.white_attack + square.pawn_attack
              else
                self.white_attack = self.white_attack + square.moves
              end
            else
              if square.piece.is_a?(Pawn)
                self.black_attack = self.black_attack + square.pawn_attack
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

    #[white king position, black king position]
    def king_position(color)
      king_pos = [nil,nil]
      grid.each do |row|
        row.each do |square|
          if square.piece.is_a?(King)
            if piece.color = "w"
              king_pos[0] = piece.pos
            else
              king_pos[1] = piece.pos
            end
          end
        end
      end
      return king_pos
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

