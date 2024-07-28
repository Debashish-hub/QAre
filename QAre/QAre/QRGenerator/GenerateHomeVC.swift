//
//  GenerateHomeVC.swift
//  QAre
//
//  Created by Debashish on 16/06/24.
//

import UIKit

open class GenerateHomeVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet public var inputLable: UILabel?
    @IBOutlet public var inputTextfield: UITextField?
    @IBOutlet public var generateQRBtn: UIButton?
    var generateQRText: String = ""
    override open func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setUI()
    }

    open override func viewWillAppear(_ animated: Bool) {
        setNavigation()
        setUI()
    }
    func setUI() {
        inputLable?.text = "Input For QR"
        inputTextfield?.placeholder = "Ex: Your Name"
        inputTextfield?.backgroundColor = UIColor(hexString: ColorConstants.init().secondartColor)
        inputTextfield?.textColor = UIColor(hexString: ColorConstants.init().primaryColor)
        inputTextfield?.delegate = self
        generateQRBtn?.setThemedButton(title: "Generate QR", image: nil)
        generateQRBtn?.setCircularBtn()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        generateQRText = textField.text ?? ""
        print(generateQRText)
    }
    
    @IBAction func generateQR(_ sender: Any) {
        let vc = QRGeneratorVC(nibName: "QRGeneratorVC", bundle: nil)
        vc.qrGeneratorString = generateQRText
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func setNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: ColorConstants.init().secondartColor)
        self.navigationItem.title = "Generate QR"
        self.view.backgroundColor = UIColor(hexString: ColorConstants.init().primaryColor)
    }

}
