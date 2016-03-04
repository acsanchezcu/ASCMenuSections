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
        return 44.0
    }
    
    func menuSection(menuSection: ASCMenuSection, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint("Header \(indexPath.section) cell \(indexPath.row)")
    }

    //MARK: - ASCMenuSectionDatasource

    func menuSection(menuSection: ASCMenuSection, viewForHeaderInSection section: Int) -> UIView {
        let headerView = HeaderView.init()
        
        headerView.headerTitle.text = "Header \(section)"
        
        return headerView
    }
    
    func menuSection(menuSection: ASCMenuSection, numberOfRowsInSection section: Int) -> Int {
        return Int(arc4random_uniform(11) + 1)
    }
    
    func menuSection(menuSection: ASCMenuSection, viewForRowAtIndexPath indexPath: NSIndexPath) -> UIView {
        let view = CellView.init()
        
        view.cellLabel.text = "CELL section(\(indexPath.section)) row(\(indexPath.row))"
        
        return view
    }
    
    func numberOfSectionsInMenuSection() -> Int {
        return Int(arc4random_uniform(11) + 2)
    }
}

