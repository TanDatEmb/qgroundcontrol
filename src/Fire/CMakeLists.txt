qt_add_library(FireModule STATIC
    FireZoneManager.cc
    FireZoneManager.h
)

target_include_directories(FireModule PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

qt_add_qml_module(FireModule
    URI QGroundControl.Fire
    VERSION 1.0
    NO_PLUGIN
    SOURCES
        FireZoneManager.cc
        FireZoneManager.h
)
