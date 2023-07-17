# database-project-Tien-Phan
First, accessing to the website https://www.tripadvisor.com.vn/, choose "restaurant section" located in Ho Chi Minh city. Next, using BeautifulSoup in Python extract hyperlinks pages to extract all links each restaurants, after that, extracting all informations of each restaurants in Ho Chi Minh (name, address, phone, ratingAverage, timeOpen, details).
Following this, using SQL commands to preprocess data. 
The repsonsibility of specific file:
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
  + With outlier like: bilion value => cut it into reasonable value
  + Handle the length of them to make it worth (too small, too large or difference between minimum and maximum is so far)
  + Fill the null price base on type of details (type of foods like vietnam, euro, US,...)
  + Build a list of range price 
  File rating.sql:
  + With null records, refer to their details and observe types of them, counting the average rating of all restaurants with similar types, then, adding those values into null values.
  + Convert data type to float
      + Export data into file csv.
      + Continue to process data using Python: standardlizing location of restaurants
  Connecting to the cloud for storing (AWS S3):
  + As root user, I created bucket called data-aws-9 in S3, seperate missions for each IAM USER and activate ACCESS KEY and SECRET KEY for each IAM USER and set up to access 
  Building an web app to deploy model recommendation:
  Kmeans:
  + Connect to S3 console, load the database stored on bucket data-aws-9.
  + Using it as csv file, then, preprocess : drop NaN value, convert to lowercase, remove numeric characters, remove commas
  + Adopting TF-IDF to extract features of texts
  + Choose k: after putting it to K elbow and visualize it, i absolutely choose K = 12 (the number of clusters is 12)
  + Finally, after building Kmeans model, I deploy it to Rest-API to present model obviously.




  


