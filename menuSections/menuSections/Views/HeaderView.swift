//
//  HeaderView.swift
//  menuSections
//
//  Created by Abel Sánchez Custodio on 4/3/16.
//  Copyright © 2016 acsanchezcu. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet weak var headerTitle: UILabel!
    
    var view: UIView!

    //MARK: - Init
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        xibSetup()
    }
    
    //MARK: - Private Methods
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "HeaderView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

}
