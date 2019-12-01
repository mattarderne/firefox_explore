WITH history AS
  (SELECT moz_historyvisits.id,
          datetime(datetime(moz_historyvisits.visit_date/1000000,'unixepoch'), '+60 Minute') AS date_visited,
          moz_places.url,
          moz_places.title,
          moz_places.frecency,
          moz_places.visit_count,
          moz_places.id AS place_id,
          datetime(datetime(moz_places.last_visit_date/1000000,'unixepoch'), '+60 Minute') AS last_visit_date,
          moz_places.visit_count,
          moz_places.hidden,
          moz_places.typed,
          moz_places.frecency,
          moz_places.description,
        replace(
            replace(
                replace(
                    replace(moz_places.url,"http://",""),"https://",""),"s:",""),"www.","")
            as url_clean
   FROM moz_historyvisits
   LEFT JOIN moz_places ON moz_places.id = moz_historyvisits.place_id
   ),
    cleanup AS
  (SELECT place_id,
          id,
          date_visited,
          last_visit_date,
          date(date_visited) date_visited_date,
          time(date_visited) time_full,
          strftime('%H:%M', date_visited) hour_min,
          strftime('%H', date_visited) hour,
          title,
          url,
          substr(url_clean,0,instr(url_clean,"/")) as tld,
          visit_count,
          hidden,
          typed,
          frecency,
          description
   FROM history)
   
SELECT 
    id as visit_id,
    place_id as site_id,
    -- tld as top_level_domain,
    title as site_title,
    url as site_url,
    visit_count,
    hidden,
    typed,
    frecency,
    description,
    date_visited as visit_timestamp,
    date_visited_date as visit_date,
    time_full as visited_time,
    hour_min as visited_time_hour_min,
    hour as visited_time_hour,
    last_visit_date as last_visit_timestamp
FROM cleanup
