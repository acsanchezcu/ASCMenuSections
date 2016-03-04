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
    var dVerticalConstraints : Dictionary<String, Array<NSLayoutConstraint>> = [:]

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
    
    //MARK: - Actions
    
    func userDidTapHeaderButton(sender:UIButton!)
    {
        let section = sender.tag
        
        UIView.animateWithDuration(0.3) { () -> Void in
            if let constraints = self.dVerticalConstraints["subsectionContainerView\(section)"] {
                for constraint in constraints {
                    constraint.active = !constraint.active
                }
            }
            
            self.layoutIfNeeded()
        }
    }
    
    func userDidTapCellButton(sender:UIButton!)
    {
        let superview = sender.superview
        
        delegate?.menuSection(self, didSelectRowAtIndexPath: NSIndexPath.init(forRow: (superview?.tag)!, inSection: sender.tag))
    }
    
    //MARK: - Private Methods
    
    func initialize() {
        
        scrollView.bounces = true
        scrollView.scrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        
        scrollView.delaysContentTouches = true
        
        addSubview(scrollView)
        
        UIView.embedView(scrollView)

        addSectionConstraints()
    }
    
    func addButton(view: UIView, index: Int, header: Bool) {
        let button = UIButton.init()
        
        button.tag = index
        
        view.addSubview(button)
        
        UIView.embedView(button)
        
        if header {
            button.addTarget(self, action: "userDidTapHeaderButton:", forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            button.addTarget(self, action: "userDidTapCellButton:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func addSectionConstraints() {
        
        var views : Dictionary<String, UIView> = [:]
        
        var heightVisualFormat = "V:|"
        
        var metrics : Dictionary<String, CGFloat> = [:]
        
        var widthConstraints : Array<NSLayoutConstraint> = []
        
        if let sections = datasource?.numberOfSectionsInMenuSection() {
            
            for section in 0...sections-1 {
                
                if let view = datasource?.menuSection(self, viewForHeaderInSection: section) {
                    addButton(view, index: section, header: true)
                    
                    let subsectionContainerView = createSubsectionContainer(section)
                    
                    views["view\(section)"] = view
                    views["subsectionContainerView\(section)"] = subsectionContainerView
                    
                    view.translatesAutoresizingMaskIntoConstraints = false
                    
                    scrollView.addSubview(view)
                    
                    heightVisualFormat += "[view\(section)(height\(section))][subsectionContainerView\(section)]"
                    
                    let widthConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view(width)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["width": superview!.frame.width], views: ["view": view])
                    
                    widthConstraints += widthConstraint
                    
                    metrics["height\(section)"] = delegate?.menuSection(self, heightForHeaderInSection: section)
                    
                    scrollView.addConstraints(widthConstraints)
                }
            }
            
            heightVisualFormat += "|"
            
            let heightConstraints = NSLayoutConstraint.constraintsWithVisualFormat(heightVisualFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
            
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
            
            for row in 0...rows-1 {
                
                if let view = datasource?.menuSection(self, viewForRowAtIndexPath: NSIndexPath.init(forRow: row, inSection: section)) {
                    
                    view.tag = row
                    
                    addButton(view, index: section, header: false)
                    
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
            
            dVerticalConstraints["subsectionContainerView\(section)"] = verticalConstraints
            
            NSLayoutConstraint.deactivateConstraints(verticalConstraints)
        }
        
        subsectionContainerView.clipsToBounds = true
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subsectionContainerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subsectionContainerView": subsectionContainerView])
        
        scrollView.addConstraints(horizontalConstraints)
        
        return subsectionContainerView
    }
    
    func totalHeightSection(section: Int) -> CGFloat {
        var totalHeight : CGFloat = 0.0
        
        if let rows = datasource?.menuSection(self, numberOfRowsInSection: section) {
            for row in 0...rows-1 {
                
                if let height = delegate?.menuSection(self, heightForRowAtIndexPath: NSIndexPath.init(forRow: row, inSection: section)) {
                    totalHeight += height
                }
            }
        }
        
        return totalHeight
    }
}
