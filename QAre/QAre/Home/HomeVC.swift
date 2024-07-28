//
//  HomeVC.swift
//  QAre
//
//  Created by Debashish on 16/06/24.
//

import UIKit

class HomeVC: UIViewController, UITabBarDelegate, UITabBarControllerDelegate {
    
    @IBOutlet public var tabBar: TabBarWithCenterButton?
    @IBOutlet public var container: UIView?
    public var tabVC: UITabBarController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
//        setNavigation()
        tabVC = UITabBarController()
        let tabBarList = [getHomeVC(), getReadQrVC(), getHomeVC()]
        tabVC?.viewControllers = tabBarList
        tabVC?.tabBar.isHidden = true
        
        if let targetVC = self.tabVC {
            self.addChild(targetVC)
            self.container?.addSubview(targetVC.view)
            targetVC.view.bindFrameToSuperviewBounds()
            targetVC.didMove(toParent: self)
        }
        
        setTabBar()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
//        setNavigation()
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func setNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: ColorConstants.init().secondartColor)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: ColorConstants.init().primaryColor)
        self.navigationItem.title = "QR"
    }
    func getHomeVC() -> GenerateHomeVC {
        let qrVC = GenerateHomeVC(nibName: "GenerateHomeVC", bundle: nil)
        qrVC.tabBarItem.title = "Home"
        return qrVC
    }
    func getReadQrVC() -> QRReaderVC {
        let qrVC = QRReaderVC(nibName: "QRReaderVC", bundle: nil)
        qrVC.tabBarItem.title = "QR"
        return qrVC
    }
    func setTabBar() {
        let homeUnselectedImage = UIImage(named: "tab_home_unselected")
        let homeSelectedImage = UIImage(named: "tab_home_selected")?.withTintColor(UIColor(hexString: ColorConstants.init().primaryColor))
        let homeTab = UITabBarItem(title: "Generate", image: homeUnselectedImage, selectedImage: homeSelectedImage)
        
        let readQRUnselectedImage = UIImage(named: "tab_qr_unselected")
        let readQRSelectedImage = UIImage(named: "tab_qr_selected")?.withTintColor(UIColor(hexString: ColorConstants.init().primaryColor))
        let qrTab = UITabBarItem(title: "Scan", image: readQRUnselectedImage, selectedImage: readQRSelectedImage)
        
        let favUnselectedImage = UIImage(named: "star_fill")
        let favSelectedImage = UIImage(named: "star_fill")?.withTintColor(UIColor(hexString: ColorConstants.init().primaryColor))
        let favTab = UITabBarItem(title: "Favorites", image: favUnselectedImage, selectedImage: favSelectedImage)
        tabBar?.setItems([homeTab, qrTab, favTab], animated: true)
        tabBar?.updateTheme()
        tabBar?.selectedItem = homeTab
        tabBar?.delegate = self
        self.tabBar?.centerButtonActionHandler = {
            print("Tapped")
        }
    }
    
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title)
        switch item.title {
        case "Generate":
            self.tabVC?.selectedIndex = 0
        case "Scan":
            self.tabVC?.selectedIndex = 1
        case "Favorites":
            self.tabVC?.selectedIndex = 2
        default:
            self.tabVC?.selectedIndex = 0
        }
        
        var targetVC: UIViewController?
        
        switch self.tabVC?.selectedIndex {
        case 0:
            targetVC = (self.tabVC?.viewControllers?[0] as? GenerateHomeVC)
        case 1:
            targetVC = (self.tabVC?.viewControllers?[1] as? QRReaderVC)
        case 2:
            targetVC = (self.tabVC?.viewControllers?[2] as? GenerateHomeVC)
        default:
            targetVC = (self.tabVC?.viewControllers?[0] as? GenerateHomeVC)
        }
        
        navigationController?.navigationBar.topItem?.title = targetVC?.navigationItem.title
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: ColorConstants.init().secondartColor)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: ColorConstants.init().primaryColor)
    }

}


public extension UITabBar {
    /// To set tint color
    func updateTheme() {
        self.tintColor = UIColor(hexString: ColorConstants.init().primaryColor)
        self.unselectedItemTintColor = UIColor(hexString: ColorConstants.init().secondartColor)
    }
}

public extension UIView {
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
        
    }
}
