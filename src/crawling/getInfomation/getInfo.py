import requests
from bs4 import BeautifulSoup
import os
import csv
import pandas as pd

txt_direct = os.path.join(os.getcwd(), 'LINKPAGES', 'TXT')
all_links = []
for filename in os.listdir(txt_direct):
    if filename.endswith('txt'):
        with open(os.path.join(txt_direct, filename), 'r') as f:
            links = f.read().splitlines()
        all_links.extend(links)

restaurants = []
for link in all_links:
    headers = {"user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"}
    html = requests.get(link, headers=headers)
    soup = BeautifulSoup(html.content, 'html.parser')
    print(f"Processing link: {link}")
    name = soup.find('h1', class_="HjBfq")
    address = soup.find('a', href='#MAPVIEW', class_="AYHFM")
    phone = soup.find('a', href=lambda x: x and x.startswith('tel:'), class_="BMQDV _F G- wSSLS SwZTJ")
    timeOpen = soup.find('span', class_="mMkhr")
    ratingAverage = soup.find('span', class_="ZDEqb")
    priceRange = soup.find('div', class_="SrqKb")
    if name is not None:
        name = name.text.strip()
    else:
        name = ''
    if address is not None:
        address = address.text.strip()
    else:
        address = ''
    if phone is not None:
        phone = phone.text.strip()
    else:
        phone = ''
    if timeOpen is not None:
        timeOpen = timeOpen.text.strip()
    else:
        timeOpen = ''
    if ratingAverage is not None:
        ratingAverage = ratingAverage.text.strip()
    else:
        ratingAverage = ''
    if priceRange is not None:
        priceRange = priceRange.text.strip()
    else:
        priceRange = ''
    dt_list = []
    details = soup.find_all('div', class_="SrqKb")
    for detail in details:
        dt_list.append(detail.text.strip())
    dt_list_str = ', '.join(dt_list)
    row = {'name': name, 'address': address, 'phone': phone, 'timeOpen': timeOpen, 'ratingAverage': ratingAverage, 'priceRange': priceRange, 'details': dt_list_str}
    restaurants.append(row)
df = pd.concat([pd.DataFrame(restaurants)])
df.to_csv('E:/Crawl Tripadvisor/InfomationRestaurants.csv', index=False) 
