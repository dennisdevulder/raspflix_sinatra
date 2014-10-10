class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :identifier
      t.string :poster_path
      t.string :daemon_id
      t.string :path
      t.integer :completed
    end
  end
end
