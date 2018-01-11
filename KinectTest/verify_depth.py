#-*-coding:utf-8-*-
#
#
#
import cv2
import numpy as np
import sys
import array
import OpenEXR
import Imath

__stdout__ = sys.stdout
sys.stdout = open(r'log.txt', 'w')

color_intrinsic_matrix = np.array([
    [1082.1, 0, 958.0],
    [0, 1067.9, 499.4],
    [0, 0, 1.0],
    ])

# 960 540
color_intrinsic_matrix = np.array([
    [563.0898,  0,          485.0045],
    [0,         519.1969,   226.4136],
    [0,         0,          1.0],
    ])
depth_intrinsic_matrix = np.array(
    [
    [338.7279,         0         ,0],
    [0,                338.5754,         0],
    [256.7893,  217.6656,    1.0000],
    ]).T
depth_intrinsic_matrix = np.array(
    [
    [364.531799, 0,         257.591888],
    [0,          364.531799,210.606400],
    [0,          0,         1.0000],
    ])
camera_space_point_type = np.dtype({
    'names':['x', 'y', 'z'],
    'formats':['f','f', 'f']}, align= True )
COLOR_HEIGHT = 1080//2 
COLOR_WIDTH = 1920 //2
DEPTH_HEIGHT = 424
DEPTH_WIDTH = 512

color_size = (COLOR_HEIGHT, COLOR_WIDTH, 3)
depth_size = (DEPTH_HEIGHT, DEPTH_WIDTH, 1)
def load_data(filename):
    with open(filename) as file:
        lines = file.readlines()
    line = lines[0]
    points = line.split(';')
    points = list(filter(lambda x:len(x) > 0, points))
    points = list(map(lambda x:x.split(','), points))
    return points

def load_image(imagename):
    return cv2.imread(imagename)
def load_exr(filename):
    file = OpenEXR.InputFile(filename)
    FLOAT = Imath.PixelType(Imath.PixelType.FLOAT)
    (R,G,B) = [array.array('f', file.channel(Chan, FLOAT)).tolist() for Chan in ("R", "G", "B") ]
    ret = []
    for x,y,z in zip(R,G,B):
        ret.append([x,y,z])
    # print(ret)
    return ret
def map_color_xyz_xy(filename, imagename):
    points = np.fromfile(filename, dtype=camera_space_point_type)
    img_mat = load_image(imagename)
    mat = np.zeros(color_size, np.uint8)
    
    pointss = np.array(map(lambda x:x.tolist(), points))
    loc_idx = np.dot(color_intrinsic_matrix, pointss.T)
    loc_idx = np.nan_to_num(loc_idx.T)
    # 
    print(loc_idx.shape)
    print(loc_idx)
    tot=0
    for idx in range(COLOR_HEIGHT * COLOR_WIDTH):
        height = idx // COLOR_WIDTH
        width = idx % COLOR_WIDTH
        # print('loc_idx',idx,loc_idx[idx])
        if loc_idx[idx][2] < 1e-9:
            tot+=1
            continue
        w, h = int(loc_idx[idx][0] / loc_idx[idx][2] + 0.5), int(loc_idx[idx][1] / loc_idx[idx][2]  + 0.5)
        # print(height, width, loc_idx[idx], h,w,)
        # print(height, width, '=>', h,w)
        if (h < 0 or h >= COLOR_HEIGHT) or (w < 0 or w >= COLOR_WIDTH):
            continue
        # if idx % 1000 == 0:
        #     print(idx,loc_idx[idx]/loc_idx[idx][2])
        #     print('---')
        zz = int(loc_idx[idx][2] * 1000 + 0.5)
        # mat[h][w] = 255 - (256 * ((zz & 0xfff8 ) >> 3) /0x0fff);
        mat[h][w] = img_mat[height][width]
        # print(height, width, loc_idx[idx], h,w,)
    print('tot=',tot)
    cv2.imwrite('test.png', mat)
    # cv2.imshow("Image", mat)
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()

def map_depth_xyz_xy(filename, imagename):
    points = load_data(filename)
    img_mat = load_image(imagename)
    mat = np.zeros(depth_size, np.uint8)
    # mat = np.zeros(color_size, np.uint8)
    # 
    #
    # map(lambda x:x.append(1), points)
    for idx in range(len(points)):
        tmp = list(map(lambda x:float(x), points[idx]))
        points[idx] = tmp
    pointss = np.array(points)
    loc_idx = np.dot(depth_intrinsic_matrix, pointss.T)
    loc_idx = np.nan_to_num(loc_idx.T)
    # 
    print(loc_idx.shape)
    for idx in range(DEPTH_HEIGHT * DEPTH_WIDTH):
        height = idx // DEPTH_WIDTH
        width = idx % DEPTH_WIDTH
        
        if loc_idx[idx][2] < 1e-5:
            continue
        w, h = int(loc_idx[idx][0] / loc_idx[idx][2] + 0.5), int(loc_idx[idx][1] / loc_idx[idx][2]  + 0.5)
        if (h < 0 or h >= DEPTH_HEIGHT) or (w < 0 or w >= DEPTH_WIDTH):
            continue
        # if idx % 1000 == 0:
        #     print(idx,loc_idx[idx]/loc_idx[idx][2])
        #     print('---')
        zz = int(loc_idx[idx][2] * 1000 + 0.5)
        mat[h][w] = 255 - (256 * ((zz & 0xfff8 ) >> 3) /0x0fff);
        print(height, width, loc_idx[idx], h,w,)
    

    cv2.imshow("Image", mat)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
    return points, loc_idx, mat, img_mat

def invert_map(imagename):
    img_mat = load_image(imagename)
    for y in range(DEPTH_HEIGHT):
        for x in range(DEPTH_WIDTH):
            print(img_mat[y][x])
def open_test(imagename):
    im = cv2.imread(imagename) # 读取文件
    cv2.namedWindow('lena') # 创建窗口
    cv2.imshow('lena', im) # 在窗口显示图像
    # cv2.waitKey(10000) # 等待10s
    cv2.waitKey(0) # 保持等待直到按下任意键
    cv2.destroyAllWindows() # 释放窗口

# filename = "D:\\env\\kinect\\rgb_camera\\9211844618687.exr"
# imagename = "D:\\env\\kinect\\rgb_depth\\9211844618687.png"
filename = "depth/00081.txt"
imagename = "rgb/00081.png"
# print(depth_intrinsic_matrix)
# open_test(imagename)
map_color_xyz_xy(filename, imagename)
# points, loc_idx, mat, img_mat = map_depth_xyz_xy(filename, imagename)
# invert_map(imagename)

# t = np.dot(depth_intrinsic_matrix , np.array([-2.66480112,2.18722510,3.47000027]))
# print(t)
# print(t/t[2])