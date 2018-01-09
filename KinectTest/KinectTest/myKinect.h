#pragma once
#pragma once
#include <Kinect.h>
#include <opencv2\opencv.hpp>
#include <iostream>
#include <string>
// Safe release for interfaces
template<class Interface>
inline void SafeRelease(Interface *& pInterfaceToRelease)
{
	if (pInterfaceToRelease != NULL)
	{
		pInterfaceToRelease->Release();
		pInterfaceToRelease = NULL;
	}
}

class CBodyBasics

{
	static constexpr  const char*		rgbSavePathBase="D:\\env\\kinect\\rgb\\";
	static constexpr  const char*		rgbDepthSavePathBase = "D:\\env\\kinect\\rgb_depth\\";
	static constexpr  const char*		depthSavePathBase = "D:\\env\\kinect\\depth\\";
	static constexpr  const char*		depthRgbSavePathBase = "D:\\env\\kinect\\depth_rgb\\";
	static const int        cColorWidth = 1920;
	static const int        cColorHeight = 1080;
	//kinect 2.0 的深度空间的高*宽是 424 * 512，在官网上有说明
	static const int        cDepthWidth = 512;
	static const int        cDepthHeight = 424;
	static const int        cInfraredWidth = 512;
	static const int        cInfraredHeight = 424;

public:
	CBodyBasics();
	~CBodyBasics();
	void                    Update();//获得骨架、背景二值图和深度信息
	HRESULT                 InitializeDefaultSensor();//用于初始化kinect

private:
	IKinectSensor*          m_pKinectSensor;//kinect源
	ICoordinateMapper*      m_pCoordinateMapper;//用于坐标变换
	IBodyFrameReader*       m_pBodyFrameReader;//用于骨架数据读取
	IDepthFrameReader*      m_pDepthFrameReader;//用于深度数据读取
	IBodyIndexFrameReader*  m_pBodyIndexFrameReader;//用于背景二值图读取
	IColorFrameReader*		m_pColorFrameReader; //rgb
	IInfraredFrameReader*	m_pInfraredFrameReader; //infrared
	DepthSpacePoint*        m_pDepthCoordinates;
	CameraSpacePoint*		m_depthCameraSpacePoint;
	CameraSpacePoint*		m_colorCameraSpacePoint;
	CameraSpacePoint*		m_colorOupputCameraSpacePoint;
	ColorSpacePoint*		m_pColorCoordinates;
													//通过获得到的信息，把骨架和背景二值图画出来
	void                    ProcessBody(int nBodyCount, IBody** ppBodies);
	//画骨架函数
	void DrawBone(const Joint* pJoints, const DepthSpacePoint* depthSpacePosition, JointType joint0, JointType joint1);
	//画手的状态函数
	void DrawHandState(const DepthSpacePoint depthSpacePosition, HandState handState);
	void ProcessFrame(INT64 nTime,
		const UINT16* pDepthBuffer,
		const RGBQUAD* pColorBuffer);
	void writeToFile(CameraSpacePoint* points, std::string savePath);
	
	//显示图像的Mat
	cv::Mat skeletonImg;
	cv::Mat depthImg;
	cv::Mat depthNormalImg;
	cv::Mat rgbImg;
	cv::Mat infraredImg;
	cv::Mat infraredNormImg;
	cv::Mat rgbdImg;
	char*	writeArray;
};

