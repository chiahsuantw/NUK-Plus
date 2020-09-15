import requests
import bs4
import re
import json

req = requests.Session()  # Seesion 儲存傳給伺服器的(對話)cookies

# ==================== #
# 帳號密碼
account = 'a1085508'
password = 's125367799'
# ==================== #

req.post('https://course.nuk.edu.tw/Sel/SelectMain1.asp',{'Account':account,'Password':password})
r=req.get('https://course.nuk.edu.tw/Sel/roomlist1.asp')
r.encoding = 'big5'

soup =  bs4.BeautifulSoup(r.text, 'lxml')
tr_list = soup.find_all('tr')

# courses dict is for selecting time section
# courses_lisr is for json file
courses = {}
courses_list = []
# time adder
weekday = 0
time_period = 0

# first, make a dict of courses
for tr in tr_list:
    td_list = tr.find_all('td')
    for td in td_list[2:]:
        if td.text != '　': # strip of last space
            text = str(td)[len(str(td.find('a')))+6:] # change the js code to string
            inform = re.split(r'</?\w*/?>', text)     # get the inform of the course_name, place and href
            course_data = {
                'course_name':inform[2],
                'place':inform[-2],
                'time':[],
                'href':td.find('a')['href']
            }
            courses[inform[2]] = course_data # the form is course_name as the key of dict

# collecting the data of time
for tr in tr_list:
    td_list = tr.find_all('td')
    for td in td_list[2:]:
        if td.text != '　': # strip of last space
            text = str(td)[len(str(td.find('a')))+6:]
            inform = re.split(r'</?\w*/?>', text)
            courses[inform[2]]['time'].append([weekday % 7 + 1, time_period%12+1])
        # calculate time section
        weekday += 1
    time_period += 1


# travel to each website to scrap the information of teacher and credit
for course in list(courses):
    # scraping
    href = courses[course]['href']
    r = requests.get(href)
    r.encoding = 'big5'
    soup = bs4.BeautifulSoup(r.text, 'lxml')
    # teacher and credit
    teacher = soup.find('table').find_all('tr')[2].find_all('td')[1].text
    credit = soup.find('table').find_all('tr')[1].find_all('td')[5].text

    # set credit and teacher
    courses[course]['credit'] = credit
    courses[course]['teacher'] = teacher
    courses_list.append(courses[course])

# output json file
with open('Course_Table.json','w',encoding='utf8') as f:
    f.write(json.dumps(courses_list, ensure_ascii=False).encode("utf8",errors='ignore').decode("utf8",errors='ignore'))