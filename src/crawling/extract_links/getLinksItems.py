import requests
import re
import os
from bs4 import BeautifulSoup, Tag
from urllib.parse import urljoin


if not os.path.exists(os.path.join(os.getcwd() + '/LINKPAGES', 'TXT')):
    os.makedirs(os.path.join(os.getcwd() + '/LINKPAGES', 'TXT'))

def url_to_file_name_txt(url):
    url = str(url).strip().replace(' ', '_')
    return re.sub(r'(?u)[^-\w.]', '', url) + ".txt"

def get_Links(url_visit):
    global Links_ToDo
    print(url_visit)
    headers = {
        "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"}
    Links_seen.append(url_visit)
    html = requests.get(url_visit, headers=headers).text
    soup = BeautifulSoup(html, 'html.parser')

    restaurant_links = []
    for link in soup.find_all('a', class_="Lwqic Cj b"):
        restaurant_links.append(urljoin(url_visit, link['href']))
    filename = url_to_file_name_txt(url_visit)
    filepath = os.path.join(os.getcwd(), 'LINKPAGES', 'TXT', filename)
    with open(filepath, 'w') as f:
        for link in restaurant_links:
            f.write(link + '\n')

    next_link = soup.find('a', class_="nav next rndBtn ui_button primary taLnk")
    if next_link and next_link.get('href') not in Links_ToDo and next_link.get('href') not in Links_seen:
        abs_url = urljoin(url_visit, next_link.get('href'))
        Links_ToDo.append(abs_url)
        get_Links(Links_ToDo.pop())
    elif Links_ToDo:
        get_Links(Links_ToDo.pop())
    else:
        return

url = "https://www.tripadvisor.com.vn/Restaurants-g293925-Ho_Chi_Minh_City.html"
Links_ToDo = [url]
Links_seen = []
get_Links(Links_ToDo.pop())