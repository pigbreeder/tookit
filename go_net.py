#!/usr/bin/python3
#-*-coding:utf-8-*-
import base64
import requests
import hashlib
import argparse

# 使用需安装requests
# 
# login
# ./go_net.py login -u your_username -p your_password
# 
# logout
# ./go_net.py logout

######################################
url = 'http://10.10.43.3'
pid = '2'
logout_htm = '/F.htm'
username = ''
password = ''
headers = { "Host": "10.10.43.3",
            "Origin":"10.10.43.3",
            "Refer":"10.10.43.3",
            "Accept": "application/json, text/javascript, */*; q=0.01",
            "Accept-Language":"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3",
            "Accept-Encoding": "gzip, deflate",
            "Content-Type":"application/x-www-form-urlencoded",
            "Upgrade-Insecure-Requests": "1",
            "Connection":"keep-alive",
            "charset":"UTF-8",
            'User-Agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36'}


def login():
    def acquire_cookies():
        r = requests.get(url, headers=headers)
        print (r.text)
    def curlmd5(src):
        m = hashlib.md5()
        m.update(src.encode('UTF-8'))
        print(m.hexdigest())
        print(type(m.hexdigest()))
        return m.hexdigest()

    def send_msg():
        calg = requests.get(url + '/md5calg').json()
        tmp = pid + password + calg['calg']
        print (tmp)
        upass = curlmd5(tmp) + calg['calg'] + pid
        data = {'DDDDD':username, \
            'upass':upass,'R1':'0','R2':'1','R1':'0', \
            'para':'00','hid1':'','hid2':'', \
            '0MKKey':'123456'} 
        # print(data)
        r = requests.post(url, data=data, headers=headers)
        # print(r.text)
    send_msg()
def logout():
    r = requests.get(url + logout_htm)
    if r.status_code == 200:
        print("logout success")

def main():
    global username, password
    parser = argparse.ArgumentParser()
    parser.add_argument('function',help="echo login or logout")
    parser.add_argument('-u', '--username')
    parser.add_argument('-p', '--password')
    args = parser.parse_args()
    # print(args)
    username = args.username
    password = args.password
    # print(username,password)
    if args.function == 'login':
        if username == '' or username == None or password == '' or password == None:
            print('please input username and password')
            exit()
        login()
    elif args.function == 'logout':
        logout()
if __name__ == '__main__':
    main()