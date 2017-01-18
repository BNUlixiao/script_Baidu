# -*- coding: utf-8 -*-
"""
Created on Sun Dec  4 14:51:58 2016

@author: lixiao22
"""

# 鉴权cookie
cookie = 'sid=XmtqTYJbEQQIFZzPngJnsd5WIA0SXDdP_19'

# 对应全部样式
customer_list1 = ['easoukehuduan','leilixian','zhongwenwanwei','CMcm2015','共和盛世','shoujiduoduobj','sinyee4work','mucangtech','qizhigang','小米科技有限责任公司','驾校一点通网','zplaytx','skydhk','lianchao777','zhengbangcom','sjzt-UN','mojichina','久邦数码GO桌面','suishenyun','meetyouad']
output_path1 = 'D:\\all.csv'

# 对应信息流样式
customer_list2 = ['easoukehuduan','leilixian','CMcm2015','共和盛世','shoujiduoduobj','mucangtech','小米科技有限责任公司','驾校一点通网','lianchao777','zhongwenwanwei','mojichina','久邦数码GO桌面','zhengbangcom','sjzt-UN','suishenyun','meetyouad']
output_path2 = 'D:\\feed.csv'

# 从ubi接口获取数据，每次查询一个用户。默认为全部样式，全部DSP，本周数据
def get_data_from_ubi(cookie, customer, is_feed = 0, is_mdsp = 0, is_lastweek = 0):
    
    import datetime, requests, json
    
    url = 'http://backend.ubi.baidu.com/rest/mobile/app/customize/customize'
    
    headers = {}
    headers['Cookie'] = cookie
    
    parms = {}    
    parms['index'] = 'gain,adview,cpm2'
    parms['customerid'] = 'gettotal,part,' + customer
    if is_lastweek != 0:
        parms['multiday'] = (datetime.datetime.today() - datetime.timedelta(days=14)).strftime('%Y-%m-%d') + ' ~ ' + (datetime.datetime.today() - datetime.timedelta(days=8)).strftime('%Y-%m-%d') + ',avg'
    else:
        parms['multiday'] = (datetime.datetime.today() - datetime.timedelta(days=7)).strftime('%Y-%m-%d') + ' ~ ' + (datetime.datetime.today() - datetime.timedelta(days=1)).strftime('%Y-%m-%d') + ',avg'
    if is_feed != 0:
        parms['prodtype'] = '7'
    else:
        pass
    if is_mdsp != 0:
        parms['dsp'] = '6'
    else:
        pass

    count = 0
    while count < 5:
        resp = requests.post(url, data=parms, headers=headers)
        if str(resp) == '<Response [200]>' and (list(json.loads(resp.text)['customize'].values()) != []):
            data = list(json.loads(resp.text)['customize'].values())[0]
            avg_adview = float(data['avg_adview']['today'])
            avg_gain = float(data['avg_gain']['today'])
            avg_cpm = float(data['avg_cpm2']['today'])
            break
        count = count + 1
    else:
        avg_adview = 0
        avg_gain = 0
        avg_cpm = 0    
    
    return avg_adview, avg_gain, avg_cpm


import csv

# 导出top媒体全部样式数据
output_csv1 = open(output_path1, 'w', newline='') 
writer = csv.writer(output_csv1)

writer.writerow(['会员名', '本周总体展现', '总体展现变化量', '总体展现变化率' ,'本周总体消费', '总体消费变化量', '总体消费变化率', '本周总体CPM', '总体CPM变化量', '总体CPM变化率', 'MDSP展现', 'MDSP展现变化量', 'MDSP展现变化率' ,'MDSP消费', 'MDSP消费变化量', 'MDSP消费变化率', 'MDSPCPM', 'MDSPCPM变化量', 'MDSPCPM变化率'])

for customer in customer_list1:
    
    thisweek_alldsp_avg_adview, thisweek_alldsp_avg_gain, thisweek_alldsp_avg_cpm = get_data_from_ubi(cookie, customer, 0, 0, 0)
    lastweek_alldsp_avg_adview, lastweek_alldsp_avg_gain, lastweek_alldsp_avg_cpm = get_data_from_ubi(cookie, customer, 0, 0, 1)
    thisweek_mdsp_avg_adview, thisweek_mdsp_avg_gain, thisweek_mdsp_avg_cpm = get_data_from_ubi(cookie, customer, 0, 1, 0)
    lastweek_mdsp_avg_adview, lastweek_mdsp_avg_gain, lastweek_mdsp_avg_cpm = get_data_from_ubi(cookie, customer, 0, 1, 1)
    
    col_1 = customer
    col_2 = thisweek_alldsp_avg_adview
    col_3 = thisweek_alldsp_avg_adview - lastweek_alldsp_avg_adview
    if lastweek_alldsp_avg_adview == 0:
        col_4 = 0
    else:
        col_4 = thisweek_alldsp_avg_adview / lastweek_alldsp_avg_adview - 1 
    col_5 = thisweek_alldsp_avg_gain
    col_6 = thisweek_alldsp_avg_gain - lastweek_alldsp_avg_gain
    if lastweek_alldsp_avg_gain == 0:
        col_7 = 0
    else:
        col_7 = thisweek_alldsp_avg_gain / lastweek_alldsp_avg_gain - 1     
    col_8 = thisweek_alldsp_avg_cpm
    col_9 = thisweek_alldsp_avg_cpm - lastweek_alldsp_avg_cpm
    if lastweek_alldsp_avg_cpm == 0:
        col_10 = 0
    else:
        col_10 = thisweek_alldsp_avg_cpm / lastweek_alldsp_avg_cpm - 1 
    col_11 = thisweek_mdsp_avg_adview
    col_12 = thisweek_mdsp_avg_adview - lastweek_mdsp_avg_adview
    if lastweek_mdsp_avg_adview == 0:
        col_13 = 0
    else:
        col_13 = thisweek_mdsp_avg_adview / lastweek_mdsp_avg_adview - 1 
    col_14 = thisweek_mdsp_avg_gain
    col_15 = thisweek_mdsp_avg_gain - lastweek_mdsp_avg_gain
    if lastweek_mdsp_avg_gain == 0:
        col_16 = 0
    else:
        col_16 = thisweek_mdsp_avg_gain / lastweek_mdsp_avg_gain - 1     
    col_17 = thisweek_mdsp_avg_cpm
    col_18 = thisweek_mdsp_avg_cpm - lastweek_mdsp_avg_cpm
    if lastweek_mdsp_avg_cpm == 0:
        col_19 = 0
    else:
        col_19 = thisweek_mdsp_avg_cpm / lastweek_mdsp_avg_cpm - 1 
    
    writer.writerow([col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19])
   
output_csv1.close()

# 导出top媒体信息流数据
output_csv2 = open(output_path2, 'w', newline='') 
writer = csv.writer(output_csv2)

writer.writerow(['会员名', '本周信息流展现', '信息流展现变化量', '信息流体展现变化率' ,'本周信息流消费', '信息流消费变化量', '信息流消费变化率', '本周信息流CPM', '信息流CPM变化量', '信息流CPM变化率', 'MDSP信息流展现', 'MDSP信息流展现变化量', 'MDSP信息流展现变化率' ,'MDSP信息流消费', 'MDSP信息流消费变化量', 'MDSP消信息流费变化率', 'MDSP信息流CPM', 'MDSP信息流CPM变化量', 'MDSP信息流CPM变化率'])

for customer in customer_list2:
    
    thisweek_alldsp_avg_adview, thisweek_alldsp_avg_gain, thisweek_alldsp_avg_cpm = get_data_from_ubi(cookie, customer, 1, 0, 0)
    lastweek_alldsp_avg_adview, lastweek_alldsp_avg_gain, lastweek_alldsp_avg_cpm = get_data_from_ubi(cookie, customer, 1, 0, 1)
    thisweek_mdsp_avg_adview, thisweek_mdsp_avg_gain, thisweek_mdsp_avg_cpm = get_data_from_ubi(cookie, customer, 1, 1, 0)
    lastweek_mdsp_avg_adview, lastweek_mdsp_avg_gain, lastweek_mdsp_avg_cpm = get_data_from_ubi(cookie, customer, 1, 1, 1)
    
    col_1 = customer
    col_2 = thisweek_alldsp_avg_adview
    col_3 = thisweek_alldsp_avg_adview - lastweek_alldsp_avg_adview
    if lastweek_alldsp_avg_adview == 0:
        col_4 = 0
    else:
        col_4 = thisweek_alldsp_avg_adview / lastweek_alldsp_avg_adview - 1 
    col_5 = thisweek_alldsp_avg_gain
    col_6 = thisweek_alldsp_avg_gain - lastweek_alldsp_avg_gain
    if lastweek_alldsp_avg_gain == 0:
        col_7 = 0
    else:
        col_7 = thisweek_alldsp_avg_gain / lastweek_alldsp_avg_gain - 1     
    col_8 = thisweek_alldsp_avg_cpm
    col_9 = thisweek_alldsp_avg_cpm - lastweek_alldsp_avg_cpm
    if lastweek_alldsp_avg_cpm == 0:
        col_10 = 0
    else:
        col_10 = thisweek_alldsp_avg_cpm / lastweek_alldsp_avg_cpm - 1 
    col_11 = thisweek_mdsp_avg_adview
    col_12 = thisweek_mdsp_avg_adview - lastweek_mdsp_avg_adview
    if lastweek_mdsp_avg_adview == 0:
        col_13 = 0
    else:
        col_13 = thisweek_mdsp_avg_adview / lastweek_mdsp_avg_adview - 1 
    col_14 = thisweek_mdsp_avg_gain
    col_15 = thisweek_mdsp_avg_gain - lastweek_mdsp_avg_gain
    if lastweek_mdsp_avg_gain == 0:
        col_16 = 0
    else:
        col_16 = thisweek_mdsp_avg_gain / lastweek_mdsp_avg_gain - 1     
    col_17 = thisweek_mdsp_avg_cpm
    col_18 = thisweek_mdsp_avg_cpm - lastweek_mdsp_avg_cpm
    if lastweek_mdsp_avg_cpm == 0:
        col_19 = 0
    else:
        col_19 = thisweek_mdsp_avg_cpm / lastweek_mdsp_avg_cpm - 1 
    
    writer.writerow([col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12, col_13, col_14, col_15, col_16, col_17, col_18, col_19])
   
output_csv2.close()