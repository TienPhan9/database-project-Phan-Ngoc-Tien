from io import StringIO
import pandas as pd
import boto

data = pd.read_csv('E:/Crawl Tripadvisor/data/fixed_file_colab.csv')

s3 = boto.connect_s3('Private', 'Private')
bucket = s3.get_bucket('data-aws-9')

csv_buf = StringIO()
data.to_csv(csv_buf, header=True, index=False)
csv_buf.seek(0)

key = bucket.new_key('fixed_restaurants_s3.csv')
key.set_contents_from_string(csv_buf.getvalue())


