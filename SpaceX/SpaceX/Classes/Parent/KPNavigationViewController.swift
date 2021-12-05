//
//  KPNavigationViewController.swift
//  SpaceX
//
//  Created by Jayesh Tejwani on 02/12/21.
//

import UIKit

class KPNavigationViewController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    let swipeInteractionController = SwipeInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf: KPNavigationViewController? = self
        self.hidesBarsOnTap = false
        self.hidesBarsOnSwipe = false
        self.hidesBarsWhenKeyboardAppears = false
        self.interactivePopGestureRecognizer?.delegate = weakSelf!
        self.delegate = weakSelf!
        self.isNavigationBarHidden = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        if self.viewControllers.count > 1{
            return true
        }else{
            return false
        }
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer!.isEnabled = true
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }
}

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    
    fileprivate var shouldCompleteTransition = false
    fileprivate var shouldCompleteTransitionViaVelocity: Bool?
    fileprivate weak var viewController: UIViewController!
    
    func wireToViewController(_ viewController: UIViewController!) {
        self.viewController = viewController
        prepareGestureRecognizerInView(viewController.view)
    }
    
    fileprivate func prepareGestureRecognizerInView(_ view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        let velo = gestureRecognizer.velocity(in: gestureRecognizer.view!.superview!)
        var progress: CGFloat = 0
        let point = translation.x < 0 ? 0 : translation.x
        progress = (point / _screenSize.width) //(translation.x / 100)
        if velo.x > 800 {
            shouldCompleteTransitionViaVelocity = true
        }else if velo.x < -800 {
            shouldCompleteTransitionViaVelocity = false
        }else{
            shouldCompleteTransitionViaVelocity = nil
        }
        
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            _ = viewController.navigationController?.popViewController(animated: true)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if (shouldCompleteTransition && shouldCompleteTransitionViaVelocity == nil){
                update(progress)
                finish()
            }else if let value = shouldCompleteTransitionViaVelocity {
                if value{
                    update(progress)
                    finish()
                }else{
                    cancel()
                }
            }else{
                cancel()
            }
        default:
            print("Unsupported")
        }
    }
}

