import requests
from bs4 import BeautifulSoup
import os
import csv


txt_direct = os.path.join(os.getcwd(), 'LINKPAGES', 'TXT')
all_links = []
for filename in os.listdir(txt_direct):
    if filename.endswith('txt'):
        with open(os.path.join(txt_direct, filename), 'r') as f:
            links = f.read().splitlines()
        all_links.extend(links)
link = all_links[2]
headers = {"user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"}
html = requests.get(link, headers = headers)
soup = BeautifulSoup(html.content, 'html.parser')
name = soup.find('h1', class_="HjBfq")
print(name.text.strip())