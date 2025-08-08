-- Function: Increase comment recommend
CREATE OR REPLACE FUNCTION on_comment_recommend_insert()
RETURNS trigger AS $$
BEGIN
  UPDATE "Comment"
  SET Recommend = COALESCE(Recommend, 0) + 1
  WHERE CommentID = NEW.CommentID;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function: Decrease comment recommend
CREATE OR REPLACE FUNCTION on_comment_recommend_delete()
RETURNS trigger AS $$
BEGIN
  UPDATE "Comment"
  SET Recommend = COALESCE(Recommend, 0) - 1
  WHERE CommentID = OLD.CommentID;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER trg_comment_recommend_insert
AFTER INSERT ON "Comment_Recommend"
FOR EACH ROW EXECUTE PROCEDURE on_comment_recommend_insert();

CREATE TRIGGER trg_comment_recommend_delete
AFTER DELETE ON "Comment_Recommend"
FOR EACH ROW EXECUTE PROCEDURE on_comment_recommend_delete();