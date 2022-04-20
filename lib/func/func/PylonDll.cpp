#include "PylonDll.h"
//#include "ImageCreator.h"
//
//#include <thread>
//#include <future>

using namespace Pylon;
using namespace std;

CRITICAL_SECTION section;

FUNC_API uint8_t* Result = (uint8_t*)calloc(Width * Height, sizeof(uint8_t));
thread* ThreadPtr;
CInstantCamera Camera;

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
					cout << Result[0] << endl;
					LeaveCriticalSection(&section);
					//Slepp(6);
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

uint8_t* get_result_global() {
	return Result;
}

void set_callback(intptr_t(*callback)(uint8_t*)) {
	cout << "Callback cb - " << callback << endl;
	CallbackFunction = callback;
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
					CallbackFunction((uint8_t*)ptrGrabResult->GetBuffer());
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

//#include "PylonDll.h"
//
//using namespace std;
//using namespace Pylon;
//
//intptr_t(*CallbackFunction)(uint8_t*);
//thread* Thread;
//CInstantCamera Camera;
//
//void PylonWork::StartWork() {
//    PylonWork::running_work_ = new PylonWork();
//    PylonWork::running_work_->Start();
//}
//
//void PylonWork::StopWork() {
//    PylonWork::running_work_->Stop();
//    delete PylonWork::running_work_;
//    PylonWork::running_work_ = nullptr;
//}
//
//
//void PylonWork::Start() {
//    printf("C Da:  Starting SimulateWork.\n");
//    PylonInitialize();
//    Camera.Attach(CTlFactory::GetInstance().CreateFirstDevice());
//    Camera.StartGrabbing();
//    printf("C Da:   Starting worker threads.\n");
//    Thread = new thread(Start_Callback);
//    printf("C Da:  Started SimulateWork.\n");
//}
//
//void PylonWork::Stop() {
//    printf("C Da:  Stopping SimulateWork.\n");
//    Camera.StopGrabbing();
//    printf("C Da:   Waiting for worker threads to finish.\n");
//    Thread->join();
//    delete Thread;
//    Thread = nullptr;
//    printf("C Da:  Stopped SimulateWork.\n");
//}
//
//
//void StartWork() {
//    PylonWork::StartWork();
//}
//void StopWork() {
//    PylonWork::StopWork();
//}
//
//void Start_Callback() {
//    CGrabResultPtr ptrGrabResult;
//
//    while (Camera.IsGrabbing()) {
//        Camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
//        if (ptrGrabResult->GrabSucceeded()) {
//            //EnterCriticalSection(&section);
//            CallbackFunction((uint8_t*)ptrGrabResult->GetBuffer());
//            Sleep(8);
//            //LeaveCriticalSection(&section);
//        }
//        else {
//            cout << "error[" << ptrGrabResult->GetErrorCode() << "] " << ptrGrabResult->GetErrorDescription() << endl;
//        }
//    }
//}
//
//void RegisterCallback(intptr_t(*callback)(uint8_t*)) {
//    CallbackFunction = callback;
//}