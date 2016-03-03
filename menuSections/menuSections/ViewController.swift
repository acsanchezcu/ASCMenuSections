//
//  ViewController.swift
//  menuSections
//
//  Created by Abel Sánchez Custodio on 3/3/16.
//  Copyright © 2016 acsanchezcu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ASCMenuSectionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let menuSection : ASCMenuSection = ASCMenuSection.init(delegate: self)
        
        view.addSubview(menuSection)
        
        UIView.embedView(menuSection)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - DELEGATES
    
    //MARK: - ASCMenuSectionDelegate
    
    func getSections(menuSection: ASCMenuSection) -> Array<UIView> {
        
        let aView = UIView.init()
        
        aView.backgroundColor = UIColor.yellowColor()
        
        let bView = UIView.init()
        
        bView.backgroundColor = UIColor.greenColor()
        
        let cView = UIView.init()
        
        cView.backgroundColor = UIColor.blueColor()
        
        let array : Array = [aView, bView, cView]
        
        return array
    }
    
    func sectionHeight(menuSection: ASCMenuSection) -> Float {
        return 100.0
    }
}

