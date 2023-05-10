import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import re
import matplotlib.pyplot as plt
from underthesea import word_tokenize
import pickle

# Load the data
data = pd.read_csv('E:/Crawl Tripadvisor/data/s3_restaurant.csv')

data = data.dropna()
data['details'] = data['details'].str.lower()   # Convert text to lowercase
data['details'] = data['details'].apply(lambda x: re.sub(r'\d+', '', x))
data['details'] = data['details'].apply(lambda x: re.sub(r',', '', x))

details = data['details'].tolist()
tfidf_vectorizer = TfidfVectorizer(max_df=0.9, max_features=200000, min_df=9, use_idf=True, ngram_range=(1,2))
X = tfidf_vectorizer.fit_transform(details)
scaler = StandardScaler()
X = scaler.fit_transform(X.toarray())

####choose k
inertias = []
k_range = range(1, 21)
for k in k_range:
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X)
    inertias.append(kmeans.inertia_)
# plt.plot(k_range, inertias, 'bx-')
# plt.xlabel('Number of clusters')
# plt.ylabel('Inertia')
# plt.title('Elbow Method')
# plt.show()

kmeans = KMeans(n_clusters=12, random_state=42)
kmeans.fit(X)

X = tfidf_vectorizer.transform(data['details'])
X = scaler.transform(X.toarray())
data['cluster'] = kmeans.predict(X)

#observe the number of records of each cluster
data['cluster'] = kmeans.labels_
cluster_counts = data['cluster'].value_counts()
# print(cluster_counts)

top_words = {}
for i in range(len(kmeans.cluster_centers_)):
    center = kmeans.cluster_centers_[i]
    top_words[i] = [tfidf_vectorizer.get_feature_names_out()[ind] for ind in center.argsort()[-10:]]
    print(f'Top words for cluster {i}: {", ".join(top_words[i])}')

# print(cluster_counts)
# Recommend restaurants based on user input
# user_input = input('Nhập vào nhà hàng bạn muốn tìm:')
# user_input = user_input.lower()
# user_input = re.sub(r',', '', user_input)  
# user_vector = tfidf_vectorizer.transform([user_input])
# user_vector = scaler.transform(user_vector.toarray())
# user_cluster = kmeans.predict(user_vector)[0]
# recommended_restaurants = data[data['cluster'] == user_cluster].sort_values('ratingAverage', ascending=False)
# print(recommended_restaurants.head(10))

# with open('kmeans_model.pkl', 'wb') as f:
#     pickle.dump(kmeans, f)

# with open('tfidf_vectorizer.pkl', 'wb') as f:
#     pickle.dump(tfidf_vectorizer, f)

# with open('scaler.pkl','wb') as f:
#     pickle.dump(scaler, f)


