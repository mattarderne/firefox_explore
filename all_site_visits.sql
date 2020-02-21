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
  (SELECT place_id as site_id, 
          id as visit_id, 
          date_visited as visit_timestamp,
          last_visit_date as last_visit_timestamp,
          date(date_visited) visit_date,
          time(date_visited) visited_time,
          strftime('%H:%M', date_visited) visited_time_hour_min,
          strftime('%Y', date_visited) as visited_year,
          strftime('%H', date_visited) visited_time_hour,
          title as site_title,
          url as site_url,
          substr(url_clean,0,instr(url_clean,"/")) as top_level_domain,
          visit_count,
          hidden,
          typed,
          frecency,
          description,
          case cast (strftime('%w', date_visited) as integer)
              when 0 then '7 - Sunday'
              when 1 then '1 - Monday'
              when 2 then '2 - Tuesday'
              when 3 then '3 - Wednesday'
              when 4 then '4 - Thursday'
              when 5 then '5 - Friday'
          else '6 - Saturday' end as visited_dayofweek,
         CASE strftime('%m', date_visited)
             WHEN '01' THEN '1 - January'
             WHEN '02' THEN '2 - Febuary'
             WHEN '03' THEN '3 - March'
             WHEN '04' THEN '4 - April'
             WHEN '05' THEN '5 - May'
             WHEN '06' THEN '6 - June'
             WHEN '07' THEN '7 - July'
             WHEN '08' THEN '8 - August'
             WHEN '09' THEN '9 - September'
             WHEN '10' THEN '10 - October'
             WHEN '11' THEN '11 - November'
             WHEN '12' THEN '12 - December'
             ELSE ''
         END AS visited_month,
        strftime('%Y', date_visited) || ' - ' || strftime('%m', date_visited) visited_year_month_short,
    CASE WHEN date('now') > date(date_visited)  THEN 'yes' ELSE 'no' END AS visited_today

   FROM history)
   
SELECT 
    visit_id ,
    site_id,
    top_level_domain,
    site_title,
    site_url,
    visit_count,
    hidden,
    typed,
    frecency,
    description,
    visit_timestamp,
    visit_date,
    visited_time,
    visited_time_hour_min,
    visited_time_hour,
    last_visit_timestamp,
    visited_dayofweek,
    visited_month,
    visited_year,
    visited_today,
    visited_year || ' ' || visited_month as visited_year_month_long,
    visited_year_month_short
FROM cleanup


