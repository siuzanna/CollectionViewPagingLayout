//
//  ScaleTransformViewOptions+Layout.swift
//  CollectionViewPagingLayout
//
//  Created by Amir on 28/03/2021.
//  Copyright © 2021 Amir Khorsandi. All rights reserved.
//

import UIKit
import Foundation

public extension ScaleTransformViewOptions {
    enum Layout: String, CaseIterable {
        case invertedCylinder
        case cylinder
        case coverFlow
        case rotary
        case linear
        case easeIn
        case easeOut
        case blur
    }

    static func layout(_ layout: Layout) -> Self {
        switch layout {
        case .blur:
            return Self(
                minScaleWidth: 0.6,
                minScaleHeight: 0.6,
                scaleRatioWidth: 0.4,
                scaleRatioHeight: 0.4,
                translationRatio: CGPoint(x: 0.66, y: 0.2),
                maxTranslationRatio: CGPoint(x: 2, y: 0),
                blurEffectEnabled: true,
                blurEffectRadiusRatio: 0.2
            )
        case .linear:
            return Self(
                minScaleWidth: 0.6,
                minScaleHeight: 0.6,
                scaleRatioWidth: 0.4,
                scaleRatioHeight: 0.4,
                translationRatio: CGPoint(x: 0.66, y: 0.2),
                maxTranslationRatio: CGPoint(x: 2, y: 0),
                keepVerticalSpacingEqual: true,
                keepHorizontalSpacingEqual: true,
                scaleCurve: .linear,
                translationCurve: .linear
            )
        case .easeIn:
            return Self(
                minScaleWidth: 0.6,
                minScaleHeight: 0.6,
                scaleRatioWidth: 0.4,
                scaleRatioHeight: 0.4,
                translationRatio: CGPoint(x: 0.66, y: 0.2),
                keepVerticalSpacingEqual: true,
                keepHorizontalSpacingEqual: true,
                scaleCurve: .easeIn,
                translationCurve: .linear
            )
        case .easeOut:
            return Self(
                minScaleWidth: 0.6,
                minScaleHeight: 0.6,
                scaleRatioWidth: 0.4,
                scaleRatioHeight: 0.4,
                translationRatio: CGPoint(x: 0.66, y: 0.2),
                keepVerticalSpacingEqual: true,
                keepHorizontalSpacingEqual: true,
                scaleCurve: .linear,
                translationCurve: .easeIn
            )
        case .rotary:
            return Self(
                minScaleWidth: 0,
                minScaleHeight: 0,
                scaleRatioWidth: 0.4,
                scaleRatioHeight: 0.4,
                translationRatio: CGPoint(x: 0.1, y: 0.1),
                minTranslationRatio: CGPoint(x: -1, y: 0),
                maxTranslationRatio: CGPoint(x: 1, y: 1),
                rotation3d: ScaleTransformViewOptions.Rotation3dOptions(angle: .pi / 15, minAngle: -.pi / 3, maxAngle: .pi / 3, x: 0, y: 0, z: 1, m34: -0.004),
                translation3d: .init(translateRatios: (0.9, 0.1, 0),
                                     minTranslateRatios: (-3, -0.8, -0.3),
                                     maxTranslateRatios: (3, 0.8, -0.3))
            )
        case .cylinder:
            return Self(
                minScaleWidth: 0.55,
                minScaleHeight: 0.55,
                maxScale: 0.55,
                scaleRatioWidth: 0.0,
                scaleRatioHeight: 0.0,
                translationRatio: .zero,
                minTranslationRatio: .zero,
                maxTranslationRatio: .zero,
                shadowEnabled: false,
                rotation3d: .init(angle: .pi / 4, minAngle: -.pi, maxAngle: .pi, x: 0, y: 1, z: 0, m34: -0.000_4 - 0.8 * 0.000_2 ),
                translation3d: .init(translateRatios: (0, 0, 0), minTranslateRatios: (0, 0, 1.25), maxTranslateRatios: (0, 0, 1.25))
            )
        case .invertedCylinder:
            return Self(
                minScaleWidth: 1.2,
                minScaleHeight: 1.2,
                maxScale: 1.2,
                scaleRatioWidth: 0.0,
                scaleRatioHeight: 0.0,
                translationRatio: .zero,
                minTranslationRatio: .zero,
                maxTranslationRatio: .zero,
                shadowEnabled: false,
                rotation3d: .init(angle: .pi / 3, minAngle: -.pi, maxAngle: .pi, x: 0, y: -1, z: 0, m34: -0.002),
                translation3d: .init(translateRatios: (0.1, 0, 0),
                                     minTranslateRatios: (-0.05, 0, 0.86),
                                     maxTranslateRatios: (0.05, 0, -0.86))
            )
        case .coverFlow:
                let defaultAngle: Double = .pi / 1.65
                let minAngle: Double = -.pi / 3
                let maxAngle: Double = .pi / 3
                let rotation3d = Rotation3dOptions(
                    angle: defaultAngle,
                    minAngle: minAngle,
                    maxAngle: maxAngle,
                    x: 0,
                    y: -1,
                    z: 0,
                    m34: -0.000_5
                )
                
                
                let translateRatios: (CGFloat, CGFloat, CGFloat) = (0.1, 0, -0.7)
                let minTranslateRatios: (CGFloat, CGFloat, CGFloat) = (-0.1, 0, -3)
                let maxTranslateRatios: (CGFloat, CGFloat, CGFloat) = (0.1, 0, 0)
                let translation3d = Translation3dOptions(
                    translateRatios: translateRatios,
                    minTranslateRatios: minTranslateRatios,
                    maxTranslateRatios: maxTranslateRatios
                )
                
            return Self(
                minScaleWidth: 0.7,
                minScaleHeight: 0.7,
                maxScale: 0.7,
                scaleRatioWidth: 0.0,
                scaleRatioHeight: 0.0,
                translationRatio: .zero,
                minTranslationRatio: .zero,
                maxTranslationRatio: .zero,
                shadowEnabled: true,
                rotation3d: rotation3d,
                translation3d: translation3d
            )
        }
    }
}
