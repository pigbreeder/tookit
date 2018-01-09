#include "stdafx.h"
#include <iostream>
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;

int main() {
	Mat img = imread("C:\\Users\\lenovo\\Desktop\\mandrill.bmp", 0);

	cvNamedWindow("原图");
	imshow("原图 ", img);
	imwrite("原图.jpg", img);
	waitKey(0);
	//找感兴趣区域
	Mat roi = img(Rect(55, 10, 145, 40));
	//画白框
	Mat src_roi = imread("C:\\Users\\lenovo\\Desktop\\mandrill.bmp", 0);
	rectangle(src_roi, Rect(55, 10, 145, 40), Scalar(255, 255, 255), 2); //将感兴趣区域框出来
	imshow("划线", src_roi);
	imwrite("划线.jpg", src_roi);
	waitKey(0);
	//平移
	Mat src_py = imread("C:\\Users\\lenovo\\Desktop\\mandrill.bmp", 0);
	Mat imageROI = src_py(Rect(55, 50, 145, 40));
	roi.copyTo(imageROI, roi);
	cvNamedWindow("平移");
	imshow("平移", src_py);
	imwrite("平移.jpg", src_py);
	waitKey(0);
	//镜像平移
	Mat roi1 = img(Rect(55, 10, 145, 40));
	Mat src_jx_py = imread("C:\\Users\\lenovo\\Desktop\\mandrill.bmp", 0);
	Mat dst;
	dst.create(roi1.size(), roi1.type());
	Mat map_x;
	Mat map_y;
	map_x.create(roi1.size(), CV_32FC1);
	map_y.create(roi1.size(), CV_32FC1);
	for (int i = 0; i < roi.rows; ++i)
	{
		for (int j = 0; j < roi.cols; ++j)
		{
			map_x.at<float>(i, j) = (float)j;//j;//(src.cols - j) ;
			map_y.at<float>(i, j) = (float)(roi1.rows - i);
		}
	}
	remap(roi1, dst, map_x, map_y, CV_INTER_LINEAR);

	cvNamedWindow("ROI1");
	imshow("ROI1", dst);
	waitKey(0);
	Mat imageROI1 = src_jx_py(Rect(55, 50, 145, 40));
	dst.copyTo(imageROI1, roi1);
	cvNamedWindow("对称");
	imshow("对称", src_jx_py);

	imwrite("对称.jpg", src_jx_py);
	waitKey(0);
	return 0;
}