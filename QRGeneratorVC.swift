//
//  QRGeneratorVC.swift
//  QAre
//
//  Created by Debashish on 09/06/24.
//

import UIKit

class QRGeneratorVC: UIViewController {
    
    
    @IBOutlet public var imageView: UIImageView?
    @IBOutlet public var addToFavBtn: UIButton?
    @IBOutlet public var downloadBtn: UIButton?
    @IBOutlet public var shareBtn: UIButton?
    
    var qrGeneratorString: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView?.layer.magnificationFilter = .nearest
        self.imageView?.layer.minificationFilter = .nearest
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.shareImage))
        self.imageView?.addGestureRecognizer(longPress)
        self.imageView?.isUserInteractionEnabled = true
        
        self.refreshQRCode()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Generate QR Code
    
    func refreshQRCode() {
        let text:String = qrGeneratorString
        
        // Generate the image
        guard let qrCode:CIImage = self.createQRCodeForString(text) else {
            print("Failed to generate QRCode")
            self.imageView?.image = nil
            return
        }
        
        // Display
        self.imageView?.image = UIImage(ciImage: qrCode)
    }
    
    func createQRCodeForString(_ text: String) -> CIImage? {
        let data = text.data(using: .isoLatin1)
        //let data = text.data(using: .utf8)
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        // Input text
        qrFilter?.setValue(data, forKey: "inputMessage")
        // Error correction
        let values = ["L", "M", "Q", "H"]
        let correctionLevel = values[2]
        qrFilter?.setValue(correctionLevel, forKey: "inputCorrectionLevel")
        
        return qrFilter?.outputImage
    }
    // MARK: Share Image
    @objc 
    func shareImage() {
        guard let image = self.imageView?.image else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [ self.sharableImage(image) ], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.imageView // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // Lots of the share extensions don't seem to handle UIImage's originating from CoreImage images properly
    // Even though it shouldn't be needed, re-rendering it seems to help reliability of some sharing options
    func sharableImage(_ image: UIImage) -> UIImage
    {
        let sharableWidth: CGFloat = max(image.size.width, 512)
        let renderSize: CGSize = CGSize(width: sharableWidth, height: sharableWidth)
        
        let renderer = UIGraphicsImageRenderer(size: renderSize, format: image.imageRendererFormat)
        let img = renderer.image(actions: { ctx in
            image.draw(in: CGRect(origin: .zero, size: renderSize))
        })
        return img
    }
    
    @IBAction func addToFavTapped(_ sender: Any) {
        
    }
    
    @IBAction func downloadTapped(_ sender: Any) {
        
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        shareImage()
    }
    
}
