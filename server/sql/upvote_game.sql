-- Function: Increase game upvote
create or replace function on_game_upvote_insert()
returns trigger as $$
begin
  update "Game"
  set Upvote = coalesce(Upvote, 0) + 1
  where GameID = NEW.GameID;
  return NEW;
end;
$$ language plpgsql;

-- Function: Decrease game upvote
create or replace function on_game_upvote_delete()
returns trigger as $$
begin
  update "Game"
  set Upvote = coalesce(Upvote, 0) - 1
  where GameID = OLD.GameID;
  return OLD;
end;
$$ language plpgsql;

-- Triggers
create trigger trg_game_upvote_insert
after insert on "Game_Upvote"
for each row execute procedure on_game_upvote_insert();

create trigger trg_game_upvote_delete
after delete on "Game_Upvote"
for each row execute procedure on_game_upvote_delete();