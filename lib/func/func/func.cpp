#include "func.h"
#include "ImageCreator.h"
#include <memory.h>
#include <thread>
#include <future>

using namespace Pylon;
using namespace std;

CRITICAL_SECTION section;

FUNC_API uint8_t* Result = (uint8_t*)calloc(Width * Height, sizeof(uint8_t));
thread* ThreadPtr;

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

void grab_retrieve() {
	try
	{
		Camera.StartGrabbing();
		InitializeCriticalSection(&section);

		thread t([&]() {
			CGrabResultPtr ptrGrabResult;

			while (Camera.IsGrabbing()) {
				Camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
				if (ptrGrabResult->GrabSucceeded()) {
					EnterCriticalSection(&section);
					memcpy(Result, (uint8_t*)ptrGrabResult->GetBuffer(), Width * Height);
					LeaveCriticalSection(&section);
				}
				else {
					cout << "error[" << ptrGrabResult->GetErrorCode() << "] " << ptrGrabResult->GetErrorDescription() << endl;
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

uint8_t* get_result_global() {
	return Result;
}

void set_callback(intptr_t(*callback)(uint8_t*)) {
	cout << "Callback cb - " << callback << endl;
	Callback = callback;
}

void __stdcall grab_callback() {
	try
	{
		Camera.StartGrabbing();

		thread t([&]() {
			CGrabResultPtr ptrGrabResult;

			while (Camera.IsGrabbing()) {
				Camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
				if (ptrGrabResult->GrabSucceeded()) {
					//EnterCriticalSection(&section);
					//memcpy(Result, (uint8_t*)ptrGrabResult->GetBuffer(), Width * Height);
					Callback((uint8_t*)ptrGrabResult->GetBuffer());
					//LeaveCriticalSection(&section);
				}
				else {
					cout << "error[" << ptrGrabResult->GetErrorCode() << "] " << ptrGrabResult->GetErrorDescription() << endl;
				}
			}
		});

		t.detach();
		ThreadPtr = &t;
		cout << "thread test" << endl;
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
	ThreadPtr->join();
	cout << "stop" << endl;
}