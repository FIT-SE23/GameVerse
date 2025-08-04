create or replace function sortgamebyprice(lim int)
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
  limit lim;
$$;
