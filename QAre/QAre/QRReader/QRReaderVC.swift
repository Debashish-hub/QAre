//
//  QRReaderVC.swift
//  QAre
//
//  Created by Debashish on 08/06/24.
//

import UIKit
import AVFoundation

class QRReaderVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet public var cameraView: UIView?
    @IBOutlet public var cameraViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet public var scanButton: UIButton?
    @IBOutlet public var outputTextView: UITextView?
    @IBOutlet weak var torchBtn: UIButton?
    @IBOutlet weak var galleryBtn: UIButton?
    @IBOutlet weak var scannedDataLbl: UILabel?
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var imagePicker = UIImagePickerController()
    var qrCodeBounds:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    var isScanned: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        scannedDataLbl?.isHidden = false
        // Setup camera capture
        self.captureSession = AVCaptureSession()
        // Get the default camera
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (self.captureSession.canAddInput(videoInput)) {
            self.captureSession.addInput(videoInput)
        } else {
            self.failed()
            return
        }
        
        // camera is setup add a metadata output
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (self.captureSession.canAddOutput(metadataOutput)) {
            self.captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            self.failed()
            return
        }
        
        // Setup the UI to show the camera
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame = self.view.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        self.cameraView?.layer.addSublayer(self.previewLayer)
        
        self.qrCodeBounds.alpha = 0
        self.cameraView?.addSubview(self.qrCodeBounds)
        
        DispatchQueue.global(qos: .background).async(execute: {
            self.captureSession.startRunning()
        })
        
    }
    func setUI() {
        outputTextView?.layer.cornerRadius = CGFloat(15)
        outputTextView?.backgroundColor = UIColor(hexString: ColorConstants.init().secondartColor)
        outputTextView?.delegate = self
        outputTextView?.textColor = UIColor(hexString: ColorConstants.init().primaryColor)
        scannedDataLbl?.textColor = UIColor(hexString: ColorConstants.init().primaryColor)
        scanButton?.setThemedButton(title: "Scan", image: nil)
        var flashImage = UIImage(named: "flashlight.on.fill")
        flashImage = flashImage?.withTintColor(UIColor(hexString: ColorConstants.init().primaryColor))
        torchBtn?.setThemedButton(title: "", image: flashImage, isImagerequired: true)
        torchBtn?.setCircularBtn()
        galleryBtn?.setThemedButton(title: "", image: UIImage(named: "photo.stack.fill"), isImagerequired: true)
        galleryBtn?.setCircularBtn()
        self.view.backgroundColor = UIColor(hexString: ColorConstants.init().primaryColor)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text.count > 0 {
            UIPasteboard.general.string = textView.text
        
            let alertMessagePopUpBox = UIAlertController(title: "", message: "Copied Successfully", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alertMessagePopUpBox.addAction(okButton)
            self.present(alertMessagePopUpBox, animated: true)
            setUI()
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("CANCELLED")
        isScanned = false
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        print("didFinishPickingMediaWithInfo")
        if let qrcodeImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
                let ciImage:CIImage=CIImage(image:qrcodeImg)!
                var qrCodeLink=""
      
                let features=detector.features(in: ciImage)
                for feature in features as! [CIQRCodeFeature] {
                    qrCodeLink += feature.messageString!
                }
                
                if qrCodeLink=="" {
                    print("nothing")
                    isScanned = false
                    scannedDataLbl?.isHidden = false
                }else{
                    print("message: \(qrCodeLink)")
                    isScanned = true
                    scannedDataLbl?.isHidden = true
                    self.outputTextView?.text = qrCodeLink
                }
            }
            else{
                isScanned = false
                scannedDataLbl?.isHidden = false
                print("Something went wrong")
            }
            self.dismiss(animated: true, completion: nil)
          }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning failed", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(ac, animated: true)
        
        self.captureSession = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.previewLayer?.frame = self.cameraView?.layer.bounds ?? CGRect()
        
        // Fix orientation
        if let connection = self.previewLayer?.connection {
            let orientation = self.view.window?.windowScene?.interfaceOrientation ?? UIInterfaceOrientation.portrait
            let previewLayerConnection : AVCaptureConnection = connection

            if (previewLayerConnection.isVideoOrientationSupported) {
                switch (orientation) {
                    case .landscapeRight:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                    case .landscapeLeft:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                    case .portraitUpsideDown:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
                    default:
                        previewLayerConnection.videoOrientation = AVCaptureVideoOrientation.portrait
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
        setUI()
        if (self.captureSession?.isRunning == false) {
            self.captureSession?.startRunning()
        }
    }
    
    func setNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: ColorConstants.init().secondartColor)
        
        self.navigationItem.title = "Scan QR"
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (self.captureSession?.isRunning == true) {
            self.captureSession?.stopRunning()
        }
    }
    
    @IBAction func torchTapped(_ sender: Any) {
        toggleFlash()
    }
    func toggleFlash() {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if (device?.hasTorch ?? false) {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    do {
                        try device?.setTorchModeOn(level: 1.0)
                    } catch {
                        print(error)
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func galleryTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func scanPressed(_ sender: Any) {
        if (self.captureSession?.isRunning == true) {
            self.captureSession?.stopRunning()
//            self.cameraViewHeightConstraint?.priority = UILayoutPriority(500)
        }
        else {
            outputTextView?.text = ""
            scannedDataLbl?.isHidden = false
            self.captureSession?.startRunning()
//            self.cameraViewHeightConstraint?.priority = UILayoutPriority(1000)
        }
        setUI()
        
//        UIView.animate(withDuration: 0.2, animations: {
//            self.view.layoutIfNeeded()
//        })
    }
    
    func showQRCodeBounds(frame: CGRect?) {
        guard let frame = frame else { return }
        
        self.qrCodeBounds.layer.removeAllAnimations() // resets any previous animations and cancels the fade out
        self.qrCodeBounds.alpha = 1
        self.qrCodeBounds.frame = frame
        
        UIView.animate(withDuration: 0.2, delay: 1, options: [], animations: { // after 1 second fade away
            self.qrCodeBounds.alpha = 0
        })
    }
    
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // Get text value
            if stringValue != outputTextView?.text {
                print("QR Code: \(stringValue)")
                self.isScanned = true
                scannedDataLbl?.isHidden = true
                self.outputTextView?.text = stringValue
            }
            
            // Show bounds
            let qrCodeObject: AVMetadataObject? = self.previewLayer.transformedMetadataObject(for: readableObject)
            self.showQRCodeBounds(frame: qrCodeObject?.bounds)
            self.captureSession.stopRunning()
        }
    }
    
    
    
    
    // MARK: - Detect QR Code From Static Image
    // https://stackoverflow.com/a/49275021/458205
    
    /// Detect a QR Code in a static image
    /// - Parameter image: The image to scan for QR codes
    /// - Returns: The found QR code details
    func detectQRCode(_ image: UIImage?) -> [CIFeature]?
    {
        if let image = image, let ciImage = CIImage.init(image: image)
        {
            var options: [String: Any]
            
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String))
            {
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            }
            else {
                options = [CIDetectorImageOrientation: 1]
            }
            
            let features = qrDetector?.features(in: ciImage, options: options)
            return features
        }
        
        return nil
    }

}
