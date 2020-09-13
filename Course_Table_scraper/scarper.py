import requests
import bs4

# variable part
course_collection = {}
#======================#

req = requests.Session()  # Seesion 儲存傳給伺服器的(對話)cookies

#=====================#
student_id = 'a1085508'
#=====================#

# post elearning
req.post('http://elearning.nuk.edu.tw/p_login_stu_at.php?bStu_id='+student_id)
r = req.get('http://elearning.nuk.edu.tw/m_student/m_stu_index.php')
r.encoding = 'utf-8'

# make a soup
soup = bs4.BeautifulSoup(r.text,'html.parser')

# course_list
course_list = soup.find('tbody').find_all('tr')

# course collection
# type
# {'course_name':
#               {
#                 'time':'(3)_1_2_3',
#                 'place':''
#               }
# }

for cl in course_list:
    course_data = cl.find_all('td')
    
    # fill the course_detail
    course_detail = {}
    course_detail['time']= course_data[4].text
    course_detail['place']= course_data[5].text

    # courses_collection with details
    if course_data[1].text[:5] == '109-1':
        course_collection[course_data[1].text[5:]] = course_detail

# testing
print(course_collection)