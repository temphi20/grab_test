#include <iostream>
#include <thread>
#include "func.h"

using namespace std;
using namespace Pylon;

intptr_t(*CallbackFunction)(uint8_t*);

void Start_Callback();

class PylonWork
{
    public:
        static void StartWork() {
            running_work_ = new PylonWork();
            running_work_->Start();
        }

        static void StopWork() {
            running_work_->Stop();
            delete running_work_;
            running_work_ = nullptr;
        }

    private:
        static PylonWork* running_work_;
		thread* Thread;

        void Start() {
            printf("C Da:  Starting SimulateWork.\n");
			Camera.StartGrabbing();
            printf("C Da:   Starting worker threads.\n");
            Thread = new thread(Start_Callback);
            printf("C Da:  Started SimulateWork.\n");
        }

        void Stop() {
            printf("C Da:  Stopping SimulateWork.\n");
			Camera.StopGrabbing();
            printf("C Da:   Waiting for worker threads to finish.\n");
            Thread->join();
            delete Thread;
            printf("C Da:  Stopped SimulateWork.\n");
        }
};

FUNC_API void StartWork() {
    PylonWork::StartWork();
}
FUNC_API void StopWork() {
    PylonWork::StopWork();
}

void Start_Callback() {
	CGrabResultPtr ptrGrabResult;

	while (Camera.IsGrabbing()) {
		Camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
		if (ptrGrabResult->GrabSucceeded()) {
			//EnterCriticalSection(&section);
			CallbackFunction((uint8_t*)ptrGrabResult->GetBuffer());
            Sleep(8);
			//LeaveCriticalSection(&section);
		}
		else {
			cout << "error[" << ptrGrabResult->GetErrorCode() << "] " << ptrGrabResult->GetErrorDescription() << endl;
		}
	}
}

FUNC_API void RegisterCallback(intptr_t(*callback)(uint8_t*)) {
    CallbackFunction = callback;
}