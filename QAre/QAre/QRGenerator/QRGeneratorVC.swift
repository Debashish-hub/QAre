//
//  QRGeneratorVC.swift
//  QAre
//
//  Created by Debashish on 09/06/24.
//

import UIKit

class QRGeneratorVC: UIViewController, ImageDownloadProtocol {
    func imageDownloaded(error: Error?) {
        print(error)
        if error == nil {
            let ac = UIAlertController(title: "QR Downloaded Successfully", message: "Chcek your Gallery for the downloaded QR", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Downloaded Failed", message: "Please try again later", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        
    }
    
    
    
    @IBOutlet public var imageView: UIImageView?
    @IBOutlet public var addToFavBtn: UIButton?
    @IBOutlet public var downloadBtn: UIButton?
    @IBOutlet public var shareBtn: UIButton?
    
    var qrGeneratorString: String = ""
    var imageSaver: ImageSaver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.imageView?.layer.magnificationFilter = .nearest
        self.imageView?.layer.minificationFilter = .nearest
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.shareImage))
        self.imageView?.addGestureRecognizer(longPress)
        self.imageView?.isUserInteractionEnabled = true
        
        self.refreshQRCode()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        setNavigation()
        setUpUI()
    }
    func setNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: ColorConstants.init().secondartColor)
        self.navigationItem.title = "QR"
    }
    
    func setUpUI() {
        self.view.backgroundColor = UIColor(hexString: ColorConstants.init().primaryColor)
        let downloadImage = UIImage(named: "arrow.down.circle.fill")
        downloadBtn?.setThemedButton(title: "", image: downloadImage)
        downloadBtn?.setCircularBtn()
        let shareImage = UIImage(named: "person.2.circle.fill")
        shareBtn?.setThemedButton(title: "", image: shareImage)
        shareBtn?.setCircularBtn()
        addToFavBtn?.setThemedButton(title: "Add to Favourites", image: nil, isImagerequired: false)
        addToFavBtn?.setCircularBtn()
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
        activityViewController.popoverPresentationController?.sourceView = self.imageView
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // Lots of the share extensions don't seem to handle UIImage's originating from CoreImage images properly
    // Even though it shouldn't be needed, re-rendering it seems to help reliability of some sharing options
    func sharableImage(_ image: UIImage) -> UIImage {
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
        guard let image = self.imageView?.image else {
            return
        }
        imageSaver = ImageSaver(imageDownloadProtocol: self)
        imageSaver?.saveImage(image: sharableImage(image))
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        shareImage()
    }
    
}
