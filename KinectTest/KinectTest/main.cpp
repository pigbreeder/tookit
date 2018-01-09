#include "stdafx.h"
#include "myKinect.h"
#include <iostream>
#include <opencv2\opencv.hpp>
#pragma warning(disable:4996)
using namespace std;

int main()
{
	/*INT64 nTime = 23234;
	std::string s = "D:\\env\\kinect\\" + std::to_string(nTime)+".bmp";
	cout << s << endl;
	system("pause");*/
	//CameraSpacePoint* a = new CameraSpacePoint[960 * 540];
	//FILE * fp = fopen("D:\\env\\kinect\\rgb_depth\\7732469841453.txt", "rb");
	//int i = 0;
	//while (!feof(fp)) { //从文件中读取数据到结构体
	//	fread(a+i, sizeof(CameraSpacePoint), 1, fp);
	//	i++;
	//}
	////fread(a, sizeof(CameraSpacePoint), 960*540,fp);
	//fclose(fp);
	//printf("%f\t%f\t%f", a[0].X, a[0].Y, a[0].Z);
	//char tmp[1024];
	//int size = 0;
	//for (int i = 0; i < 10; i++) {
	//	int t = sprintf(tmp + size, "haha,%d,", i);
	//	size += t;
	//}
	//printf("%s", tmp);
	// size = 0;
	//for (int i = 0; i < 5; i++) {
	//	int t = sprintf(tmp + size, "1234,%d,", i);
	//	size += t;
	//}
	//printf("%s", tmp);
	CBodyBasics myKinect;
	HRESULT hr = myKinect.InitializeDefaultSensor();
	if (SUCCEEDED(hr)) {
		while (1) {
			//Sleep(1000);
			myKinect.Update();
			if (cv::waitKey(1) >= 0)//按下任意键退出
			{
				break;
			}
		}
	}
	else {
		cout << "kinect initialization failed!" << endl;
		
	}
	system("pause");
}