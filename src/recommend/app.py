from flask import Flask, render_template, redirect, url_for, request
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
import re
import matplotlib.pyplot as plt
import pickle

data = pd.read_csv('E:/Crawl Tripadvisor/data/s3_restaurant.csv')

data_sample = data.sample(n=1800, random_state = 42)
data_sample = data_sample.dropna()
data_sample['details'] = data_sample['details'].str.lower() 
data_sample['details'] = data_sample['details'].apply(lambda x: re.sub(r'\d+', '', x))
data_sample['details'] = data_sample['details'].apply(lambda x: re.sub(r',', '', x))

details = data_sample['details'].tolist()
tfidf_vectorizer = TfidfVectorizer(max_df=0.9, max_features=200000, min_df=10, use_idf=True, ngram_range=(1,2))
X = tfidf_vectorizer.fit_transform(details)
scaler = StandardScaler()
X = scaler.fit_transform(X.toarray())

kmeans = KMeans(n_clusters=12, random_state=42)
kmeans.fit(X)

X = tfidf_vectorizer.transform(data_sample['details'])
X = scaler.transform(X.toarray())
data_sample['cluster'] = kmeans.predict(X)
data_sample['cluster'] = kmeans.labels_


app = Flask(__name__)
@app.route('/')
def home():
    return render_template('index.html', districts=list(data['district'].unique()))

@app.route('/recommend', methods=['GET', 'POST'])
def recommend():
    if request.method == 'POST':
        user_input = request.form['user_input']
        user_input = user_input.lower()
        user_input = re.sub(r',', '', user_input)  
        user_vector = tfidf_vectorizer.transform([user_input])
        user_vector = scaler.transform(user_vector.toarray())
        user_cluster = kmeans.predict(user_vector)[0]

        user_district_input = request.form['district']
        if user_district_input:
            data_filtered = data_sample[data_sample['district'] == user_district_input]
        else:
            data_filtered = data_sample
        recommended_restaurants = data_filtered[data_filtered['cluster'] == user_cluster].sort_values('ratingAverage', ascending=False)
        recommended_restaurants = recommended_restaurants[['id','name', 'address', 'phone', 'ratingAverage', 'rangePrice']].head(10)
    return render_template('result.html', restaurants=recommended_restaurants)        
    # return render_template('recommend.html')

if __name__ == "__main__":
    app.run(port='3000', debug=True)

