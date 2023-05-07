import boto

s3 = boto.connect_s3('Private', 'Private')

bucket_name = 'data-aws-9'
bucket = s3.get_bucket(bucket_name)

file_key = 'final_restaurants_s3.csv'
key = bucket.get_key(file_key)
key.get_contents_to_filename('E:/Crawl Tripadvisor/data/s3_restaurant.csv')