//
//  ImageSaver.swift
//  QAre
//
//  Created by Debashish on 16/06/24.
//

import Foundation
import CoreImage.CIFilterBuiltins
import SwiftUI
import Combine

public protocol ImageDownloadProtocol: AnyObject {
    func imageDownloaded(error: Error?)
}

class ImageSaver: NSObject {
    var imageDownloadProtocol: ImageDownloadProtocol?
    
    init(imageDownloadProtocol: ImageDownloadProtocol) {
        self.imageDownloadProtocol = imageDownloadProtocol
    }
    
    func saveImage(image : UIImage) {
        self.writeToPhotoAlbum(image: image)
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc 
    func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        imageDownloadProtocol?.imageDownloaded(error: error)
        print("Save finished!")
    }
}
