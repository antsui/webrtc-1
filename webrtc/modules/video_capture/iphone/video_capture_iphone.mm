/*
 *  Copyright (c) 2011 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

/*
 *  video_capture_iphone.cc
 *
 */

// super class stuff
#include "../video_capture_impl.h"
#include "../device_info_impl.h"
#include "../video_capture_config.h"
#include "webrtc/system_wrappers/interface/ref_count.h"

#include "webrtc/system_wrappers/interface/trace.h"

#include "AVFoundation/video_capture_avfoundation.h"
#include "AVFoundation/video_capture_avfoundation_info.h"

namespace webrtc
{
namespace videocapturemodule
{

// static
bool CheckOSVersion()
{
    return true;
}

/**************************************************************************
 *
 *    Create/Destroy a VideoCaptureModule
 *
 ***************************************************************************/

/*
 *   Returns version of the module and its components
 *
 *   version                 - buffer to which the version will be written
 *   remainingBufferInBytes  - remaining number of WebRtc_Word8 in the version
 *                             buffer
 *   position                - position of the next empty WebRtc_Word8 in the
 *                             version buffer
 */

VideoCaptureModule* VideoCaptureImpl::Create(
    const int32_t _id_, const char* deviceUniqueIdUTF8)
{
    WEBRTC_TRACE(webrtc::kTraceModuleCall, webrtc::kTraceVideoCapture, _id_,
                 "Create %s", deviceUniqueIdUTF8);

    if (CheckOSVersion() == false)
    {
        WEBRTC_TRACE(webrtc::kTraceError, webrtc::kTraceVideoCapture, _id_,
                     "OS version is too old. Could not create video capture "
                     "module. Returning NULL");
        return NULL;
    }

    WEBRTC_TRACE(webrtc::kTraceInfo, webrtc::kTraceVideoCapture, _id_,
                 "Using AVFoundation framework to capture video", _id_);

    RefCountImpl<webrtc::videocapturemodule::VideoCaptureIPhoneAVFoundation>* newCaptureModule =
        new RefCountImpl<webrtc::videocapturemodule::VideoCaptureIPhoneAVFoundation>(_id_);
    if(!newCaptureModule)
    {
        WEBRTC_TRACE(webrtc::kTraceDebug, webrtc::kTraceVideoCapture, _id_,
                     "could not Create for unique device %s, !newCaptureModule",
                     deviceUniqueIdUTF8);
        newCaptureModule = NULL;
    }
    if(newCaptureModule->Init(_id_, deviceUniqueIdUTF8) != 0)
    {
        WEBRTC_TRACE(webrtc::kTraceDebug, webrtc::kTraceVideoCapture, _id_,
                     "could not Create for unique device %s, "
                     "newCaptureModule->Init()!=0", deviceUniqueIdUTF8);
        delete newCaptureModule;
        newCaptureModule = NULL;
    }

    // Successfully created VideoCaptureIPhoneAVFoundation. Return it
    WEBRTC_TRACE(webrtc::kTraceInfo, webrtc::kTraceVideoCapture, _id_,
                 "Module created for unique device %s, will use AVFoundation "
                 "framework",deviceUniqueIdUTF8);
    return newCaptureModule;
}

/**************************************************************************
 *
 *    Create/Destroy a DeviceInfo
 *
 ***************************************************************************/

VideoCaptureModule::DeviceInfo*
VideoCaptureImpl::CreateDeviceInfo(const int32_t _id_)
{

    WEBRTC_TRACE(webrtc::kTraceModuleCall, webrtc::kTraceVideoCapture, _id_,
                 "Create %d", _id_);

    if (CheckOSVersion() == false)
    {
        WEBRTC_TRACE(webrtc::kTraceError, webrtc::kTraceVideoCapture, _id_,
                     "OS version is too old. Could not create video capture "
                     "module. Returning NULL");
        return NULL;
    }

    webrtc::videocapturemodule::VideoCaptureIPhoneAVFoundationInfo* newCaptureInfoModule =
        new webrtc::videocapturemodule::VideoCaptureIPhoneAVFoundationInfo(_id_);

    if(!newCaptureInfoModule || newCaptureInfoModule->Init() != 0)
    {
        //Destroy(newCaptureInfoModule);
        delete newCaptureInfoModule;
        newCaptureInfoModule = NULL;
        WEBRTC_TRACE(webrtc::kTraceInfo, webrtc::kTraceVideoCapture, _id_,
                     "Failed to Init newCaptureInfoModule created with id %d "
                     "and device \"\" ", _id_);
        return NULL;
    }
    WEBRTC_TRACE(webrtc::kTraceInfo, webrtc::kTraceVideoCapture, _id_,
                 "VideoCaptureModule created for id", _id_);
    return newCaptureInfoModule;
}
  
/**************************************************************************
 *
 *    End Create/Destroy VideoCaptureModule
 *
 ***************************************************************************/
}  // namespace videocapturemodule
}  // namespace webrtc
