-- Function: Increase game recommend
CREATE OR REPLACE FUNCTION on_game_recommend_insert()
RETURNS trigger AS $$
BEGIN
  UPDATE "Game"
  SET Recommend = COALESCE(Recommend, 0) + 1
  WHERE GameID = NEW.GameID;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function: Decrease game recommend
CREATE OR REPLACE FUNCTION on_game_recommend_delete()
RETURNS trigger AS $$
BEGIN
  UPDATE "Game"
  SET Recommend = COALESCE(Recommend, 0) - 1
  WHERE GameID = OLD.GameID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER trg_game_recommend_insert
AFTER INSERT ON "Game_Recommend"
FOR EACH ROW EXECUTE PROCEDURE on_game_recommend_insert();

CREATE TRIGGER trg_game_recommend_delete
AFTER DELETE ON "Game_Recommend"
FOR EACH ROW EXECUTE PROCEDURE on_game_recommend_delete();