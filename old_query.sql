with history as (
select 
moz_historyvisits.id, 
datetime(datetime(moz_historyvisits.visit_date/1000000,'unixepoch'), '+60 Minute') as date_visited, 
moz_places.url,
moz_places.title, 
moz_places.frecency,
moz_places.visit_count, 
moz_places.id as place_id,
datetime(datetime(moz_places.last_visit_date/1000000,'unixepoch'), '+60 Minute') as last_visit_date
from moz_historyvisits
left join moz_places on moz_places.id = moz_historyvisits.place_id

--- ### Add the time slots you want to investigate
where date_visited > '2018-05-01' 

--- ### Add the time slots you want to investigate
-- and time(date_visited) > '07:00:00' and time(date_visited) < '10:00:00' 

--- ### Exclude any place ID's that are work related
-- and place_id not in (373,78,286, 19127,48020,13004,12844,44571,48022,40271)

order by date_visited asc),

cleanup as (
select 
place_id, 
id, 
time(date_visited) time_full, 
strftime('%H:%M', date_visited) hour_min, 
strftime('%H', date_visited) hour, 
title,
url,
case 
when substr(url,9,3) = 'www' then
substr(substr( url,instr(url,'.')+1,100),instr(url,'.'),substr( url,instr(url,'.'),100)-instr(url,'.')) 
else substr(substr( url,instr(url,'.')+1,100),instr(url,'.'),substr( url,instr(url,'.'),100)-100)  
end as tld

from history 
)

--- ### do your queries here, some examples are
/*
### This gives you your most frequently visited sites
select place_id, count(tld), tld, url, title from cleanup group by tld
order by  count(tld) desc
*/
select 
hour_min,
count(id)
from cleanup 
group by hour_min
order by  hour_min asc