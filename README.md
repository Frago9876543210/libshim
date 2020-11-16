# libshim
Shim library to resolve undefined runtime symbols

### Usage
This library allows to make re-export of undefined symbols to solve runtime errors. In some cases linker can't find symbols in runtime.
It can be solved through `extern "C" void symbol()` but isn't suitable when binary file contains ton of classes and looks ugly.

The point of view is to generate proxies for unresolved symbols. This library can be statically linked with cmake project and provide `SYMBOLS_SHIM_PATH` variable, which is wrapper around assembler macro.

[Example CMakeLists.txt](https://github.com/Frago9876543210/libshim-demo/blob/master/injector/CMakeLists.txt)
```cmake
cmake_minimum_required(VERSION 3.11)
project(injector)

set(CMAKE_CXX_STANDARD 11)

#libshim
include(FetchContent)

set(LIBSHIM_BUILD_TYPE "STATIC" CACHE INTERNAL "")
set(SYMBOLS_SHIM_PATH "${PROJECT_SOURCE_DIR}/shim_demo" CACHE INTERNAL "")
FetchContent_Declare(shim
    GIT_REPOSITORY https://github.com/Frago9876543210/libshim
    GIT_TAG v1.0.0)
FetchContent_MakeAvailable(shim)

add_library(injector SHARED injector.cpp)
target_link_libraries(injector PRIVATE shim)
```

shim_demo file looks like that: (It can be specified using `SYMBOLS_SHIM_PATH` variable)
```
//This file is included into `shim.S` and actually is assembly language
//but it's assumed that only symbol_shim <undefined_symbol> <actual_symbol> macro used
symbol_shim _ZN14string_wrapperC1EPcm _ZN14string_wrapperC2EPcm
symbol_shim _ZN14string_wrapperD1Ev _ZN14string_wrapperD2Ev
```

Macro define `undefined_symbol` and put `jmp actual_symbol@PLT` into it's code. Here's an example c-like macro to better explain:
```c
#define symbol_shim(undefined_symbol, actual_symbol)  \
__asm {                                               \
    undefined_symbol: #create label                   \
        jmp actual_symbol@PLT #jump to defined symbol \
}
```
