-- drop function searchgames(gname text, categories text[], start int, cnt int, onsale boolean, text)

create or replace function getgameids(gname text, categories text[], start int, cnt int, onsale boolean, sortby text)
returns uuid[]
language sql
as $$
  select ARRAY_AGG(id) from (
    select G.gameid as id
    from "Game" G join "Publisher" P on (G.publisherid = P.publisherid and P.isverified is true) left join "Game_Sale" GS on (G.gameid = GS.gameid)
    where G.isverified is true and G.name ilike format('%%%s%%', gname) and (
      (array_length(categories, 1) is null) or
      ((select ARRAY_AGG(lower(C.categoryname))
      from "Game_Category" GC join "Category" C on (GC.categoryid = C.categoryid)
      where G.gameid = GC.gameid)::text[] @> (lower(categories::text))::text[])
    ) and (onsale is false or (GS.startdate <= CURRENT_DATE AND GS.enddate >= CURRENT_DATE))

    order by (case when sortby = 'recommend' then G.recommend end) desc,
             (case when sortby = 'date' then to_char(G.releasedate, 'YYYYMMDD')::int end) desc,
             (case when sortby = 'popularity' then G.recommend::numeric / power((now()::date - G.releasedate::date + 1), 3) end) desc,
             (case when sortby = 'price' then
              case when (GS.discountpercentage is null) then G.price
                  when (CURRENT_DATE < GS.startdate or CURRENT_DATE > GS.enddate) then G.price
                  else G.price * (100 - GS.discountpercentage) / 100 end
              end) asc
    limit cnt offset start
  )
$$;

create or replace function getgamesbyid(id uuid[])
returns table(gameid uuid, name text, publisherid uuid, description text, price float, recommend int4, releasedate date, requirement text, briefdescription text, isverified boolean,
  Category text[][],
  Resource text[][],
  Game_Sale text[])
language sql
as $$
  select G.gameid, g.name, g.publisherid, g.description, g.price, g.recommend, g.releasedate, g.requirement, g.briefdescription, g.isverified,
              (select ARRAY_AGG(array[C.categoryid::text, C.categoryname::text, C.issensitive::text])
               from "Game_Category" GC join "Category" C on (GC.categoryid = C.categoryid)
               where GC.gameid = G.gameid
              ),
              (select ARRAY_AGG(array[R.url::text, R.type::text])
               from "Game_Resource" GR join "Resource" R on (GR.resourceid = R.resourceid)
               where GR.gameid = G.gameid
              ),
              array[GS.discountpercentage::text, GS.startdate::text, GS.enddate::text]
  from "Game" G left join "Game_Sale" GS on (G.gameid = GS.gameid)
  where G.gameid = any(id)
  group by g.gameid, GS.discountpercentage, GS.startdate, GS.enddate
  order by array_position(id, G.gameid);
$$;

create or replace function searchgames(gname text, categories text[], start int, cnt int, onsale boolean, sortby text)
returns table(gameid uuid, name text, publisherid uuid, description text, price float, recommend int4, releasedate date, requirement text, briefdescription text, isverified boolean,
  Category text[][],
  Resource text[][],
  Game_Sale text[])
language sql
as $$
  select * from getgamesbyid(getgameids(gname, categories, start, cnt, onsale, sortby))
$$;

