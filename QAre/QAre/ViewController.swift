//
//  ViewController.swift
//  QAre
//
//  Created by Debashish on 06/06/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var readQrBtn: UIButton!
    
    @IBOutlet weak var generateQRBtn: UIButton!
    
//    @IBOutlet weak var homeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func qRReaderTapped(_ sender: Any) {
        let vc = QRReaderVC(nibName: "QRReaderVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func generateQrTapped(_ sender: Any) {
        let vc = GenerateHomeVC(nibName: "GenerateHomeVC", bundle: nil)
//        vc.qrGeneratorString = "Debashish Sahoo"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func homeBtnTapped(_ sender: Any) {
        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
