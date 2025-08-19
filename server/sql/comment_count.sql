create or replace function increment_comment_count()
returns trigger as $$
begin
  update "Post"
  set Comments = coalesce(Comments, 0) + 1
  where PostID = new.PostID;
  return new;
end;
$$ language plpgsql;

create or replace function decrement_comment_count()
returns trigger as $$
begin
  update "Post"
  set Comments = greatest(coalesce(Comments, 0) - 1, 0)
  where PostID = old.PostID;
  return old;
end;
$$ language plpgsql;

create trigger trigger_increment_comment
after insert on "Comment"
for each row
execute function increment_comment_count();

create trigger trigger_decrement_comment
after delete on "Comment"
for each row
execute function decrement_comment_count();
