import csv, sqlite3

# not working https://github.com/metabase/metabase/issues/6094

con = sqlite3.connect("metabase.db.mv.db") # first create an empty file to save the db
cur = con.cursor()

# try:
#     cur.execute("CREATE TABLE procrastinate ('procrastinate' text);")
# finally:
#     pass

with open('procrastinate.csv','rb') as csvFile:
    # csv.DictReader uses first line in file for column headings by default
    dr = csv.DictReader(csvFile) # comma is the default delimiter
    to_db = [(i['procrastinate']) for i in dr]

cur.executemany("INSERT INTO procrastinate ('procrastinate') VALUES (?);", to_db)
con.commit()
con.close()