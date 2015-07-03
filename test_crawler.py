import lxml.html
import requests
# import MySQLdb as mdb
import psycopg2 as pg

# main_url = "https://news.google.co.in"

cat_dic = {"India":"n", "World":"w", "Business":"b", "Technology":"tc", "Entertainment":"e", "Sports":"s", "Science":"snc", "Health":"m", "Spotlight":"ir", "More Top Stories":"h"}

# def setup_databse_conn():
# 	username = "develop"
# 	server_address = "127.0.0.1"
# 	password = "pass"
# 	database_name = "v1_development"
#
# 	con = pg.connect(server_address, username, password, database_name)
# 	cursor = con.cursor()
# 	return con, cursor

def connection(url):
	while(1):
		try:
			hxs_path = lxml.html.document_fromstring(requests.get(url).content)
		except:
			time.sleep(1)
			print "delay in making connection for url ->  " + url
			continue
		break
	return hxs_path


def crawl_category(category_name, category_link, con, cursor):
	hxs = connection(category_link)
	dic = {}
	details = []
	xpath_title_link = "//div[@class=" + "\"section story-section section-en_in:"+cat_dic[category_name] + "\"]"
	print xpath_title_link

	# title_name = hxs.xpath('//div[' + xpath_start + ']/div/div/div/div/div[2]/table/tbody/tr/td[2]/div[1]/h2/a/span/text()')
	title_name = hxs.xpath(xpath_title_link + "/div/div/div/div/div[2]/table/tbody/tr/td[2]/div[1]/h2/a/span/text()")
	print title_name
	# dic['title'] = title_name[0]
	# details.append()
	title_links = hxs.xpath(xpath_title_link + "/div/div/div/div/div[2]/table/tbody/tr/td[2]/div[1]/h2/a/@href")
	source_names = hxs.xpath(xpath_title_link + "/div/div/div/div/div[2]/table/tbody/tr/td[2]/div[2]/table/tbody/tr/td[1]/span/text()")
	time_uploaded = hxs.xpath(xpath_title_link + "/div/div/div/div/div[2]/table/tbody/tr/td[2]/div[2]/table/tbody/tr/td[2]/span[2]/text()")
	time_data = time_uploaded[0].split()[0]
	time_minutes = time_uploaded[0].split()[1]
	print len(title_links)
	print title_links
	print "\n\n"
	print len(source_names)
	print source_names
	print "\n\n"
	print len(time_uploaded)
	print time_uploaded
	print time_data + "+++" + time_minutes
	if(time_minutes == "minutes" or time_minutes == "minute"):
		time_of_article = int((time.time() - (int(time_data.strip()) * 60)) * 1000)

	elif(time_minutes == "hours" or time_minutes == "hour"):
		time_of_article = int((time.time() - (int(time_data.strip()) * 60 * 60)) * 1000)

	elif(time_minutes == "day" || time_minutes == "days"):
		time_of_article = int((time.time() - (int(time_data.strip()) * 60 * 60 * 24)) * 1000)

	# image_link = hxs.xpath('//')
	# print len(title_name)
	# print len(title_links)
	# print len(source_names)
	# print len(time_uploaded)
	# for i in range(0,len(title_name)):
	# 	print str(i+1) + ": " + time_uploaded[i]


	# for i in range(0,len(title_links)):



def crawl(con, cursor):
	main_url = "https://news.google.co.in"
	hxs = connection(main_url)
	# print hxs
	category_links = hxs.xpath('//ul[@class="nav-items"]/li/a/@href')
	category_names = hxs.xpath('//ul[@class="nav-items"]/li/a/text()')
	for i in range(0,len(category_links)):
		category_links[i] = "https://news.google.co.in" + category_links[i].strip()
	# print category_links
	# print category_names

	for i in range(0,len(category_links)):
		print category_names[i]
		print category_links[i]
		print ""
		if(category_names[i] in cat_dic):
			crawl_category(category_names[i], category_links[i], con, cursor)


if __name__ == "__main__":
	# con, cursor = setup_databse_conn()
	con = cursor = 0
	crawl(con,cursor)
