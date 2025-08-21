-- Function
create or replace function public.set_user_as_publisher()
returns trigger as $$
begin
  if new.isverified = true then
    update public."User"
    set type = 'publisher'
    where userid = new.publisherid;
  end if;
  return new;
end;
$$ language plpgsql;

-- Trigger
create trigger publisher_verified_trigger
after update of isverified on public."Publisher"
for each row
when (new.isverified = true)
execute function public.set_user_as_publisher();
