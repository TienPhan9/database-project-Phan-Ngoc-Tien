from selenium import webdriver
from selenium.webdriver.common.by import By
import time

options = webdriver.ChromeOptions()
options.add_argument('--ignore-certificate-errors')
options.add_argument('--allow-running-insecure-content')
driver = webdriver.Chrome(options=options)
driver.get('https://www.tripadvisor.com.vn/Restaurant_Review-g293925-d9705561-Reviews-Le_Corto_Restaurant-Ho_Chi_Minh_City.html')

# Find the "Chi tiết" link and click it
chi_tiet_link = driver.find_element(By.XPATH, '//a[text()="Xem tất cả chi tiết"]')
chi_tiet_link.click()

# Wait for the page to load the expanded details
time.sleep(5)

# Find all of the "SrqKb" elements, which should include the expanded details
details = driver.find_elements(By.XPATH, '//div[@class="SrqKb"]')

# Loop through each "SrqKb" element and extract the text of its child elements
dt_list_text = []
for detail in details:
    dt_text = []
    for dt in detail.find_elements(By.XPATH, './*'):
        if dt.text:
            dt_text.append(dt.text)
    dt_list_text.append(dt_text)

for dt in dt_list_text:
    print('\n'.join(dt))