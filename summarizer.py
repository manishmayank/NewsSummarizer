# Page Rank based Summarizer Algorithm with edge weight equal to edit distance between two nodes (here two strings)

import nltk
import networkx as nx
import MySQLdb as mdb


def setup_databse_conn():
	username = "develop"
	server_address = "127.0.0.1"
	password = "pass"
	database_name = "v1_development"

	con = mdb.connect(server_address, username, password, database_name)
	cursor = con.cursor()
	return con, cursor

def find_dist(sentence1, sentence2):
	if(len(sentence1) < len(sentence2)):
		return find_dist(sentence2, sentence1)

	if(len(sentence2) == 0):
		return len(sentence1)

	first_length = len(sentence1) + 1
    second_length = len(sentence2) + 1
    distance_matrix = [[0] * second_length for x in range(first_length)]
    for i in range(first_length):
       distance_matrix[i][0] = i
    for j in range(second_length):
       distance_matrix[0][j]=j
    for i in xrange(1, first_length):
        for j in range(1, second_length):
            deletion = distance_matrix[i-1][j] + 1
            insertion = distance_matrix[i][j-1] + 1
            substitution = distance_matrix[i-1][j-1]
            if first[i-1] != second[j-1]:
                substitution += 1
            distance_matrix[i][j] = min(insertion, deletion, substitution)
    return distance_matrix[first_length-1][second_length-1]


def build_graph(nodes):
	graph = nx.Graph()
	graph.add_nodes_from(nodes)
	count = 0

	for i in range(0,len(nodes)):
		for j in range(i+1,len(nodes)):
			print nodes[i] + "   " + nodes[j]
			distance = find_dist(nodes[i], nodes[j])
			graph.add_edge(nodes[i], nodes[j], weight = distance)

	return graph


def extractSentences(text):
	detector = nltk.data.load('tokenizers/punkt/english.pickle')
	tokens = detector.tokenize(text.strip())
	# print tokens

	graph = build_graph(tokens)
	pagerank = nx.pagerank(graph, weight = 'weight')
	# print pagerank
	



def summarize(article_id, article_content, cursor):
	summary = extractSentences(article_content)
	insert_query = "INSERT INTO summaries (" + article_id + ", ''" + summary.replace("'","\\'") + "')"


def find_articles(cursor):
	# select_query = "SELECT id, content FROM articles ORDER BY created_by DESC";
	# cursor.execute(select_query)
	# articles = cursor.fetchall()
	# for article in articles:
	# 	summarize(article["id"], article["content"], cursor)
	sample_text = "The notification barred the Delhi government from proceeding against central government employees working under it and held that the Anti-Corruption Branch of the Delhi government could not act against errant police officials under the Prevention of Corruption Act? I have finally been able to tokenize it into two sentences."
	summarize(0, sample_text, cursor)


# con, cursor = setup_databse_conn()
cursor = ""
find_articles(cursor)
