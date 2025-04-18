/*
 * Copyright (C) Nemirtingas
 * This file is part of the ingame overlay project
 *
 * The ingame overlay project is free software; you can redistribute it
 * and/or modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 * 
 * The ingame overlay project is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with the ingame overlay project; if not, see
 * <http://www.gnu.org/licenses/>.
 */

#include "OpenGLHook.h"
#include "WindowsHook.h"

#include <imgui.h>
#include <backends/imgui_impl_opengl3.h>

#include <glad/gl.h>

namespace InGameOverlay {

#define TRY_HOOK_FUNCTION_OR_FAIL(NAME) do { if (!HookFunc(std::make_pair<void**, void*>(&(void*&)_##NAME, (void*)&OpenGLHook_t::_My##NAME))) { \
    INGAMEOVERLAY_ERROR("Failed to hook {}", #NAME);\
    UnhookAll();\
    return false;\
} } while(0)

OpenGLHook_t* OpenGLHook_t::_Instance = nullptr;

bool OpenGLHook_t::StartHook(std::function<void()> keyCombinationCallback, ToggleKey toggleKeys[], int toggleKeysCount, /*ImFontAtlas* */ void* imguiFontAtlas)
{
    if (!_Hooked)
    {
        if (_WGLSwapBuffers == nullptr)
        {
            INGAMEOVERLAY_WARN("Failed to hook OpenGL: Rendering functions missing.");
            return false;
        }

        if (!WindowsHook_t::Inst()->StartHook(keyCombinationCallback, toggleKeys, toggleKeysCount))
            return false;

        _WindowsHooked = true;

        BeginHook();
        TRY_HOOK_FUNCTION_OR_FAIL(WGLSwapBuffers);
        EndHook();

        INGAMEOVERLAY_INFO("Hooked OpenGL");
        _Hooked = true;
        _ImGuiFontAtlas = imguiFontAtlas;
    }
    return true;
}

void OpenGLHook_t::HideAppInputs(bool hide)
{
    if (_Initialized)
    {
        WindowsHook_t::Inst()->HideAppInputs(hide);
    }
}

void OpenGLHook_t::HideOverlayInputs(bool hide)
{
    if (_Initialized)
    {
        WindowsHook_t::Inst()->HideOverlayInputs(hide);
    }
}

bool OpenGLHook_t::IsStarted()
{
    return _Hooked;
}

void OpenGLHook_t::_ResetRenderState(OverlayHookState state)
{
    if (_HookState == state)
        return;

    OverlayHookReady(state);

    _HookState = state;

    switch (state)
    {
        case OverlayHookState::Reset:
            break;

        case OverlayHookState::Removing:
            ImGui_ImplOpenGL3_Shutdown();
            WindowsHook_t::Inst()->ResetRenderState(state);
            //ImGui::DestroyContext();

            _ImageResources.clear();

            _LastWindow = nullptr;
            _Initialized = false;
    }
}

// Try to make this function and overlay's proc as short as possible or it might affect game's fps.
void OpenGLHook_t::_PrepareForOverlay(HDC hDC)
{
    HWND hWnd = WindowFromDC(hDC);

    if (hWnd != _LastWindow)
        _ResetRenderState(OverlayHookState::Removing);

    if (!_Initialized)
    {
        if (ImGui::GetCurrentContext() == nullptr)
            ImGui::CreateContext(reinterpret_cast<ImFontAtlas*>(_ImGuiFontAtlas));

        ImGui_ImplOpenGL3_Init();

        _LastWindow = hWnd;

        WindowsHook_t::Inst()->SetInitialWindowSize(hWnd);

        _Initialized = true;
        _ResetRenderState(OverlayHookState::Ready);
    }

    if (ImGui_ImplOpenGL3_NewFrame() && WindowsHook_t::Inst()->PrepareForOverlay(hWnd))
    {
        ImGui::NewFrame();

        OverlayProc();

        _LoadResources();

        ImGui::Render();

        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
    }
}

BOOL WINAPI OpenGLHook_t::_MyWGLSwapBuffers(HDC hDC)
{
    auto inst = OpenGLHook_t::Inst();
    inst->_PrepareForOverlay(hDC);
    return inst->_WGLSwapBuffers(hDC);
}

OpenGLHook_t::OpenGLHook_t():
    _Hooked(false),
    _WindowsHooked(false),
    _Initialized(false),
    _HookState(OverlayHookState::Removing),
    _LastWindow(nullptr),
    _ImGuiFontAtlas(nullptr),
    _WGLSwapBuffers(nullptr)
{
}

OpenGLHook_t::~OpenGLHook_t()
{
    INGAMEOVERLAY_INFO("OpenGL Hook removed");

    if (_WindowsHooked)
        delete WindowsHook_t::Inst();

    _ResetRenderState(OverlayHookState::Removing);

    _Instance->UnhookAll();
    _Instance = nullptr;
}

OpenGLHook_t* OpenGLHook_t::Inst()
{
    if (_Instance == nullptr)
        _Instance = new OpenGLHook_t;

    return _Instance;
}

const char* OpenGLHook_t::GetLibraryName() const
{
    return LibraryName.c_str();
}

RendererHookType_t OpenGLHook_t::GetRendererHookType() const
{
    return RendererHookType_t::OpenGL;
}

void OpenGLHook_t::LoadFunctions(WGLSwapBuffers_t pfnwglSwapBuffers)
{
    _WGLSwapBuffers = pfnwglSwapBuffers;
}

std::weak_ptr<uint64_t> OpenGLHook_t::CreateImageResource(const void* image_data, uint32_t width, uint32_t height)
{
    GLuint* texture = new GLuint(0);
    glGenTextures(1, texture);
    if (glGetError() != GL_NO_ERROR)
    {
        delete texture;
        return std::shared_ptr<uint64_t>(nullptr);
    }
    
    // Save old texture id
    GLint oldTex;
    glGetIntegerv(GL_TEXTURE_BINDING_2D, &oldTex);

    glBindTexture(GL_TEXTURE_2D, *texture);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    // Upload pixels into texture
    glPixelStorei(GL_UNPACK_ROW_LENGTH, 0);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_data);

    glBindTexture(GL_TEXTURE_2D, oldTex);

    auto ptr = std::shared_ptr<uint64_t>((uint64_t*)texture, [](uint64_t* handle)
    {
        if (handle != nullptr)
        {
            GLuint* texture = (GLuint*)handle;
            glDeleteTextures(1, texture);
            delete texture;
        }
    });

    _ImageResources.emplace(ptr);
    return ptr;
}

void OpenGLHook_t::ReleaseImageResource(std::weak_ptr<uint64_t> resource)
{
    auto ptr = resource.lock();
    if (ptr)
    {
        auto it = _ImageResources.find(ptr);
        if (it != _ImageResources.end())
            _ImageResources.erase(it);
    }
}

}// namespace InGameOverlay