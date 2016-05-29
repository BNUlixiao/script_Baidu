# -*- coding: utf-8 -*-
"""
Created on Sat May 28 20:58:49 2016

@author: light
"""

def distinct_distribution(input_file,key_column,distinct_column):

    data = open(input_file,'r')    
    
    key_column = key_column - 1
    distinct_column = distinct_column - 1
    
    output_dict = {}
    distinct_set = set()   

    for line in data:

        key_temp = line.split()[key_column]
        distinct_temp = line.split()[distinct_column]
        
        if distinct_temp in distinct_set:
            pass
        else:
            distinct_set.add(distinct_temp)
            
            if key_temp in set(output_dict.keys()):
                output_dict[key_temp] = output_dict[key_temp] + 1
            else:
                output_dict[key_temp] = 1
    
    return output_dict

# 参数：文件路径，主列序号，去重列序号
print(distinct_distribution('C:\\Users\\light\\Desktop\\test.txt',2,3)) 
      