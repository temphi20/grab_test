#include "func.h"
#include "ImageCreator.h"
#include <memory.h>
#include <thread>
#include <future>

using namespace Pylon;
using namespace std;

static const uint32_t c_countOfImagesToGrab = 100;

void printImageProperties(IImage& image)
{
	cout
		<< "Buffer: " << image.GetBuffer()
		<< " Image Size: " << image.GetImageSize()
		<< " Width: " << image.GetWidth()
		<< " Height: " << image.GetHeight()
		<< " Unique: " << image.IsUnique()
		<< endl;
}

void grab_one(uint8_t* ptrResult) {
	PylonInitialize();
	cout << "initialize" << endl;

	try
	{
		CGrabResultPtr ptrGrabResult;
		CInstantCamera camera(CTlFactory::GetInstance().CreateFirstDevice());
		cout << "create firest device" << endl;
		camera.GrabOne(1000, ptrGrabResult);

		if (ptrGrabResult && ptrGrabResult->GrabSucceeded()) {
			memcpy(ptrResult, (uint8_t*)ptrGrabResult->GetBuffer(), 2592*2048);
		}
	}
	catch (const GenericException& e)
	{
		cerr << "exception: " << e.GetDescription() << endl;
	}

	PylonTerminate();
	cout << "terminate" << endl;
}

void grab_retrieve(uint8_t* ptrResult) {
	PylonInitialize();
	cout << "initialize" << endl;
	
	try
	{
		CPylonImage pylonImage;
		CImageFormatConverter converter;
		converter.OutputPixelFormat = PixelType_Mono8;
		CPylonImage imageRGB16packed;

		const uint32_t cWidth = 640;
		const uint32_t cHeight = 480;
		//CImageFormatConverter converter;

		CInstantCamera camera(CTlFactory::GetInstance().CreateFirstDevice());
		
		cout << "create firest device" << endl;

		//camera.MaxNumBuffer = 5;

		camera.StartGrabbing(c_countOfImagesToGrab);
		CGrabResultPtr ptrGrabResult;

		while (camera.IsGrabbing()) {
			camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
			//cout << "retrieve result" << endl;
			
			if (ptrGrabResult->GrabSucceeded()) {
				//const uint32_t width = ptrGrabResult->GetWidth(), height = ptrGrabResult->GetHeight();
				uint8_t* buf = (uint8_t*)ptrGrabResult->GetBuffer();
				//const int size = (int)_msize(buf);
				cout << "first pixel: " << (uint32_t)buf[0] << endl;
				imageRGB16packed = ImageCreator::CreateMandelbrotFractal(PixelType_RGB16packed, cWidth, cHeight);
				converter.ImageHasDestinationFormat(ptrGrabResult);

				
				/*cout << "buffer size: " << size << endl;*/
				/*for (int i = 0; i < size; i++)
				{
					try
					{
						ptrResult[i] = buf[i];
					}
					catch (const std::exception&)
					{
						cout << "in for catch[" << i << ']' << endl;
					}
					
				}*/
				//cout << "all pixel: " << (uint32_t)buf << endl;
				//break;
			}
			else {
				cout << "error: " << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << endl;
			}
		}
	}
	catch (const GenericException &e)
	{
		cerr << "in catch: " << e.GetDescription() << endl;
	}

	PylonTerminate();
	cout << "terminate" << endl;
}

void SetCallbackFunction(intptr_t(*callback)(uint8_t*)) {
	cout << "Callback cb - " << callback << endl;
	callbackFunction = callback;
}

CRITICAL_SECTION section;
CInstantCamera Camera;
FUNC_API uint8_t* Result =(uint8_t*)calloc(2592*2048, sizeof(uint8_t));
//thread Thread;
thread* ThreadPtr;
const int Width = 2592;
const int Height = 2048;

void grab_sync() {
	try
	{
		Camera.StartGrabbing();
		//InitializeCriticalSection(&section);

		thread t([&]() {
				CGrabResultPtr ptrGrabResult;

				while (Camera.IsGrabbing()) {
					Camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
					if (ptrGrabResult->GrabSucceeded()) {
						//EnterCriticalSection(&section);
						memcpy(Result, (uint8_t*)ptrGrabResult->GetBuffer(), Width * Height);
						//LeaveCriticalSection(&section);
					}
					else {
						cout << "error: " << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << endl;
					}
				}
			});

		t.detach();
		ThreadPtr = &t;
		//Thread.swap(t);
		//t.joinable();
		//Thread.detach();
		cout << "thread test" << endl;
	}
	catch (const GenericException& e)
	{
		cerr << "in catch: " << e.GetDescription() << endl;
	}
}



//void grab_sync() {
//	try
//	{
//		Camera.StartGrabbing();
//		CGrabResultPtr ptrGrabResult;
//		InitializeCriticalSection(&section);
//
//		thread t();
//		
//		while (Camera.IsGrabbing()) {
//			Camera.RetrieveResult(1000, ptrGrabResult, TimeoutHandling_ThrowException);
//			//cout << "retrieve result" << endl;
//
//			if (ptrGrabResult->GrabSucceeded()) {
//				EnterCriticalSection(&section);
//				memcpy(Result, (uint8_t*)ptrGrabResult->GetBuffer(), 2592 * 2048);
//				//cout << "first pixel: " << (uint32_t)Result[0] << endl;
//				LeaveCriticalSection(&section);
//			}
//			else {
//				cout << "error: " << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << endl;
//			}
//		}
//	}
//	catch (const GenericException& e)
//	{
//		cerr << "in catch: " << e.GetDescription() << endl;
//	}
//}

void get_result(uint8_t* ptr) {
	try
	{
		cout << "in get result" << endl;
		EnterCriticalSection(&section);
		memcpy(ptr, Result, Width * Height);
		LeaveCriticalSection(&section);
		cout << "success get" << endl;
	}
	catch (const std::exception&)
	{

	}

}

uint8_t* get_result_global() {
	return Result;
}

void __stdcall grab_call() {
	try
	{
		Camera.StartGrabbing();
		CGrabResultPtr ptrGrabResult;

		while (Camera.IsGrabbing()) {
			Camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
			cout << "retrieve result" << endl;

			if (ptrGrabResult->GrabSucceeded()) {
				uint8_t* buf = (uint8_t*)ptrGrabResult->GetBuffer();
				cout << "first pixel: " << (uint32_t)buf[0] << endl;
				callbackFunction(buf);
			}
			else {
				cout << "error: " << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << endl;
			}
		}
	}
	catch (const GenericException& e)
	{
		cerr << "in catch: " << e.GetDescription() << endl;
	}
}

void __stdcall grab_call_async() {
	try
	{
		Camera.StartGrabbing();
		CGrabResultPtr ptrGrabResult;

		thread t([&] {
			while (Camera.IsGrabbing()) {
				Camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
				cout << "retrieve result" << endl;

				if (ptrGrabResult->GrabSucceeded()) {
					uint8_t* buf = (uint8_t*)ptrGrabResult->GetBuffer();
					cout << "first pixel: " << (uint32_t)buf[0] << endl;
					callbackFunction(buf);
				}
				else {
					cout << "error: " << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << endl;
				}
			}
			});
		//t.join();
	}
	catch (const GenericException& e)
	{
		cerr << "in catch: " << e.GetDescription() << endl;
	}
}

void initialize() {
	PylonInitialize();
	Camera.Attach(CTlFactory::GetInstance().CreateFirstDevice());
	cout << "initialize" << endl;
}

void terminate() {
	Camera.DestroyDevice();
	PylonTerminate();
	DeleteCriticalSection(&section);
	cout << "terminate" << endl;
}

void close() {
	Camera.Close();
	
	cout << "close" << endl;
}

void stop() {
	Camera.StopGrabbing();
	cout << "stop" << endl;
}