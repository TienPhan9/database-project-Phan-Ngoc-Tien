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
    NextLinks=soup.find_all('a', class_="pageNum taLnk")

    for Link in NextLinks:
        if isinstance(Link, Tag):
            url = Link.get('href')
            if url:
                abs_url = urljoin(url_visit, url)
                if  abs_url not in Links_ToDo and abs_url not in Links_seen:
                    try:
                        response = requests.get(abs_url, headers=headers)
                        if response.status_code == 200:
                            Links_ToDo.append(abs_url)
                            filename = url_to_file_name_txt(abs_url)
                            filepath = os.path.join(os.getcwd(), 'LINKPAGES', 'TXT', filename)
                            with open(filepath, 'w') as f:
                                f.write(abs_url)
                        else:
                            print("Error: {} returned status code {}".format(abs_url, response.status_code))
                    except requests.exceptions.RequestException as e:
                        print("Error: {}".format(e))
    if Links_ToDo:
        get_Links(Links_ToDo.pop())
    else:
        return

url="https://www.tripadvisor.com.vn/Restaurants-g293925-Ho_Chi_Minh_City.html"
Links_ToDo=[url]
Links_seen=[]
get_Links(Links_ToDo.pop())



