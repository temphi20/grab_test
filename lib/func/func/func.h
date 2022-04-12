#include <iostream>
#include <pylon/PylonIncludes.h>

#pragma once

#ifdef FUNC_EXPORTS
#define FUNC_API extern "C" __declspec(dllexport)
#else
#define FUNC_API __declspec(dllimport)
#endif


intptr_t(*callbackFunction)(uint8_t*);

FUNC_API void grab_one(uint8_t*);
FUNC_API void grab_retrieve(uint8_t*);

FUNC_API void SetCallbackFunction(intptr_t(*callback)(uint8_t*));
FUNC_API void __stdcall grab_call();
FUNC_API void __stdcall grab_call_async();

FUNC_API void grab_sync();
FUNC_API void get_result(uint8_t*);
FUNC_API uint8_t* get_result_global();

FUNC_API void initialize();
FUNC_API void terminate();
FUNC_API void close();
FUNC_API void stop();