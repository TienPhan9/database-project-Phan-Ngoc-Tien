import pandas as pd
df = pd.read_csv("InfomationRestaurants.csv", sep=",", header=None, 
                 names=["name", "address", "phone", "timeOpen", "ratingAverage", "priceRange", "details"])
print(df)