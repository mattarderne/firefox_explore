-- Export your Firefox bookmarks into a reasonable format to import into Roam/Obsidian/Logseq
-- Usage: 
--  copy your places.sqlite file from your Firefox profile into a new location, and open it with a SQL tool eg https://tableplus.com/
--  open places.sqlite and run the below query, export that to CSV and you have freed yourself form the dead fox
--  use https://github.com/Arrowyz01/csv2logseq_block to conver the CSV into MD, and wrangle the result into something usable

-- NB: modify the 'parent_folder' line to suit


with 
bookmarks as (
	select parents.title as parent_folder,
		b.*, 
		 datetime(datetime(b.dateadded/1000000,'unixepoch'), '+60 minute') as last_visit_date,
		 datetime(datetime(b.lastmodified/1000000,'unixepoch'), '+60 minute') as last_modified_date
	from moz_bookmarks b
	join moz_bookmarks parents on parents.id = b.parent
), 

places as (
	select 
          moz_places.url,
          moz_places.title,
          moz_places.frecency,
          moz_places.visit_count,
          moz_places.id as place_id,
          datetime(datetime(moz_places.last_visit_date/1000000,'unixepoch'), '+60 minute') as last_visit_date,
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
   from moz_places),

stage as (
	select 
		places.place_id,
		
		-- change which link type you want by varying these two comments
		-- '#' || replace(bookmarks.parent_folder, ' ', '') as parent_folder, 
		'[[' || replace(bookmarks.parent_folder, ' ', '') || ']]' as parent_folder, 
-- 		replace(bookmarks.parent_folder, ' ', '') as parent_folder, 
		
		bookmarks.title as titles,
		places.title,
		places.url, 
		places.url_clean,
		places.frecency, 
		places.visit_count,
		bookmarks.last_visit_date,
		bookmarks.last_modified_date
	from bookmarks
	inner join places on bookmarks.fk = places.place_id
	order by visit_count desc
),

names_group as (
	select 
		place_id,
		tags, 
		last_visit_date
  	from
      (select 
	      	place_id , 
	      	group_concat(parent_folder) as tags,
	      	max(last_visit_date) as last_visit_date 
       from  stage
       group by url
       ) t       
      
 ),
       
 final as (
 	select distinct
	 	names_group.tags,
	 	names_group.place_id, 
	 	names_group.last_visit_date,
	 	title, 
	 	url,
	 	url_clean,
		frecency, 
		visit_count
 
	from names_group
 	left join stage on stage.place_id = names_group.place_id
 	order by frecency desc
)

select * from final 
-- where lower(tags) like  '%saas%'

