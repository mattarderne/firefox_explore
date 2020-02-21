import csv, sqlite3

# not working https://github.com/metabase/metabase/issues/6094

con = sqlite3.connect("places.sqlite") # first create an empty file to save the db
cur = con.cursor()
cur.execute("CREATE TABLE IF NOT EXISTS procrastinate ('procrastinate' text);")
cur.execute("DELETE FROM procrastinate;")


with open('procrastinate.csv','r') as csvFile:
    # csv.DictReader uses first line in file for column headings by default
    dr = csv.reader(csvFile) # comma is the default delimiter
    for i in dr:
        cur.execute("INSERT INTO procrastinate ('procrastinate') VALUES (?);", i)
    # to_db = [(i['procrastinate']) for i in dr]

# cur.executemany("INSERT INTO procrastinate ('procrastinate') VALUES (?);", [to_db])
con.commit()
con.close()