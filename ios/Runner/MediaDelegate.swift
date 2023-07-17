//
//  MediaDelegate.swift
//  Runner
//
//  Created by Navaron Bracke on 17/07/2023.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import AVFoundation
import Foundation
import Photos

class MediaDelegate : NSObject {
    /// Request permission to access the Photo library.
    func requestPhotosLibraryPermission(result: @escaping FlutterResult) {
        let photosAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch(photosAuthorizationStatus) {
        case .authorized:
            result(true)
        case .denied, .limited, .restricted:
            result(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch(status) {
                case .authorized:
                    result(true)
                case .denied, .limited, .restricted:
                    result(false)
                case .notDetermined:
                    result(nil)
                }
            }
        }
    }
    
    /// Request permission to use the camera.
    func requestCameraPermission(result: @escaping FlutterResult) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch(cameraAuthorizationStatus) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { let granted
                result(granted)
            }
        case .authorized:
            result(true)
        case .denied .restricted:
            result(false)
        }
    }
}
