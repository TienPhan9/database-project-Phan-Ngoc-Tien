import boto
import boto.s3.connection

#check buckets
# access_key = 'AKIATLW3FXJQAA6TJ7PK'
# secret_key = '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'

# conn= boto.connect_s3(
#     aws_access_key_id = 'AKIATLW3FXJQAA6TJ7PK',
#     aws_secret_access_key = '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'
# )
# for bucket in conn.get_all_buckets():
#     print("{name}\t{created}".format(
#         name = bucket.name,
#         created = bucket.creation_date,
#     ))
from io import StringIO
import pandas as pd
import boto

data = pd.read_csv('E:/Crawl Tripadvisor/data/InfomationRestaurants.csv')

s3 = boto.connect_s3('AKIATLW3FXJQAA6TJ7PK', 'IplWdHZ0VXp+HpaJBamX4kibj9CKfe+k+/Xy2hES')
bucket = s3.get_bucket('data-aws-9')

csv_buf = StringIO()
data.to_csv(csv_buf, header=True, index=False)
csv_buf.seek(0)

key = bucket.new_key('restaurants.csv')
key.set_contents_from_string(csv_buf.getvalue())


