//
//  ViewController.swift
//  menuSections
//
//  Created by Abel Sánchez Custodio on 3/3/16.
//  Copyright © 2016 acsanchezcu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ASCMenuSectionDelegate, ASCMenuSectionDatasource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let menuSection : ASCMenuSection = ASCMenuSection.init(delegate: self, datasource: self)
        
        view.addSubview(menuSection)
        
        UIView.embedView(menuSection)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - DELEGATES
    
    //MARK: - ASCMenuSectionDelegate
    
    func menuSection(menuSection: ASCMenuSection, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    func menuSection(menuSection: ASCMenuSection, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func menuSection(menuSection: ASCMenuSection, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint("Selected")
    }

    //MARK: - ASCMenuSectionDatasource

    func menuSection(menuSection: ASCMenuSection, viewForHeaderInSection section: Int) -> UIView {
        let view = UIView.init()
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        let label = UILabel.init()
        
        label.text = "HEADER \(section)"
        label.textAlignment = .Center
        
        view.addSubview(label)
        
        UIView.embedView(label)
        
        return view
    }
    
    func menuSection(menuSection: ASCMenuSection, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func menuSection(menuSection: ASCMenuSection, viewForRowAtIndexPath indexPath: NSIndexPath) -> UIView {
        let view = UIView.init()
        
        view.backgroundColor = UIColor.yellowColor()
        
        return view
    }
    
    func numberOfSectionsInMenuSection() -> Int {
        return 10
    }
}

