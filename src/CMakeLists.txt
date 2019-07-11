
set(CAIROF08_OBJ cairo_surface.f90 cairo_surface_create.c cairo_path.f90)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CAIROF08_INCLUDES})
add_library(${CAIROF08_LIB} SHARED ${CAIROF08_OBJ})

target_link_libraries(${CAIROF08_LIB} ${Cairo_LIBRARIES})

