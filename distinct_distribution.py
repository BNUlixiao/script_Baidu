# -*- coding: utf-8 -*-
"""
Created on Sat May 28 20:58:49 2016

@author: light
"""

def distinct_distribution(input_file,key_column,distinct_column):

    import codecs    
        
    data = codecs.open(input_file,'r','utf-8')
    # data = open(input_file,'r',)
    
    key_column = key_column - 1
    distinct_column = distinct_column - 1
    
    output_dict = {}
    distinct_set = set()   

    for line in data:

        key_temp = line.split('\t')[key_column]
        distinct_temp = line.split('\t')[distinct_column]
        
        if distinct_temp in distinct_set:
            pass
        else:
            distinct_set.add(distinct_temp)
            
            if key_temp in set(output_dict.keys()):
                output_dict[key_temp] = output_dict[key_temp] + 1
            else:
                output_dict[key_temp] = 1
    
    return output_dict,len(distinct_set)

    
def writer_csv(output_file,output_dict):

    import csv

    output_data = open(output_file,'w',newline="")
    writer = csv.writer(output_data)

    for key in output_dict.keys():
        value = output_dict[key]
        writer.writerow([key,value])
        
    output_data.close()

    return


# 参数：输入文件路径，主列序号，去重列序号
output_dict,num = distinct_distribution('D:\\backup\\clientdata001.txt',6,7)

# 参数：输出文件路径，数据字典
writer_csv('D:\\backup\\clientdata001.csv',output_dict)
print(num)