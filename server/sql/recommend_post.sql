-- Function: Increase post recommend
CREATE OR REPLACE FUNCTION on_post_recommend_insert()
RETURNS trigger AS $$
BEGIN
  UPDATE "Post"
  SET Recommend = COALESCE(Recommend, 0) + 1
  WHERE PostID = NEW.PostID;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function: Decrease post recommend
CREATE OR REPLACE FUNCTION on_post_recommend_delete()
RETURNS trigger AS $$
BEGIN
  UPDATE "Post"
  SET Recommend = COALESCE(Recommend, 0) - 1
  WHERE PostID = OLD.PostID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER trg_post_recommend_insert
AFTER INSERT ON "Post_Recommend"
FOR EACH ROW EXECUTE PROCEDURE on_post_recommend_insert();

CREATE TRIGGER trg_post_recommend_delete
AFTER DELETE ON "Post_Recommend"
FOR EACH ROW EXECUTE PROCEDURE on_post_recommend_delete();
