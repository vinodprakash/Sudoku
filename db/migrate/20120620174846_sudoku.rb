class Sudoku < ActiveRecord::Migration
	def change
    create_table :sudokus do |t|
      t.text :puzzle
      t.string :difficulty
 
      t.timestamps
    end
	end
end
