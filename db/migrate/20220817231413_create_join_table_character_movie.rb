class CreateJoinTableCharacterMovie < ActiveRecord::Migration[7.0]
  def change
    create_join_table :characters, :movies do |t|
      t.index [:character_id, :movie_id]
      t.index [:movie_id, :character_id]
    end
  end
end
