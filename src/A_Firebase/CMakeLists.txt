set(MODULE_NAME Firebase)

add_library(${MODULE_NAME}Module STATIC
    FirebaseUploader.cc
)

target_link_libraries(${MODULE_NAME}Module
    PRIVATE
        Qt6::Network
)