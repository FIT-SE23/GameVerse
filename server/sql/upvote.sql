-- drop function if exists public.gameUpvote (incr int, id uuid) cascade;
create or replace function gameUpvote (incr int, id uuid) 
returns void as
$$
  update "Game" 
  set upvote = upvote + incr
  where gameid = id;
$$ 
language sql volatile;
