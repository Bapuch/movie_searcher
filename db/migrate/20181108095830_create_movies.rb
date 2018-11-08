class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.date :release_date
      t.string :director
      t.string :poster_path

      t.timestamps
    end
  end
end
