import sqlite3


site_list = [
'reddit.com',
'news.ycombinator.com',
'feedly.com',
'youtube.com',
'test.com',
'test2.com',
]

con = sqlite3.connect("places.sqlite") # first create an empty file to save the db
cur = con.cursor()
cur.execute("CREATE TABLE IF NOT EXISTS procrastinate ('procrastinate' text);")
cur.execute("DELETE FROM procrastinate;")

for i in site_list:
    cur.execute("INSERT INTO procrastinate ('procrastinate') VALUES (?);", (i,))

con.commit()
con.close()