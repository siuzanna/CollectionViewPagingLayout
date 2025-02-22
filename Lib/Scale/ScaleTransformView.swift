//
//  ScaleTransformView.swift
//  CollectionViewPagingLayout
//
//  Created by Amir on 15/02/2020.
//  Copyright © 2020 Amir Khorsandi. All rights reserved.
//

import UIKit

/// A protocol for adding scale transformation to `TransformableView`
public protocol ScaleTransformView: TransformableView {
    
    /// Options for controlling scale effect, see `ScaleTransformViewOptions.swift`
    var scaleOptions: ScaleTransformViewOptions { get }
    
    /// The view to apply scale effect on
    var scalableView: UIView { get }
    
    /// The view to apply blur effect on
    var scaleBlurViewHost: UIView { get }
    
    /// the main function for applying transforms
    func applyScaleTransform(progress: CGFloat, shouldScale: Bool)
}


public extension ScaleTransformView {
    
    /// The default value is the super view of `scalableView`
    var scaleBlurViewHost: UIView {
        scalableView.superview ?? scalableView
    }
}


public extension ScaleTransformView where Self: UICollectionViewCell {
    
    /// Default `scalableView` for `UICollectionViewCell` is the first subview of
    /// `contentView` or the content view itself if there is no subview
    var scalableView: UIView {
        contentView.subviews.first ?? contentView
    }
}


public extension ScaleTransformView {
    
    // MARK: Properties
    
    var scaleOptions: ScaleTransformViewOptions {
        .init()
    }
    
    
    // MARK: TransformableView
    
    func transform(progress: CGFloat) {
        applyScaleTransform(progress: progress)
    }
    
    
    // MARK: Public functions
    
    func applyScaleTransform(progress: CGFloat, shouldScale: Bool = true) {
        applyStyle(progress: progress)
        applyScaleAndTranslation(progress: progress, shouldScale: shouldScale)
        applyCATransform3D(progress: progress)
        
        if #available(iOS 10, *) {
            applyBlurEffect(progress: progress)
        }
        
    }
    
    
    // MARK: Private functions
    
    private func applyStyle(progress: CGFloat) {
        guard scaleOptions.shadowEnabled else {
            return
        }
        let layer = scalableView.layer
        layer.shadowColor = scaleOptions.shadowColor.cgColor
        
        let progressMultiplier = 1 - abs(progress)
        let widthProgressValue = progressMultiplier * scaleOptions.shadowOffsetMax.width
        let heightProgressValue = progressMultiplier * scaleOptions.shadowOffsetMax.height
        
        let offset = CGSize(
            width: max(scaleOptions.shadowOffsetMin.width, widthProgressValue),
            height: max(scaleOptions.shadowOffsetMin.height, heightProgressValue)
        )
        layer.shadowOffset = offset
        layer.shadowRadius = max(scaleOptions.shadowRadiusMin, progressMultiplier * scaleOptions.shadowRadiusMax)
        layer.shadowOpacity = max(scaleOptions.shadowOpacityMin, (1 - abs(Float(progress))) * scaleOptions.shadowOpacityMax)
    }
    
    private func applyScaleAndTranslation(progress: CGFloat, shouldScale: Bool) {
        var transform = CGAffineTransform.identity
        var xAdjustment: CGFloat = 0
        var yAdjustment: CGFloat = 0
        let scaleProgress = scaleOptions.scaleCurve.computeFromLinear(progress: abs(progress))

        var scaleWidth = 1 - scaleProgress * scaleOptions.scaleRatioWidth
        var scaleHeight = 1 - scaleProgress * scaleOptions.scaleRatioHeight

        scaleWidth = max(scaleWidth, scaleOptions.minScaleWidth)
        scaleHeight = max(scaleHeight, scaleOptions.minScaleHeight)
        scaleWidth = min(scaleWidth, scaleOptions.maxScale)
        scaleHeight = min(scaleHeight, scaleOptions.maxScale)

        if scaleOptions.keepHorizontalSpacingEqual {
            xAdjustment = ((1 - scaleWidth) * scalableView.bounds.width) / 2
            if progress > 0 {
                xAdjustment *= -1
            }
        }

        if scaleOptions.keepVerticalSpacingEqual {
            yAdjustment = ((1 - scaleHeight) * scalableView.bounds.height) / 2
        }
        
        let translateProgress = scaleOptions.translationCurve.computeFromLinear(progress: abs(progress))
        var translateX = scalableView.bounds.width * scaleOptions.translationRatio.x * (translateProgress * (progress < 0 ? -1 : 1)) - xAdjustment
        var translateY = scalableView.bounds.height * scaleOptions.translationRatio.y * abs(translateProgress) - yAdjustment
        if let min = scaleOptions.minTranslationRatio {
            translateX = max(translateX, scalableView.bounds.width * min.x)
            translateY = max(translateY, scalableView.bounds.height * min.y)
        }
        if let max = scaleOptions.maxTranslationRatio {
            translateX = min(translateX, scalableView.bounds.width * max.x)
            translateY = min(translateY, scalableView.bounds.height * max.y)
        }

        if shouldScale == true {
            transform = transform
                .translatedBy(x: translateX, y: translateY)
                .scaledBy(x: scaleWidth, y: scaleHeight)
        } else {
            scaleWidth = min(scaleWidth, scaleOptions.minScaleWidth)
            scaleHeight = min(scaleHeight, scaleOptions.minScaleHeight)

            transform = transform
                .translatedBy(x: translateX, y: translateY)
                .scaledBy(x: scaleWidth, y: scaleHeight)
        }
        scalableView.transform = transform
    }
    
    private func applyCATransform3D(progress: CGFloat) {
        var transform = CATransform3DMakeAffineTransform(scalableView.transform)
        
        if let options = self.scaleOptions.rotation3d {
            var angle = options.angle * progress
            angle = max(angle, options.minAngle)
            angle = min(angle, options.maxAngle)
            transform.m34 = options.m34
            transform = CATransform3DRotate(transform, angle, options.x, options.y, options.z)
            scalableView.layer.isDoubleSided = options.isDoubleSided
        }
        
        if let options = self.scaleOptions.translation3d {
            var x = options.translateRatios.0 * progress * scalableView.bounds.width
            var y = options.translateRatios.1 * abs(progress) * scalableView.bounds.height
            var z = options.translateRatios.2 * abs(progress) * scalableView.bounds.width
            x = max(x, options.minTranslateRatios.0 * scalableView.bounds.width)
            x = min(x, options.maxTranslateRatios.0 * scalableView.bounds.width)
            y = max(y, options.minTranslateRatios.1 * scalableView.bounds.height)
            y = min(y, options.maxTranslateRatios.1 * scalableView.bounds.height)
            z = max(z, options.minTranslateRatios.2 * scalableView.bounds.width)
            z = min(z, options.maxTranslateRatios.2 * scalableView.bounds.width)
            
            transform = CATransform3DTranslate(transform, x, y, z)
        }
        scalableView.layer.transform = transform
    }

    private func applyBlurEffect(progress: CGFloat) {
        guard scaleOptions.blurEffectRadiusRatio > 0, scaleOptions.blurEffectEnabled else {
            scaleBlurViewHost.subviews.first(where: { $0 is BlurEffectView })?.removeFromSuperview()
            return
        }
        let blurView: BlurEffectView
        if let view = scaleBlurViewHost.subviews.first(where: { $0 is BlurEffectView }) as? BlurEffectView {
            blurView = view
        } else {
            blurView = BlurEffectView(effect: UIBlurEffect(style: scaleOptions.blurEffectStyle))
            scaleBlurViewHost.fill(with: blurView)
        }
        blurView.setBlurRadius(radius: abs(progress) * scaleOptions.blurEffectRadiusRatio)
        blurView.transform = CGAffineTransform.identity.translatedBy(x: scalableView.transform.tx, y: scalableView.transform.ty)
    }
    
}
