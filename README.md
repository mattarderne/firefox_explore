# firefox_explore

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

```
docker start metabase_ff
```

localhost:3000/dashboard/1



login is 
`admin@admin.admin`
pwd is
`admin11`


# To do
[ ] create an automated Docker
[ ] figure out procrastinate list 
[ ] name - true-to-thine-fox
[ ] python, add some deep learning correlation graphs, jupyter notebooks, streamlit
[ ] find some other sqlite data sources and add them 