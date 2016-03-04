//
//  ASCMenuSection.swift
//  menuSections
//
//  Created by Abel Sánchez Custodio on 3/3/16.
//  Copyright © 2016 acsanchezcu. All rights reserved.
//

import UIKit


protocol ASCMenuSectionDelegate {
    func menuSection(menuSection: ASCMenuSection, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    func menuSection(menuSection: ASCMenuSection, heightForHeaderInSection section: Int) -> CGFloat
    func menuSection(menuSection: ASCMenuSection, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

protocol ASCMenuSectionDatasource {
    func menuSection(menuSection: ASCMenuSection, viewForHeaderInSection section: Int) -> UIView
    func menuSection(menuSection: ASCMenuSection, numberOfRowsInSection section: Int) -> Int
    func menuSection(menuSection: ASCMenuSection, viewForRowAtIndexPath indexPath: NSIndexPath) -> UIView
    func numberOfSectionsInMenuSection() -> Int
}


class ASCMenuSection: UIView {

    //MARK: - Properties
    
    let scrollView : UIScrollView = UIScrollView.init()
    
    var delegate : ASCMenuSectionDelegate?
    var datasource : ASCMenuSectionDatasource?
    
    var subsectionsContainers : Array<UIView> = []

    //MARK: - Init
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    init (delegate: ASCMenuSectionDelegate, datasource: ASCMenuSectionDatasource) {
        super.init(frame:CGRect.zero)
        
        self.delegate = delegate
        self.datasource = datasource
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

        addSectionConstraints()
    }
    
    func addButtonToHeader(view: UIView, index: Int) {
        let button = UIButton.init()
        
        button.tag = index
        
        view.addSubview(button)
        
        UIView.embedView(button)
        
        button.addTarget(self, action: "userDidTapHeaderButton:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addSectionConstraints() {
        
        var views : Dictionary<String, UIView> = [:]
        
        var heightVisualFormat = "V:|"
        
        var widthConstraints : Array<NSLayoutConstraint> = []
        
        if let sections = datasource?.numberOfSectionsInMenuSection() {
            
            for index in 0...sections {
                
                if let view = datasource?.menuSection(self, viewForHeaderInSection: index) {
                    addButtonToHeader(view, index: index)
                    
                    let subsectionContainerView = createSubsectionContainer(index)
                    
                    views["view\(index)"] = view
                    views["subsectionContainerView\(index)"] = subsectionContainerView
                    
                    view.translatesAutoresizingMaskIntoConstraints = false
                    
                    scrollView.addSubview(view)
                    
                    heightVisualFormat += "[view\(index)(height)][subsectionContainerView\(index)]"
                    
                    let widthConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view(width)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["width": superview!.frame.width], views: ["view": view])
                    
                    widthConstraints += widthConstraint
                    
                    var hMetrics : Dictionary<String, CGFloat> = ["height": 44]
                    
                    if let height = delegate?.menuSection(self, heightForHeaderInSection: index) {
                        hMetrics["height"] = height
                    }
                
                    scrollView.addConstraints(widthConstraints)
                }
            }
            
            heightVisualFormat += "|"
            
            let heightConstraints = NSLayoutConstraint.constraintsWithVisualFormat(heightVisualFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: ["height": 44], views: views)
            
            scrollView.addConstraints(heightConstraints)
        }
    }

    func createSubsectionContainer(section: Int) -> UIView {

        let subsectionContainerView = UIView.init()
        
        subsectionContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(subsectionContainerView)
        
        subsectionsContainers.append(subsectionContainerView)
        
        var views : Dictionary<String, UIView> = [:]
        var metrics : Dictionary<String, CGFloat> = [:]
        
        var heightVisualFormat = "V:|"
        
        var widthConstraints : Array<NSLayoutConstraint> = []
        
        if let rows = datasource?.menuSection(self, numberOfRowsInSection: section) {
            
            for row in 0...rows {
                
                if let view = datasource?.menuSection(self, viewForRowAtIndexPath: NSIndexPath.init(forRow: row, inSection: section)) {
//                    addButtonToHeader(view, index: index)
                    
                    views["view\(row)"] = view
                    metrics["height\(row)"] = delegate?.menuSection(self, heightForRowAtIndexPath: NSIndexPath.init(forRow: row, inSection: section))
                    
                    view.translatesAutoresizingMaskIntoConstraints = false
                    
                    subsectionContainerView.addSubview(view)
                    
                    heightVisualFormat += "[view\(row)(height\(row))]"
                    
                    let widthConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view(width)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["width": superview!.frame.width], views: ["view": view])
                    
                    widthConstraints += widthConstraint
                
                    subsectionContainerView.addConstraints(widthConstraints)
                }
            }
            
            heightVisualFormat += "|"
            
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(heightVisualFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
            
            subsectionContainerView.addConstraints(verticalConstraints)
        }
        
        subsectionContainerView.clipsToBounds = true
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subsectionContainerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subsectionContainerView": subsectionContainerView])
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[subsectionContainerView(0)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subsectionContainerView": subsectionContainerView])
        
        scrollView.addConstraints(horizontalConstraints)
        
        subsectionContainerView.addConstraints(verticalConstraints)
        
        return subsectionContainerView
    }
    
    func userDidTapHeaderButton(sender:UIButton!)
    {
        let section = sender.tag
        
        let view : UIView = subsectionsContainers[section]
        
        var totalHeight : CGFloat = 0.0
        
        if let rows = datasource?.menuSection(self, numberOfRowsInSection: section) {
            for row in 0...rows {
                
                if let height = delegate?.menuSection(self, heightForRowAtIndexPath: NSIndexPath.init(forRow: row, inSection: section)) {
                    totalHeight += height
                }
            }
        }
        
        for constraint in view.constraints {
            
            if constraint.firstItem === view && constraint.firstAttribute == .Height {
                constraint.constant = (constraint.constant == 0.0) ? totalHeight : 0.0
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.layoutIfNeeded()
                })
            }
        }
    }
}
