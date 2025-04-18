cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0091 NEW)
project(ingame_overlay)

if(WIN32) # Setup some variables for Windows build
  set(INGAMEOVERLAY_SOURCES
    src/Windows/SimpleWindowsGamingInput.cpp
    src/Windows/RendererDetector.cpp
    src/Windows/DX9Hook.cpp
    src/Windows/DX10Hook.cpp
    src/Windows/DX11Hook.cpp
    src/Windows/DX12Hook.cpp
    src/Windows/OpenGLHook.cpp
    src/Windows/VulkanHook.cpp
    src/Windows/WindowsHook.cpp
  )

  set(PRIVATE_INGAMEOVERLAY_HEADERS
    src/VulkanHelpers.h
    src/Windows/DirectXVTables.h
    src/Windows/SimpleWindowsGamingInput.h
    src/Windows/WindowsGamingInputVTables.h
    src/Windows/DXVKDetector.h
    src/Windows/DX9Hook.h
    src/Windows/DX10Hook.h
    src/Windows/DX11Hook.h
    src/Windows/DX12Hook.h
    src/Windows/OpenGLHook.h
    src/Windows/VulkanHook.h
    src/Windows/WindowsHook.h
  )

  set(IMGUI_SOURCES
    deps/ImGui/backends/imgui_impl_dx9.h
    deps/ImGui/backends/imgui_impl_dx9.cpp
    deps/ImGui/backends/imgui_impl_dx10.h
    deps/ImGui/backends/imgui_impl_dx10.cpp
    deps/ImGui/backends/imgui_impl_dx11.h
    deps/ImGui/backends/imgui_impl_dx11.cpp
    deps/ImGui/backends/imgui_impl_dx12.h
    deps/ImGui/backends/imgui_impl_dx12.cpp
    deps/ImGui/backends/imgui_impl_opengl3.h
    deps/ImGui/backends/imgui_impl_opengl3.cpp
    deps/ImGui/backends/imgui_impl_vulkan.h
    deps/ImGui/backends/imgui_impl_vulkan.cpp
    deps/ImGui/backends/imgui_impl_win32.h
    deps/ImGui/backends/imgui_impl_win32.cpp
    deps/ImGui/backends/imgui_win_shader_blobs.h
    deps/ImGui/backends/imgui_win_shader_blobs.cpp
  )

elseif(APPLE)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
  set(CMAKE_OBJCXX_FLAGS "${CMAKE_OBJCXX_FLAGS} -stdlib=libc++")

  enable_language(OBJCXX)
  link_libraries("-framework AppKit -framework Carbon -framework Metal -framework MetalKit")

  set(INGAMEOVERLAY_SOURCES
    src/MacOSX/RendererDetector.mm
    src/MacOSX/NSViewHook.mm
    src/MacOSX/OpenGLHook.mm
    src/MacOSX/MetalHook.mm
  )

  set(PRIVATE_INGAMEOVERLAY_HEADERS
    src/MacOSX/NSViewHook.h
    src/MacOSX/OpenGLHook.h
    src/MacOSX/MetalHook.h
  )

  set(IMGUI_SOURCES
    deps/ImGui/backends/imgui_impl_opengl2.h
    deps/ImGui/backends/imgui_impl_opengl2.cpp
    deps/ImGui/backends/imgui_impl_opengl3.h
    deps/ImGui/backends/imgui_impl_opengl3.cpp
    deps/ImGui/backends/imgui_impl_metal.h
    deps/ImGui/backends/imgui_impl_metal.mm
    deps/ImGui/backends/imgui_impl_osx.h
    deps/ImGui/backends/imgui_impl_osx.mm
  )

elseif(UNIX)

  set(INGAMEOVERLAY_SOURCES
    src/Linux/RendererDetector.cpp
    src/Linux/OpenGLXHook.cpp
    src/Linux/X11Hook.cpp
    src/Linux/VulkanHook.cpp
  )

  set(PRIVATE_INGAMEOVERLAY_HEADERS
    src/VulkanHelpers.h
    src/Linux/OpenGLXHook.h
    src/Linux/X11Hook.h
    src/Linux/VulkanHook.h
  )

  set(IMGUI_SOURCES
    deps/ImGui/backends/imgui_impl_vulkan.h
    deps/ImGui/backends/imgui_impl_vulkan.cpp
    deps/ImGui/backends/imgui_impl_opengl3.h
    deps/ImGui/backends/imgui_impl_opengl3.cpp
    deps/ImGui/backends/imgui_impl_x11.h
    deps/ImGui/backends/imgui_impl_x11.cpp
  )

else()
  message(FATAL_ERROR "No CMake for other platforms")

endif()

set(CMAKE_C_STANDARD_LIBRARIES "" CACHE STRING "" FORCE)
set(CMAKE_CXX_STANDARD_LIBRARIES "" CACHE STRING "" FORCE)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(INGAMEOVERLAY_DYNAMIC_RUNTIME "Link against dynamic runtime (Windows)" ON)
option(INGAMEOVERLAY_BUILD_TESTS "Build tests." OFF)
option(INGAMEOVERLAY_USE_SPDLOG "Enable logs with SPDLOG." OFF)
option(INGAMEOVERLAY_USE_SYSTEM_LIBRARIES "Use system libraries instead of building them from deps" OFF)

if(WIN32)
option(INGAMEOVERLAY_BUILD_WINDOWS_SHADERS "Build Windows shaders." OFF)
else()
set(INGAMEOVERLAY_BUILD_WINDOWS_SHADERS "" CACHE BOOL OFF FORCE)
endif()

find_package(Threads REQUIRED)

if(NOT ${IMGUI_USER_CONFIG} STREQUAL "")
  set(IMGUI_USER_CONFIG_VALUE IMGUI_USER_CONFIG="${IMGUI_USER_CONFIG}")
  get_filename_component(IMGUI_USER_CONFIG_NAME_VALUE ${IMGUI_USER_CONFIG} NAME)
  set(IMGUI_USER_CONFIG_NAME_VALUE IMGUI_USER_CONFIG="${IMGUI_USER_CONFIG_NAME_VALUE}")
else()
  set(IMGUI_USER_CONFIG "" CACHE FILEPATH "")
endif()

list(APPEND INGAMEOVERLAY_SOURCES
  src/BaseHook.cpp
  src/Internal.cpp
  src/RendererHookInternal.cpp
  src/RendererResourceInternal.cpp
)

list(APPEND PRIVATE_INGAMEOVERLAY_HEADERS
  src/InternalIncludes.h
  src/BaseHook.h
  src/RendererHookInternal.h
  src/RendererResourceInternal.h
)

list(APPEND IMGUI_SOURCES
  deps/ImGui/imgui.cpp
  deps/ImGui/imgui_draw.cpp
  deps/ImGui/imgui_tables.cpp
  deps/ImGui/imgui_widgets.cpp
)

set(INGAMEOVERLAY_HEADERS
  ${CMAKE_CURRENT_SOURCE_DIR}/include/InGameOverlay/RendererHook.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/InGameOverlay/RendererDetector.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/InGameOverlay/RendererResource.h
)

set(INGAMEOVERLAY_IMGUI_HEADERS
  ${CMAKE_CURRENT_SOURCE_DIR}/deps/ImGui/imconfig.h
  ${CMAKE_CURRENT_SOURCE_DIR}/deps/ImGui/imgui.h
  ${CMAKE_CURRENT_SOURCE_DIR}/deps/ImGui/imgui_internal.h
  ${CMAKE_CURRENT_SOURCE_DIR}/deps/ImGui/imstb_rectpack.h
  ${CMAKE_CURRENT_SOURCE_DIR}/deps/ImGui/imstb_textedit.h
  ${CMAKE_CURRENT_SOURCE_DIR}/deps/ImGui/imstb_truetype.h
  $<$<BOOL:${IMGUI_USER_CONFIG}>:${IMGUI_USER_CONFIG}>
)

if(${INGAMEOVERLAY_DYNAMIC_RUNTIME})
set(MINIDETOUR_DYNAMIC_RUNTIME "" CACHE BOOL ON FORCE)
set(MINIDETOUR_DYNAMIC_RUNTIME ON CACHE BOOL "" FORCE)
set(SYSTEM_DYNAMIC_RUNTIME ON CACHE BOOL "" FORCE)
else()
set(MINIDETOUR_DYNAMIC_RUNTIME "" CACHE BOOL OFF FORCE)
set(MINIDETOUR_DYNAMIC_RUNTIME OFF CACHE BOOL "" FORCE)
set(SYSTEM_DYNAMIC_RUNTIME OFF CACHE BOOL "" FORCE)
endif()

if(NOT ${INGAMEOVERLAY_USE_SYSTEM_LIBRARIES})
  if(${INGAMEOVERLAY_USE_SPDLOG})
    add_subdirectory(deps/spdlog EXCLUDE_FROM_ALL)
  endif()
  add_subdirectory(deps/System EXCLUDE_FROM_ALL)
  add_subdirectory(deps/mini_detour EXCLUDE_FROM_ALL)
else()
  if(${INGAMEOVERLAY_USE_SPDLOG})
    find_package(spdlog CONFIG REQUIRED)
  endif()
  find_package(MiniDetour CONFIG REQUIRED)
  find_package(System CONFIG REQUIRED)
endif()

add_library(ingame_overlay
  ${INGAMEOVERLAY_SOURCES}
  ${IMGUI_SOURCES}
  ${INGAMEOVERLAY_IMGUI_HEADERS}
  ${INGAMEOVERLAY_HEADERS}
  ${PRIVATE_INGAMEOVERLAY_HEADERS}
)

set_target_properties(ingame_overlay PROPERTIES
  MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<BOOL:${INGAMEOVERLAY_DYNAMIC_RUNTIME}>:DLL>"
  POSITION_INDEPENDENT_CODE ON
  C_VISIBILITY_PRESET hidden
  CXX_VISIBILITY_PRESET hidden
  VISIBILITY_INLINES_HIDDEN ON
)

target_link_libraries(ingame_overlay
  PUBLIC

  Nemirtingas::System
  Nemirtingas::MiniDetour

  $<$<BOOL:${INGAMEOVERLAY_USE_SPDLOG}>:spdlog::spdlog_header_only>

  $<$<BOOL:${WIN32}>:opengl32>
  $<$<BOOL:${UNIX}>:dl>
  $<$<AND:$<BOOL:${UNIX}>,$<NOT:$<BOOL:${APPLE}>>>:GL>
  $<$<AND:$<BOOL:${UNIX}>,$<NOT:$<BOOL:${APPLE}>>>:X11>
)

target_compile_options(ingame_overlay
  PRIVATE
  $<$<BOOL:${MSVC}>:/MP>
)

target_include_directories(ingame_overlay
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/deps/ImGui>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/VulkanSDK/include>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/glad2/include>

  $<INSTALL_INTERFACE:include>
)

target_compile_definitions(ingame_overlay
  PRIVATE
  IMGUI_DISABLE_WIN32_DEFAULT_IME_FUNCTIONS
  $<$<BOOL:${INGAMEOVERLAY_USE_SPDLOG}>:INGAMEOVERLAY_USE_SPDLOG>
  $<BUILD_INTERFACE:${IMGUI_USER_CONFIG_VALUE}>
  $<BUILD_INTERFACE:IMGUI_DISABLE_DEMO_WINDOWS>
  PUBLIC
  $<INSTALL_INTERFACE:${IMGUI_USER_CONFIG_NAME_VALUE}>
  IMGUI_IMPL_OPENGL_LOADER_CUSTOM
  IMGUI_IMPL_OPENGL_LOADER_GLAD2
  IMGUI_IMPL_VULKAN_NO_PROTOTYPES
  IMGUI_DISABLE_OBSOLETE_KEYIO
  IMGUI_DISABLE_OBSOLETE_FUNCTIONS
  IMGUI_DISABLE_APPLE_GAMEPAD
)

add_library(Nemirtingas::InGameOverlay ALIAS ingame_overlay)
set_target_properties(ingame_overlay PROPERTIES EXPORT_NAME InGameOverlay)

if(${INGAMEOVERLAY_BUILD_TESTS})

  if(WIN32)
    if(INGAMEOVERLAY_BUILD_WINDOWS_SHADERS)
      add_executable(windows_shaders
        tests/windows_shaders_precompile/shaders.h
        tests/windows_shaders_precompile/sha256.h
        tests/windows_shaders_precompile/sha256.cpp
        tests/windows_shaders_precompile/main.cpp
        tests/windows_shaders_precompile/dx9_shaders.cpp
        tests/windows_shaders_precompile/dx10_shaders.cpp
        tests/windows_shaders_precompile/dx11_shaders.cpp
        tests/windows_shaders_precompile/dx12_shaders.cpp
      )
      
      target_link_libraries(windows_shaders
        PRIVATE
        d3dcompiler
      )
    endif()
  
    add_executable(dx9_app
      tests/dx9/main.cpp
      deps/ImGui/imgui.cpp
      deps/ImGui/imgui_demo.cpp
      deps/ImGui/imgui_draw.cpp
      deps/ImGui/imgui_tables.cpp
      deps/ImGui/imgui_widgets.cpp
      deps/ImGui/backends/imgui_impl_dx9.cpp
      deps/ImGui/backends/imgui_impl_win32.cpp
      deps/ImGui/backends/imgui_win_shader_blobs.cpp
    )

    target_include_directories(dx9_app
      PRIVATE
      deps/ImGui
    )

    target_link_libraries(dx9_app
      PRIVATE
      user32
      d3d9
    )

    target_compile_definitions(dx9_app
      PRIVATE
      ${IMGUI_USER_CONFIG_VALUE}
      IMGUI_IMPL_OPENGL_LOADER_CUSTOM
      IMGUI_IMPL_OPENGL_LOADER_GLAD2
      IMGUI_IMPL_VULKAN_NO_PROTOTYPES
      IMGUI_DISABLE_OBSOLETE_KEYIO
      IMGUI_DISABLE_OBSOLETE_FUNCTIONS
      IMGUI_DISABLE_APPLE_GAMEPAD
    )

    set_property(TARGET dx9_app PROPERTY
      MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<BOOL:${INGAMEOVERLAY_DYNAMIC_RUNTIME}>:DLL>")

    add_executable(dx10_app
      tests/dx10/main.cpp
      deps/ImGui/imgui.cpp
      deps/ImGui/imgui_demo.cpp
      deps/ImGui/imgui_draw.cpp
      deps/ImGui/imgui_tables.cpp
      deps/ImGui/imgui_widgets.cpp
      deps/ImGui/backends/imgui_impl_dx10.cpp
      deps/ImGui/backends/imgui_impl_win32.cpp
      deps/ImGui/backends/imgui_win_shader_blobs.cpp
    )

    target_include_directories(dx10_app
      PRIVATE
      deps/ImGui
    )

    target_link_libraries(dx10_app
      PRIVATE
      user32
      d3d10
    )

    target_compile_definitions(dx10_app
      PRIVATE
      ${IMGUI_USER_CONFIG_VALUE}
      IMGUI_IMPL_OPENGL_LOADER_CUSTOM
      IMGUI_IMPL_OPENGL_LOADER_GLAD2
      IMGUI_IMPL_VULKAN_NO_PROTOTYPES
      IMGUI_DISABLE_OBSOLETE_KEYIO
      IMGUI_DISABLE_OBSOLETE_FUNCTIONS
      IMGUI_DISABLE_APPLE_GAMEPAD
    )

    set_property(TARGET dx10_app PROPERTY
      MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<BOOL:${INGAMEOVERLAY_DYNAMIC_RUNTIME}>:DLL>")

    add_executable(dx11_app
      tests/dx11/main.cpp
      deps/ImGui/imgui.cpp
      deps/ImGui/imgui_demo.cpp
      deps/ImGui/imgui_draw.cpp
      deps/ImGui/imgui_tables.cpp
      deps/ImGui/imgui_widgets.cpp
      deps/ImGui/backends/imgui_impl_dx11.cpp
      deps/ImGui/backends/imgui_impl_win32.cpp
      deps/ImGui/backends/imgui_win_shader_blobs.cpp
    )

    target_include_directories(dx11_app
      PRIVATE
      deps/ImGui
    )

    target_link_libraries(dx11_app
      PRIVATE
      user32
      d3d11
    )

    target_compile_definitions(dx11_app
      PRIVATE
      ${IMGUI_USER_CONFIG_VALUE}
      IMGUI_IMPL_OPENGL_LOADER_CUSTOM
      IMGUI_IMPL_OPENGL_LOADER_GLAD2
      IMGUI_IMPL_VULKAN_NO_PROTOTYPES
      IMGUI_DISABLE_OBSOLETE_KEYIO
      IMGUI_DISABLE_OBSOLETE_FUNCTIONS
      IMGUI_DISABLE_APPLE_GAMEPAD
    )

    set_property(TARGET dx11_app PROPERTY
      MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<BOOL:${INGAMEOVERLAY_DYNAMIC_RUNTIME}>:DLL>")

    add_executable(dx12_app
      tests/dx12/main.cpp
      tests/common/imgui_impl_dx12.h
      tests/common/imgui_impl_dx12.cpp
      deps/ImGui/imgui.cpp
      deps/ImGui/imgui_demo.cpp
      deps/ImGui/imgui_draw.cpp
      deps/ImGui/imgui_tables.cpp
      deps/ImGui/imgui_widgets.cpp
      deps/ImGui/backends/imgui_impl_win32.cpp
      deps/ImGui/backends/imgui_win_shader_blobs.cpp
    )

    target_include_directories(dx12_app
      PRIVATE
      deps/ImGui
    )

    target_link_libraries(dx12_app
      PRIVATE
      user32
      d3d12
      dxgi
    )

    target_compile_definitions(dx12_app
      PRIVATE
      ${IMGUI_USER_CONFIG_VALUE}
      IMGUI_IMPL_OPENGL_LOADER_CUSTOM
      IMGUI_IMPL_OPENGL_LOADER_GLAD2
      IMGUI_IMPL_VULKAN_NO_PROTOTYPES
      IMGUI_DISABLE_OBSOLETE_KEYIO
      IMGUI_DISABLE_OBSOLETE_FUNCTIONS
      IMGUI_DISABLE_APPLE_GAMEPAD
    )

    set_property(TARGET dx12_app PROPERTY
      MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<BOOL:${INGAMEOVERLAY_DYNAMIC_RUNTIME}>:DLL>")

    add_executable(windows_opengl3_app
      tests/windows_opengl3/main.cpp
      deps/ImGui/imgui.cpp
      deps/ImGui/imgui_demo.cpp
      deps/ImGui/imgui_draw.cpp
      deps/ImGui/imgui_tables.cpp
      deps/ImGui/imgui_widgets.cpp
      deps/ImGui/backends/imgui_impl_opengl3.cpp
      deps/ImGui/backends/imgui_impl_win32.cpp
    )

    target_include_directories(windows_opengl3_app
      PRIVATE
      deps/ImGui
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/glad2/include>
    )

    target_link_libraries(windows_opengl3_app
      PRIVATE
      user32
      opengl32
    )

    target_compile_definitions(windows_opengl3_app
      PRIVATE
      ${IMGUI_USER_CONFIG_VALUE}
      IMGUI_IMPL_OPENGL_LOADER_CUSTOM
      IMGUI_IMPL_OPENGL_LOADER_GLAD2
      IMGUI_IMPL_VULKAN_NO_PROTOTYPES
      IMGUI_DISABLE_OBSOLETE_KEYIO
      IMGUI_DISABLE_OBSOLETE_FUNCTIONS
      IMGUI_DISABLE_APPLE_GAMEPAD
    )

    set_property(TARGET windows_opengl3_app PROPERTY
      MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<BOOL:${INGAMEOVERLAY_DYNAMIC_RUNTIME}>:DLL>")

    # Vulkan officially supports only 64 bits apps.
    if (CMAKE_SIZEOF_VOID_P EQUAL 8)
      set(GLFW_BUILD_DOCS OFF)
      add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/tests/common/glfw)

      add_executable(windows_vulkan_app
        tests/windows_vulkan/main.cpp
        tests/common/imgui_impl_vulkan.h
        tests/common/imgui_impl_vulkan.cpp
        deps/ImGui/imgui.cpp
        deps/ImGui/imgui_demo.cpp
        deps/ImGui/imgui_draw.cpp
        deps/ImGui/imgui_tables.cpp
        deps/ImGui/imgui_widgets.cpp
        deps/ImGui/backends/imgui_impl_glfw.h
        deps/ImGui/backends/imgui_impl_glfw.cpp
        deps/ImGui/backends/imgui_impl_win32.h
        deps/ImGui/backends/imgui_impl_win32.cpp
      )

      target_include_directories(windows_vulkan_app
        PRIVATE
        deps/ImGui
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tests/common/glfw/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tests/common/vulkansdk/include>
      )

      target_link_libraries(windows_vulkan_app
        PRIVATE
        user32
        shell32.lib
        glfw
        ${CMAKE_CURRENT_SOURCE_DIR}/tests/common/vulkansdk/lib/vulkan-1.lib
      )

      target_compile_definitions(windows_vulkan_app
        PRIVATE
        ${IMGUI_USER_CONFIG_VALUE}
        IMGUI_IMPL_OPENGL_LOADER_CUSTOM
        IMGUI_IMPL_OPENGL_LOADER_GLAD2
        IMGUI_DISABLE_OBSOLETE_KEYIO
        IMGUI_DISABLE_OBSOLETE_FUNCTIONS
        IMGUI_DISABLE_APPLE_GAMEPAD
      )

      set_property(TARGET windows_vulkan_app PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<BOOL:${INGAMEOVERLAY_DYNAMIC_RUNTIME}>:DLL>")
    endif()

  elseif(APPLE)

    add_executable(macos_opengl2_app
      tests/macos_opengl2/main.mm
      tests/common/imgui_impl_osx.h
      tests/common/imgui_impl_osx.mm
      deps/ImGui/imgui.cpp
      deps/ImGui/imgui_demo.cpp
      deps/ImGui/imgui_draw.cpp
      deps/ImGui/imgui_tables.cpp
      deps/ImGui/imgui_widgets.cpp
      deps/ImGui/backends/imgui_impl_opengl2.h
      deps/ImGui/backends/imgui_impl_opengl2.cpp
    )

    target_include_directories(macos_opengl2_app
      PRIVATE
      deps/ImGui
      ${CMAKE_CURRENT_SOURCE_DIR}/src/glad2/include
    )

    target_link_libraries(macos_opengl2_app
      PRIVATE
      dl
    )

    target_compile_definitions(macos_opengl2_app
      PRIVATE
      ${IMGUI_USER_CONFIG_VALUE}
      IMGUI_IMPL_OPENGL_LOADER_CUSTOM
      IMGUI_IMPL_OPENGL_LOADER_GLAD2
      IMGUI_IMPL_VULKAN_NO_PROTOTYPES
      IMGUI_DISABLE_OBSOLETE_KEYIO
      IMGUI_DISABLE_OBSOLETE_FUNCTIONS
      IMGUI_DISABLE_APPLE_GAMEPAD
    )

    add_executable(macos_opengl3_app
      tests/macos_opengl3/main.mm
      tests/common/imgui_impl_osx.h
      tests/common/imgui_impl_osx.mm
      deps/ImGui/imgui.cpp
      deps/ImGui/imgui_demo.cpp
      deps/ImGui/imgui_draw.cpp
      deps/ImGui/imgui_tables.cpp
      deps/ImGui/imgui_widgets.cpp
      deps/ImGui/backends/imgui_impl_opengl3.h
      deps/ImGui/backends/imgui_impl_opengl3.cpp
    )

    target_include_directories(macos_opengl3_app
      PRIVATE
      deps/ImGui
      ${CMAKE_CURRENT_SOURCE_DIR}/src/glad2/include
    )

    target_link_libraries(macos_opengl3_app
      PRIVATE
      dl
    )

    target_compile_definitions(macos_opengl3_app
      PRIVATE
      ${IMGUI_USER_CONFIG_VALUE}
      IMGUI_IMPL_OPENGL_LOADER_CUSTOM
      IMGUI_IMPL_OPENGL_LOADER_GLAD2
      IMGUI_IMPL_VULKAN_NO_PROTOTYPES
      IMGUI_DISABLE_OBSOLETE_KEYIO
      IMGUI_DISABLE_OBSOLETE_FUNCTIONS
      IMGUI_DISABLE_APPLE_GAMEPAD
    )

    add_executable(macos_metal_app
      tests/macos_metal/main.mm
      tests/common/imgui_impl_osx.h
      tests/common/imgui_impl_osx.mm
      deps/ImGui/imgui.cpp
      deps/ImGui/imgui_demo.cpp
      deps/ImGui/imgui_draw.cpp
      deps/ImGui/imgui_tables.cpp
      deps/ImGui/imgui_widgets.cpp
      deps/ImGui/backends/imgui_impl_metal.h
      deps/ImGui/backends/imgui_impl_metal.mm
    )

    target_include_directories(macos_metal_app
      PRIVATE
      deps/ImGui
      ${CMAKE_CURRENT_SOURCE_DIR}/src/glad2/include
    )

    set_target_properties(macos_metal_app PROPERTIES
      BUNDLE True
      MACOSX_BUNDLE_GUI_IDENTIFIER my.domain.style.identifier.macos_metal_app
      MACOSX_BUNDLE_BUNDLE_NAME macos_metal_app
      MACOSX_BUNDLE_BUNDLE_VERSION "1"
      MACOSX_BUNDLE_SHORT_VERSION_STRING "1"
      MACOSX_BUNDLE_INFO_PLIST ${CMAKE_SOURCE_DIR}/cmake/customtemplate.plist.in
    )

    target_link_libraries(macos_metal_app
      PRIVATE
      dl
    )

    target_compile_definitions(macos_metal_app
      PRIVATE
      ${IMGUI_USER_CONFIG_VALUE}
      IMGUI_IMPL_OPENGL_LOADER_CUSTOM
      IMGUI_IMPL_OPENGL_LOADER_GLAD2
      IMGUI_IMPL_VULKAN_NO_PROTOTYPES
      IMGUI_DISABLE_OBSOLETE_KEYIO
      IMGUI_DISABLE_OBSOLETE_FUNCTIONS
      IMGUI_DISABLE_APPLE_GAMEPAD
    )

  elseif(UNIX)

    add_executable(linux_opengl_app
      tests/linux_opengl/main.cpp
      deps/ImGui/imgui.cpp
      deps/ImGui/imgui_demo.cpp
      deps/ImGui/imgui_draw.cpp
      deps/ImGui/imgui_tables.cpp
      deps/ImGui/imgui_widgets.cpp
      deps/ImGui/backends/imgui_impl_opengl3.cpp
      deps/ImGui/backends/imgui_impl_x11.cpp
    )

    target_include_directories(linux_opengl_app
      PRIVATE
      deps/ImGui
      ${CMAKE_CURRENT_SOURCE_DIR}/src/glad2/include
    )

    target_link_libraries(linux_opengl_app
      PRIVATE
      dl
      GL
      X11
    )

    target_compile_definitions(linux_opengl_app
      PRIVATE
      ${IMGUI_USER_CONFIG_VALUE}
      IMGUI_IMPL_OPENGL_LOADER_CUSTOM
      IMGUI_IMPL_OPENGL_LOADER_GLAD2
      IMGUI_IMPL_VULKAN_NO_PROTOTYPES
      IMGUI_DISABLE_OBSOLETE_KEYIO
      IMGUI_DISABLE_OBSOLETE_FUNCTIONS
      IMGUI_DISABLE_APPLE_GAMEPAD
    )
	
    # Vulkan officially supports only 64 bits apps.
    if (CMAKE_SIZEOF_VOID_P EQUAL 8)
      set(GLFW_BUILD_DOCS OFF)
      set(GLFW_BUILD_WAYLAND OFF)
      add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/tests/common/glfw)

      add_executable(linux_vulkan_app
        tests/linux_vulkan/main.cpp
        tests/common/imgui_impl_vulkan.h
        tests/common/imgui_impl_vulkan.cpp
        deps/ImGui/imgui.cpp
        deps/ImGui/imgui_demo.cpp
        deps/ImGui/imgui_draw.cpp
        deps/ImGui/imgui_tables.cpp
        deps/ImGui/imgui_widgets.cpp
        deps/ImGui/backends/imgui_impl_glfw.h
        deps/ImGui/backends/imgui_impl_glfw.cpp
        deps/ImGui/backends/imgui_impl_x11.h
        deps/ImGui/backends/imgui_impl_x11.cpp
      )

      target_include_directories(linux_vulkan_app
        PRIVATE
        deps/ImGui
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tests/common/glfw/include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tests/common/vulkansdk/include>
      )

      target_link_libraries(linux_vulkan_app
        PRIVATE
        dl
        GL
        X11
        glfw
        ${CMAKE_CURRENT_SOURCE_DIR}/tests/common/vulkansdk/lib/libvulkan.so.1.3.290
      )

      target_compile_definitions(linux_vulkan_app
        PRIVATE
        ${IMGUI_USER_CONFIG_VALUE}
        IMGUI_IMPL_OPENGL_LOADER_CUSTOM
        IMGUI_IMPL_OPENGL_LOADER_GLAD2
        IMGUI_DISABLE_OBSOLETE_KEYIO
        IMGUI_DISABLE_OBSOLETE_FUNCTIONS
        IMGUI_DISABLE_APPLE_GAMEPAD
      )
    endif()

  endif()

  add_library(overlay_example SHARED
    tests/overlay_example/library_main.cpp
  )

  set_target_properties(overlay_example PROPERTIES
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<BOOL:${INGAMEOVERLAY_DYNAMIC_RUNTIME}>:DLL>"
    POSITION_INDEPENDENT_CODE ON
    C_VISIBILITY_PRESET hidden
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN ON
  )

  target_link_options(overlay_example
    PRIVATE
    $<$<AND:$<NOT:$<BOOL:${APPLE}>>,$<BOOL:${UNIX}>>:-Wl,--exclude-libs,ALL>
    $<$<AND:$<NOT:$<BOOL:${APPLE}>>,$<BOOL:${UNIX}>>:-Wl,--no-undefined>
  )

  target_link_libraries(overlay_example
    PRIVATE
    Nemirtingas::InGameOverlay
    Threads::Threads
  )
  
  target_compile_definitions(overlay_example
    PRIVATE
    ${IMGUI_USER_CONFIG_VALUE}
  )

  add_library(test_overlay SHARED
    tests/test_overlay/library_main.cpp
  )

  set_target_properties(test_overlay PROPERTIES
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<BOOL:${INGAMEOVERLAY_DYNAMIC_RUNTIME}>:DLL>"
    POSITION_INDEPENDENT_CODE ON
    C_VISIBILITY_PRESET hidden
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN ON
  )

  target_link_options(test_overlay
    PRIVATE
    $<$<AND:$<NOT:$<BOOL:${APPLE}>>,$<BOOL:${UNIX}>>:-Wl,--exclude-libs,ALL>
    $<$<AND:$<NOT:$<BOOL:${APPLE}>>,$<BOOL:${UNIX}>>:-Wl,--no-undefined>
  )

  target_link_libraries(test_overlay
    PRIVATE
    Nemirtingas::InGameOverlay
    Threads::Threads
  )
  
  target_compile_definitions(test_overlay
    PRIVATE
    ${IMGUI_USER_CONFIG_VALUE}
  )

endif()

##################
## Install rules
install(TARGETS ingame_overlay EXPORT InGameOverlayTargets
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

install(FILES ${INGAMEOVERLAY_HEADERS}
  DESTINATION include/InGameOverlay
)

install(FILES ${INGAMEOVERLAY_IMGUI_HEADERS}
  DESTINATION include/InGameOverlay/ImGui
)

# Export targets
install(
  EXPORT InGameOverlayTargets
  FILE InGameOverlayConfig.cmake
  NAMESPACE Nemirtingas::
  DESTINATION lib/cmake/InGameOverlay
)
