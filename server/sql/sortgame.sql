-- drop function public.sortgamebyprice(int);
create or replace function sortgamebyprice(start int, cnt int)
returns table(GameID uuid)
language sql
as $$
  select G.gameid /*, cast((case when (GS.discountpercentage IS NULL) then G.price
         when (CURRENT_DATE < GS.startdate or CURRENT_DATE > GS.enddate) then G.price
         else G.price * (100 - GS.discountpercentage) / 100 end) as text)*/
  from "Game" G left join "Game_Sale" GS On (G.gameid = GS.gameid)
  Order by
    case when (GS.discountpercentage IS NULL) then G.price
         when (CURRENT_DATE < GS.startdate or CURRENT_DATE > GS.enddate) then G.price
         else G.price * (100 - GS.discountpercentage) / 100
    end
  LIMIT cnt OFFSET start;
$$;

create or replace function sortonsalegamebyprice(start int, cnt int)
returns table(GameID uuid)
language sql
as $$
  select G.gameid
  from "Game" G join "Game_Sale" GS On (G.gameid = GS.gameid)
  where CURRENT_DATE >= GS.startdate and CURRENT_DATE <= GS.enddate
  Order by G.price * (100 - GS.discountpercentage) / 100
  LIMIT cnt OFFSET start;
$$;

create or replace function sortgamebypopularity(start int, cnt int)
returns table(GameID uuid)
language sql
as $$
  select G.gameid
  from "Game" G
  Order by G.recommend::numeric / power((now()::date - G.releasedate::date + 1), 3) desc
  LIMIT cnt OFFSET start;
$$;

create or replace function sortonsalegamebypopularity(start int, cnt int)
returns table(GameID uuid)
language sql
as $$
  select G.gameid
  from "Game" G join "Game_Sale" GS on (G.gameid = GS.gameid)
  where CURRENT_DATE >= GS.startdate and CURRENT_DATE <= GS.enddate
  Order by G.recommend::numeric / power((now()::date - G.releasedate::date + 1), 3) desc
  LIMIT cnt OFFSET start;
$$;

