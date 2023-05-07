# database-project-Tien-Phan
First, reaching to the website https://www.tripadvisor.com.vn/, choose "restaurant section" located in Ho Chi Minh city. Next, observe the structure of web page, using BeautifulSoup in Python
extract hyperlinks pages to extract all links each restaurants, after that, extract all informations of each restaurants in Ho Chi Minh (name, address, phone, ratingAverage, timeOpen, details).
Following this, using SQL commands to preprocess data I got. 
The process:
  File basic_processing.sql:
  + Remove duplicate restaurant (same restaurants with same address)
  + Remove null restaurant that does not have name and address
  File details.sql:
  + Fill the null value 
  + Filter the numeric values in this details column
  File price.sql: (NOTE priceRange column has many unworth values)
  + Get the id for each restaurant ( unique value)
  + Remove the special character
  + Split minimum and maximum price to make it easy for manage price
  NOTE: In this case, value of minimum and maximum price still be as string value
  + with outlier like: bilion value => cut it into reasonable value
  + handle the length of them to make it worth ( too small, too large or difference between minimum and maximum is so far)
  + fill the null price base on type of details (type of foods like vietnam, euro, US,...)
  + build a list of range price 
  File rating.sql:
  + with null records, refer to their details and observe types of them, counting the average rating of all restaurants with similar types, then, adding those values into null values.
  + convert data type to float
Export data into file xls, after, read it as convert it into file csv to fit.
  On another one: Turning to using python to preprocess
  with the location (address), build latitude and longitude base on available address using tools (geopy)
  verify location again using geopy and extract districts (for recommendation system)
  use word counts to extract frequency of multiple words after each commas (in details column)
  save it as csv file
Connect to the cloud (AWS)
I use S3 console: As root user, creating bucket called data-aws-9 in S3, seperate missions for each IAM USER and activate ACCESS KEY and SECRET KEY for each IAM USER and set up to access
with local and all the package in AWS. After finishing set up, connecting from local to S3 to load file data to store on it (final_restaurants_s3.csv). 
Building an web app to deploy model recommendation base on description and location of restaurant:
Kmeans:
Connect to S3 console, load the database stored on bucket data-aws-9.
Using it as csv file, then, preprocess : drop NaN value, convert to lowercase, remove numeric characters, remove commas
with details column, transform it to list, using TF-IDF to extract features with N-grams (1,2) and transform it to array to prepare for model.
choose k: after putting it to K elbow and visualize it, i absolutely choose K = 12 (the number of clusters is 12)
create an input function to input descriptions customers need to seek out, following this, lowercase, remove commas the text customers type. Next, use TF-IDF to vectorize the customer
inputs to get features, transform it and apply standard scale to fit it from array have value from -1 to 1, and then apply model kmeans into it and predict. In recommend term, get the
restaurants which same features clustered in specific clusters and sort value by rating average, arrange from high to low. Finally, print top 10 restaurants which fit with preferences 
of users and save model as pickle file.



  


