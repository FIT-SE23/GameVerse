-- Function: Increase comment upvote
create or replace function on_comment_upvote_insert()
returns trigger as $$
begin
  update "Comment"
  set Upvote = coalesce(Upvote, 0) + 1
  where CommentID = NEW.CommentID;
  return NEW;
end;
$$ language plpgsql;

-- Function: Decrease comment upvote
create or replace function on_comment_upvote_delete()
returns trigger as $$
begin
  update "Comment"
  set Upvote = coalesce(Upvote, 0) - 1
  where CommentID = OLD.CommentID;
  return OLD;
end;
$$ language plpgsql;

-- Triggers
create trigger trg_comment_upvote_insert
after insert on "Comment_Upvote"
for each row execute procedure on_comment_upvote_insert();

create trigger trg_comment_upvote_delete
after delete on "Comment_Upvote"
for each row execute procedure on_comment_upvote_delete();
