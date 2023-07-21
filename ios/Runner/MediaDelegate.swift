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
    func registerImage(args: Dictionary<String, Any?>, result: @escaping FlutterResult) {
        guard let fileUrl = URL(string: args["filePath"] as? String ?? "") else {
            result(FlutterError(code: "PHOTOS_ADD_IMAGE_FAILED", message: "The file path is required.", details: nil))
            
            return
        }
        
        PHPhotoLibrary.shared().performChanges {
            // Request creating an asset from the image.
            let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileUrl)
        } completionHandler: { success, error in
            if !success, let error = error {
                result(FlutterError(code: "PHOTOS_ADD_IMAGE_FAILED", message: error.localizedDescription, details: nil))
            } else {
                result(nil)
            }
        }
    }
    
    /// Request permission to use the camera.
    func requestCameraPermission(result: @escaping FlutterResult) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch(cameraAuthorizationStatus) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                result(granted)
            }
        case .authorized:
            result(true)
        case .denied, .restricted:
            result(false)
        }
    }
    
    /// Request permission to add photos to the Photo library.
    func requestAddToPhotoLibraryPermission(result: @escaping FlutterResult) {
        if #available(iOS 14.0, *) {
            let photosAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            
            switch(photosAuthorizationStatus) {
            case .authorized:
                result(true)
            case .denied, .limited, .restricted:
                result(false)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
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
        } else {
            result(true)
        }
    }
}
