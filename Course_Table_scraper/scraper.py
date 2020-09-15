import requests
import bs4
import re
import json

def get_course_table(account, password):
    req = requests.Session()  # Seesion 儲存傳給伺服器的(對話)cookies

    req.post('https://course.nuk.edu.tw/Sel/SelectMain1.asp',{'Account':account,'Password':password})
    r=req.get('https://course.nuk.edu.tw/Sel/query3.asp')
    r.encoding = 'big5'

    try:
        soup =  bs4.BeautifulSoup(r.text, 'lxml')
        tr_list = soup.find('table').find_all('tr')
    except:
        tr_list = []
        print(">>帳後密碼錯誤<<")

    course_list = []

    for tr in tr_list[1:]:
        c_d = {}
        raw_list = tr.text.split(' ')
        
        c_d['name'] =  raw_list[3]
        c_d['credit'] = int(raw_list[5])
        c_d['time'] = time_split(raw_list[6])
        c_d['location'] = list(set(raw_list[7].split(',')))
        c_d['teacher'] = raw_list[8]

        course_list.append(c_d)
    
    return course_list

def time_split(raw_time):
    weekdays = '一二三四五六日'
    times = []
    period_list = []
    week_list = []

    for d in re.split(r'[^0-9X-Y]', raw_time):
        if d != '':
            period_list.append(d)
    for w in re.split(r'[0-9X-Y]', raw_time):
        if w != '':
            week_list.append(w)

    diff_week = list(set(week_list))

    for dd in diff_week:
        periods = []
        for i in range(len(week_list)):
            if week_list[i] == dd:
                periods.append(period_list[i])

        times.append([weekdays.find(dd)+1, periods]) 
    return times