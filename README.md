# firefox_explore

_be-true-to-thine-fox_

Explore your firefox browsing history trends using Metabase Analytics Tool

![image](/firefox.png)

> Disclaimer - this was made in a rush, and sat on ice for a while, please PR any suggestions. 


# Setup

Copy your firefox profile to this repo (NB - make sure not to commit your `places.sqlite` file or any `places.*` to github, it's got a lot in it...)

```bash
cp ~/Library/ApplicationSupport/Firefox/Profiles/y4pw28fm.default/places.sqlite .
```

This creates a docker container, linking this repo (with the Metabase backend sqlite database and the Firefox places.sqlite) to the Docker container

```bash
docker run -d -p 3000:3000 \
-v $PWD:/metabase-data \
-e "MB_DB_FILE=/metabase-data/metabase.db" \
--name metabase_ff metabase/metabase
```

```bash
docker start metabase_ff
```



# Use 
## Links
* [Browsing Overview](localhost:3000/dashboard/1), use these as inspiration for starting points
* [Base SQL table](http://localhost:3000/question/33), use this as a basis for queries

Login details are:

```
admin@admin.admin
admin11
```

## Procrastinate

1. Modify the `procrastinate.csv` file with the domains you want to include, you [this](http://localhost:3000/question/37) question to get your top 20 list.
2. Install sqlite with `pip install procrastinate/requirements.txt`
3. Run `python procrastinate/procrastinate.py` to copy the lists to the `procrastinate.db`

# TODO

Contributions useful, the following are necessary at some stage, but other useful things include creating useful visualisations (kinda tricky to integrate as the code lives in the metabase.db), cleaning up the `all_site_visits.sql` file 

## Small
* [ ] figure out your most clicked HN titles, look at the words in the title
* [ ] Name it something clever - `true-to-thine-fox`
* [ ] Fix the dates in the base [Base SQL table](http://localhost:3000/question/33)
* [ ] Fix the Docker to use docker-compose
* [ ] Mount the `places.sqlite` directly in the docker rather than copying it to the repo 
* [ ] think about doing a integer join on the `all_site_visits` table on the `LEFT JOIN procrastinate on cleanup.top_level_domain = procrastinate.procrastinate` join


## Big
* [ ] Add the [procrastinate](/procrastinate.csv) list to the SQLite db somehow
* [ ] python, add some deep learning correlation graphs, jupyter notebooks, streamlit
    * [ ] [ai on docker](https://github.com/zacheberhart/Learning-to-Feel)
    * [ ] streamlit [docker](https://medium.com/@ansjin/how-to-create-and-deploy-data-exploration-web-app-easily-using-python-a03c4b8a1f3e)
* [ ] find some other sqlite data sources and add them 







