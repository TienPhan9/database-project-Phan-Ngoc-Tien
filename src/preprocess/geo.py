import pandas as pd
from geopy.geocoders import Nominatim

data = pd.read_csv('E:/Crawl Tripadvisor/data/s3_restaurant.csv')
geolocator = Nominatim(user_agent="my-app")

def reverse_geocode(lat, long):
    location = geolocator.reverse(f"{lat}, {long}")
    return location.address

data['address'] = data.apply(lambda row: reverse_geocode(row['Latitude'], row['Longitude']), axis=1)
data.to_csv('geo_main.csv', index=False)

