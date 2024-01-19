//
//  TransitionManager.swift
//  YSMovie
//
//  Created by ystrack on 14/01/24.
//

import Foundation
import UIKit

final class TransitionManager: NSObject {
    // MARK: Constants
    let transitionDuration = 0.6
    
    // MARK: Transition state
    enum Transition {
        case presentation
        case dismissal
        
        var blurAlpha: CGFloat { return self == .presentation ? 1.0 : 0.0 }
        var dimAlpha: CGFloat { return self == .presentation ? 0.5 : 0.0 }
        var visualEffect: UIBlurEffect? { return self == .presentation ? UIBlurEffect(style: .dark) : nil }
        var next: Transition { return self == .presentation ? .dismissal : .presentation }
    }
    var transition: Transition = .presentation
    
    // MARK: Subviews
    private lazy var backgroundBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        return visualEffectView
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var foregroundBlurView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: nil)
        visualEffectView.layer.cornerRadius = 4
        visualEffectView.clipsToBounds = true
        return visualEffectView
    }()
    
    // MARK: Setup Subviews
    private func addBackground(to containerView: UIView) {
        backgroundBlurView.frame = containerView.frame
        backgroundBlurView.alpha = transition.next.blurAlpha
        containerView.addSubview(backgroundBlurView)
        
        dimmingView.frame = containerView.frame
        dimmingView.alpha = transition.next.dimAlpha
        containerView.addSubview(dimmingView)
    }
    
    private func createSelecteViewCopy(view: UIView) -> UIView? {
        let copy = view.snapshotView(afterScreenUpdates: false)
        return copy
    }
}

// MARK: UIViewControllerAnimatedTransitioning Extension
extension TransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        // Clean view
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        addBackground(to: containerView)
        
        let fromView = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.viewController(forKey: .to)
        
        // Cast ViewControllers to correct type
        // and retrieve the selected collection cell view.
        guard
            let selectedView = (transition == .presentation) ?
                ((fromView as? UINavigationController)?.viewControllers.first as? HomeViewController)?.selectedItemView() :
                    ((toView as? UINavigationController)?.viewControllers.first as? HomeViewController)?.selectedItemView(),
            let selectedViewCopy = createSelecteViewCopy(view: selectedView)
        else {
            return
        }
        
        // Add the copy snasphot view.
        containerView.addSubview(selectedViewCopy)
        foregroundBlurView.effect = transition.next.visualEffect
        // Add blur above selected view.
        containerView.insertSubview(foregroundBlurView, aboveSubview: selectedViewCopy)
        // Hide the "real" view.
        selectedView.isHidden = true
        
        let absoluteSelectedViewFrame = selectedView.convert(selectedView.bounds, to: nil)
        
        switch transition {
        case .presentation:
            // Position copy view correctly (same positian as the real view was at).
            selectedViewCopy.frame = absoluteSelectedViewFrame
            foregroundBlurView.frame = selectedViewCopy.frame
            selectedViewCopy.layoutIfNeeded()
            foregroundBlurView.layoutIfNeeded()
            // Add Details View
            let detailsView = transitionContext.view(forKey: .to)!
            containerView.addSubview(detailsView)
            detailsView.alpha = 0.0
            
            let animator = makeExpandShrinkAnimator(for: selectedViewCopy, in: containerView, destinationFrame: containerView.frame) {
                UIView.animate(withDuration: 0.2) {
                    detailsView.alpha = 1.0
                }
                selectedView.isHidden = false
                
                transitionContext.completeTransition(true)
            }
            
            animator.startAnimation()
        case .dismissal:
            // Update frames
            foregroundBlurView.frame = containerView.frame
            selectedViewCopy.frame = containerView.frame
            selectedViewCopy.layoutIfNeeded()
            containerView.layoutIfNeeded()
            
            let animator = makeExpandShrinkAnimator(for: selectedViewCopy, in: containerView, destinationFrame: absoluteSelectedViewFrame) {
                selectedView.isHidden = false
                transitionContext.completeTransition(true)
            }
            animator.startAnimation()
        }
    }
    
    private func makeExpandShrinkAnimator(for view: UIView, in containerView: UIView, destinationFrame: CGRect, completion: @escaping () -> Void) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 1.0)
        let animator = UIViewPropertyAnimator(duration: transitionDuration, timingParameters: springTiming)
        
        animator.addAnimations {
            view.transform = .identity
            view.frame = destinationFrame
            self.foregroundBlurView.frame = destinationFrame
            self.foregroundBlurView.effect = self.transition.visualEffect
            self.backgroundBlurView.alpha = self.transition.blurAlpha
            self.dimmingView.alpha = self.transition.dimAlpha
            
            containerView.layoutIfNeeded()
        }
        
        animator.addCompletion { _ in
            completion()
        }
        
        return animator
    }
}

// MARK: UIViewControllerTransitioningDelegate Extension
extension TransitionManager: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        transition = .presentation
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .dismissal
        return self
    }
}
