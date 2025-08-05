-- Function: Increase post upvote
create or replace function on_post_upvote_insert()
returns trigger as $$
begin
  update "Post"
  set Upvote = coalesce(Upvote, 0) + 1
  where PostID = NEW.PostID;
  return NEW;
end;
$$ language plpgsql;

-- Function: Decrease post upvote
create or replace function on_post_upvote_delete()
returns trigger as $$
begin
  update "Post"
  set Upvote = coalesce(Upvote, 0) - 1
  where PostID = OLD.PostID;
  return OLD;
end;
$$ language plpgsql;

-- Triggers
create trigger trg_post_upvote_insert
after insert on "Post_Upvote"
for each row execute procedure on_post_upvote_insert();

create trigger trg_post_upvote_delete
after delete on "Post_Upvote"
for each row execute procedure on_post_upvote_delete();
