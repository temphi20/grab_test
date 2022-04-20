#include <iostream>
#include <thread>
#include <pylon/PylonIncludes.h>
#include <memory.h>

#pragma once

#ifdef FUNC_EXPORTS
#define FUNC_API extern "C" __declspec(dllexport)
#else
#define FUNC_API __declspec(dllimport)
#endif

extern const int Width = 2592;
extern const int Height = 2048;
//extern Pylon::CInstantCamera Camera;

intptr_t(*CallbackFunction)(uint8_t*);

FUNC_API void grab_one(uint8_t*);
FUNC_API void grab_retrieve();

FUNC_API void set_callback(intptr_t(*callback)(uint8_t*));
FUNC_API void __stdcall grab_callback();

//FUNC_API void get_result(uint8_t*);
FUNC_API uint8_t* get_result_global();

FUNC_API void initialize();
FUNC_API void terminate();
FUNC_API void close();
FUNC_API void stop();

//void Start_Callback();
//FUNC_API void RegisterCallback(intptr_t(*callback)(uint8_t*));
//FUNC_API void StartWork();
//FUNC_API void StopWork();
//
//class PylonWork
//{
//public:
//    static void StartWork();
//    static void StopWork();
//
//private:
//    static PylonWork* running_work_;
//    //static std::thread* Thread;
//
//    void Start();
//    void Stop();
//};