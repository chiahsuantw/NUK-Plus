import requests
import bs4
import re

req = requests.Session()  # Seesion 儲存傳給伺服器的(對話)cookies

# ==================== #
# 帳號密碼
account = 'a1085508'
password = 's125367799'
# ==================== #
headers={
    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36'
}

req.post('https://course.nuk.edu.tw/Sel/SelectMain1.asp',{'Account':account,'Password':password})
r=req.get('https://course.nuk.edu.tw/Sel/roomlist1.asp', headers=headers)
r.encoding = 'big5'

soup =  bs4.BeautifulSoup(r.text, 'lxml')
tr_list = soup.find_all('tr')

weekday = 0
time_period = 0
for tr in tr_list:
    td_list = tr.find_all('td')
    for td in td_list[2:]:
        if td.text != '　':
            print('星期', weekday % 7 + 1, td.text, '第'+str(time_period%12+1)+'節')
        weekday += 1
    time_period += 1