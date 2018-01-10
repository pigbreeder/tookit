#-*-coding:utf-8-*-

import matplotlib.pyplot as plt
import numpy as np
#############################################################################################################
number_N=['50','75','100','125','150']
number_alpha=['0','0.2','0.4','0.6','0.8','1.0']

TUM_dataset=['fr1/desk','fr1/desk2','fr1/room','fr2/desk','fr2/xyz','fr3/office','fr3/nst']
marker_list=['o','D','s','*','d','+',',','h']
color_list=['b','r','c','m','k','#7CFC00','g']
frame_count=[613,639,1360,2964,3669,2585,1682]

TUM_time_N_consumption=[
[70.23, 69.53, 115.41, 250.74, 271.19, 194.66,144.38], # 50
[72.53, 70.19, 117.41, 255.57, 279.81, 204.46,146.32], # 75
[75.73, 76.02, 130.02, 260.75, 292.27, 241.35,159.71], # 100
[77.68, 79.05, 135.38, 278.56, 324.42, 255.70,160.13], # 125
[80.71, 83.69, 140.76, 301.15, 341.66, 277.16,173.51], # 150
]
TUM_time_N_consumption=list(zip(*TUM_time_N_consumption))
print(TUM_time_N_consumption)
# TUM_time_N_consumption=[
# [71.58, 61.13, 162.07, 304.86, 422.20, 232.70,188.42],
# [66.23, 62.19, 146.41, 357.57, 386.91, 304.46,200.00],
# [66.23, 62.19, 146,41, 357.57, 386.91, 304.46,200.00],
# [52.73, 49.02, 82.02,  220.75, 242.27, 241.35,129.71],
# [63.68, 49.05, 115.38, 298.56, 340.42, 255.70,140.13],
# [82.71, 79.69, 143.76, 361.15, 391.66, 277.16,183.51],
# ]
# print(TUM_time_alpha_consumption)


TUM_time_alpha_consumption=[
[79.58, 81.13, 144.07, 303.86, 342.20, 269.70, 173.42],#.0
[79.43, 80.79, 142.41, 304.57, 346.91, 278.46, 172.22],#.2
[79.61, 80.97, 142.77, 302.58, 340.20, 277.35, 171.71],#.4
[80.31, 82.65, 143.38, 305.22, 348.15, 279.87, 171.89],#.6
[79.01, 83.01, 143.59, 302.56, 341.38, 275.80, 174.46],#.8
[79.71, 82.69, 143.44, 302.15, 341.66, 277.16, 173.51],#1.
]


TUM_time_alpha_consumption=list(zip(*TUM_time_alpha_consumption))
# print(TUM_time_alpha_consumption)

yy = TUM_time_N_consumption
xaxis = number_N
xticks = (0,1,2,3,4)
bais = 17

yy=TUM_time_alpha_consumption
xaxis=number_alpha
xticks = (0,1,2,3,4,5)
bais = 17

for idx, y in enumerate(yy):
    # print(idx)
    print(y)
    # y = list(map(lambda x:(x-20)*1.0 / frame_count[idx]/2, y))
    y = list(map(lambda x:(x-bais)*1.0 / frame_count[idx]/2, y))
    print(y)
    
    print('===')
    plt.plot(range(len(xaxis)),y,label=TUM_dataset[idx],linewidth=2,color=color_list[idx],marker=marker_list[idx],markerfacecolor=color_list[idx],markersize=12) 
    plt.xticks(xticks,xaxis)
#plt.plot(x1,y1,label='Frist line',linewidth=3,color='r',marker='o', markerfacecolor='blue',markersize=12) 
#plt.plot(x2,y2,label='second line') 
plt.xlabel('alpha') 
# plt.xlabel('N') 
plt.ylabel('Time(s)') 
plt.title('TUM dataset computational time (per frame)')
# plt.title('TUM dataset RMSE') 
# plt.legend(bbox_to_anchor=(0.25,0.60),fancybox=True,shadow=True)
plt.legend(loc = 'lower right')
plt.show() 
#'alpha='+str(TUM_dataset[idx]) if idx >0 else 'base'