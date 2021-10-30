# firefox_explore

_be-true-to-thine-fox_

Explore your firefox browsing history trends using [Metabase](https://www.metabase.com/), an [open source analytics tool](https://github.com/metabase/metabase)

![image](/firefox.png)

> Disclaimer - this was made in a rush, and sat on ice for a while, please PR any suggestions & glaring oversights. 


# Setup

Clone this repo
```bash
git clone https://github.com/mattarderne/firefox_explore.git
cd firefox_explore
```

Find where your Firefox `places.sqlite` file lives in [about:support](about:support) page under the **Profile Folder** entry and copy here.

```bash
cp ~/Library/ApplicationSupport/Firefox/Profiles/y4pw28fm.default/places.sqlite .
```

The below creates a docker container, linking this repo (with the Metabase backend sqlite database and the Firefox places.sqlite) to the Docker container

```bash
docker run -d -p 3000:3000 \
-v $PWD:/metabase-data \
-e "MB_DB_FILE=/metabase-data/metabase.db" \
--name metabase_ff metabase/metabase
```

Run below and 2-3min later Metabase will be running at [http://localhost:3000](http://localhost:3000/dashboard/1)
```bash
docker start metabase_ff
```

# Use 

Login details are:

```
admin@admin.admin
admin11
```


## Links
* [Browsing Overview](http://localhost:3000/dashboard/1), use as a starting point
* [Base SQL table](http://localhost:3000/question/33), use this as a base for new queries

The dashboards sometimes need to be refreshed after their first run if any questions don't load

## Procrastinate

This allows you to define a "bad list" of sites that you'd like to mark specifically (or use as a way to insert custom data into the sqlite db)

1. Modify the `site_list` in `procrastinate.py` with the domains you want to include, use [this](http://localhost:3000/question/37) question to get your top 20 list.
2. Run `python procrastinate.py` to copy the lists to the `places.sqlite`

# TODO

Contributions useful, the following are necessary at some stage, but other useful things include creating useful visualisations (kinda tricky to integrate as the code lives in the metabase.db), cleaning up the `all_site_visits.sql` file 

## Small
* [ ] figure out your most clicked HN titles, look at the words in the title
* [ ] Name it something clever - `true-to-thine-fox`
* [ ] Fix the Docker to use docker-compose
* [ ] Mount the `places.sqlite` directly in place rather than copying it to the repo
* [ ] Find a better way of doing `procrastinate_base` 
* [ ] think about doing an integer join on the `all_site_visits` table on the `LEFT JOIN procrastinate on cleanup.top_level_domain = procrastinate.procrastinate` join


## Big
* [ ] Fix the dates in the base [Base SQL table](http://localhost:3000/question/33)
* [ ] python, add some deep learning correlation graphs, jupyter notebooks, streamlit
    * [ ] [ai on docker](https://github.com/zacheberhart/Learning-to-Feel)
    * [ ] streamlit [docker](https://medium.com/@ansjin/how-to-create-and-deploy-data-exploration-web-app-easily-using-python-a03c4b8a1f3e)
* [ ] find some other sqlite data sources and add them 







