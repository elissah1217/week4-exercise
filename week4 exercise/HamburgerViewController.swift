//
//  HamburgerViewController.swift
//  week4 exercise
//
//  Created by Hsin Yi Huang on 5/27/15.
//  Copyright (c) 2015 Hsin Yi Huang. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    var menuViewController: MenuViewController!
    var feedViewController: FeedViewController!
    var feedOriginalCenter: CGPoint!
    var menuScale: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as MenuViewController
        feedViewController = storyboard.instantiateViewControllerWithIdentifier("FeedViewController") as FeedViewController
        
        addChildViewController(menuViewController)
        self.view.addSubview(menuViewController.view)
        addChildViewController(feedViewController)
        self.view.addSubview(feedViewController.view)
       
        menuScale = 0.9
        menuViewController.view.transform = CGAffineTransformMakeScale(menuScale, menuScale)
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        feedViewController.view.addGestureRecognizer(panGestureRecognizer)
        feedViewController.view.userInteractionEnabled = true
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 500.0
        transform = CATransform3DRotate(transform, CGFloat(45 * M_PI/180), 0, 1, 0)
        feedViewController.view.layer.transform = transform
    
        setAnchorPoint(CGPoint(x:1, y:0.5), forView: feedViewController.view)
    }
    
    
    
    
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            feedOriginalCenter = feedViewController.view.center
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            feedViewController.view.center = CGPoint(x: CGFloat(feedOriginalCenter.x + translation.x), y: CGFloat(feedOriginalCenter.y))
            
           var currentScale =  progressValue(feedViewController.view.center.x, refValueMin: 160, refValueMax: 430, convertValueMin: 0.9, convertValueMax: 1)
             menuViewController.view.transform = CGAffineTransformMakeScale(currentScale, currentScale)

            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            if velocity.x > 50 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.feedViewController.view.center.x = 430
                })
                
            } else {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.feedViewController.view.center.x = 160
                })
            
            }
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func progressValue(value: CGFloat, refValueMin: CGFloat, refValueMax: CGFloat, convertValueMin: CGFloat, convertValueMax: CGFloat) -> CGFloat {
        
        var ratio = (value - refValueMin)/(refValueMax - refValueMin)
        var currentValue = (convertValueMax - convertValueMin)*ratio + convertValueMin
        return currentValue
    }


    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    

}
