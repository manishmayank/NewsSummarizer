import lxml.html
import requests
import MySQLdb as mdb
from goose import Goose

def crawl_goose(article_obj, con, cursor):
	g = Goose()
	article = g.extract(article_obj["link"])
	title = article.title
	content = article.cleaned_text
	image_src = article.top_image.image_src
	# also need to download the image
	# use paperclip in ruby for above purpose
	# use image_tag which contains pathname of image
	meta_desc = article.meta_description    #currently not including in databse, may be needed later

	# insert_query = ""


def setup_databse_conn():
	username = "develop"
	server_address = "127.0.0.1"
	password = "pass"
	database_name = "v1_development"

	con = mdb.connect(server_address, username, password, database_name)
	cursor = con.cursor()
	return con, cursor

def crawl(con, cursor):
	select_url_query = "SELECT * FROM links_to_crawl"
	cursor.execute(select_url_query)
	result_links = cursor.fetchall()
	for result in result_links:
		print result
		crawl_goose(result, con, cursor)


# if __name__ == "__main__":
con, cursor = setup_databse_conn()
crawl(con, cursor)
