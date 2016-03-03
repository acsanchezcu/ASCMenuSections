//
//  ASCMenuSection.swift
//  menuSections
//
//  Created by Abel Sánchez Custodio on 3/3/16.
//  Copyright © 2016 acsanchezcu. All rights reserved.
//

import UIKit


protocol ASCMenuSectionDelegate {
    func getSections (menuSection : ASCMenuSection) -> Array<UIView>
    func sectionHeight (menuSection : ASCMenuSection) -> Float
    
//    func menuSection(menuSection: ASCMenuSection, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
}


class ASCMenuSection: UIView {

    //MARK: - Properties
    
    let scrollView : UIScrollView = UIScrollView.init()
    
    var sectionHeight : Float {
        get {
            return (delegate?.sectionHeight(self))!
        }
    }
    
    var delegate : ASCMenuSectionDelegate?
    
    var subsectionsContainers : Array<UIView> = []

    //MARK: - Init
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    init (delegate : ASCMenuSectionDelegate) {
        super.init(frame:CGRect.zero)
        
        self.delegate = delegate
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
    }
    
    override func didMoveToSuperview() {
        initialize()
    }
    
    //MARK: - Private Methods
    
    func initialize() {
        
        scrollView.bounces = true
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        addSubview(scrollView)
        
        UIView.embedView(scrollView)
        
        if let array = delegate?.getSections(self) {
            
            addSectionConstraints(array)
        }
    }
    
    func addSectionConstraints(array: Array<UIView>) {
        
        var views : Dictionary<String, UIView> = [:]
        
        var heightVisualFormat = "V:|"
        
        var widthConstraints : Array<NSLayoutConstraint> = []
        
        for (index, view) in array.enumerate() {
            
            addButtonToHeader(view, index: index)
            
            let subsectionContainerView = createSubsectionContainer()
            
            views["view\(index)"] = view
            views["subsectionContainerView\(index)"] = subsectionContainerView
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            scrollView.addSubview(view)
            
            heightVisualFormat += "[view\(index)(height)][subsectionContainerView\(index)]"
            
            let widthConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view(width)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["width": superview!.frame.width], views: ["view": view])
            
            widthConstraints += widthConstraint
        }
        
        heightVisualFormat += "|"
        
        let heightConstraints = NSLayoutConstraint.constraintsWithVisualFormat(heightVisualFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: ["height": sectionHeight], views: views)
        
        scrollView.addConstraints(widthConstraints)
        scrollView.addConstraints(heightConstraints)
    }

    func createSubsectionContainer() -> UIView {
        let view : UIView = UIView.init()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor.orangeColor()
        
        scrollView.addSubview(view)
        
        subsectionsContainers.append(view)
        
        let widthConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view(width)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["width": superview!.frame.width], views: ["view": view])
        let heightConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[view(0)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view])
        
        scrollView.addConstraints(widthConstraints)
        view.addConstraints(heightConstraints)
        
        return view
    }
    
    func addButtonToHeader(view: UIView, index: Int) {
        let button = UIButton.init()
        
        button.tag = index
        
        view.addSubview(button)
        
        UIView.embedView(button)
        
        button.addTarget(self, action: "userDidTapHeaderButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func userDidTapHeaderButton(sender:UIButton!)
    {
        let index = sender.tag
        
        let view : UIView = subsectionsContainers[index]
        
        for constraint in view.constraints {
            constraint.constant = (constraint.constant == 0.0) ? 60.0 : 0.0
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.layoutIfNeeded()
            })
        }
    }
}
