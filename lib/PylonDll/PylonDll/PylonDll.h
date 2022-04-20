#pragma once
#include <iostream>
#include <thread>
#include <pylon/PylonIncludes.h>
#include <GenICam.h>
//#include <PylonIncludes.h>

using namespace std;
using namespace Pylon;

intptr_t(*CallbackFunction)(uint8_t*);


class PylonDll
{
    public:
        static void StartWork() {
            running_work_ = new PylonDll();
            running_work_->Start();
        }

        static void StopWork() {
            running_work_->Stop();
            delete running_work_;
            running_work_ = nullptr;
        }

    private:
        static PylonDll* running_work_;
        CInstantCamera Camera;
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

