//
//  LayoutDesignerViewModel.swift
//  PagingLayoutSamples
//
//  Created by Amir on 27/06/2020.
//  Copyright © 2020 Amir Khorsandi. All rights reserved.
//

import Foundation
import CollectionViewPagingLayout

class LayoutDesignerViewModel {
    
    // MARK: Properties
    
    var onCodePreviewViewModelChange: ((LayoutDesignerCodePreviewViewModel) -> Void)?
    var onOptionsChange: (() -> Void)?
    var selectedLayout: ShapeLayout? {
        didSet {
            refreshOptionViewModels()
        }
    }
    var layouts: [ShapeLayout] = .stack
    var shapesViewModel: ShapesViewModel {
        ShapesViewModel(layouts: layouts, showBackButton: false)
    }
    private(set) var optionViewModels: [LayoutDesignerOptionCellViewModel] = []
    private let codeGenerator = OptionsCodeGenerator()
    
    
    // MARK: Public functions
    
    private func updateCodePreview<T>(options: T) {
        onCodePreviewViewModelChange?(.init(code: codeGenerator.generateCode(options: options)))
    }
    private func update<T>(options: inout T, closure: (inout T) -> Void) {
        closure(&options)
        updateCodePreview(options: options)
        shapesViewModel.setCustomOptions(options)
        onOptionsChange?()
    }
    
    private func refreshOptionViewModels() {
        guard let selectedLayout = selectedLayout else {
            optionViewModels = []
            return
        }
        
        if var options = selectedLayout.scaleOptions {
            updateCodePreview(options: options)
            let update: ((inout ScaleTransformViewOptions) -> Void) -> Void = {  [weak self] in
                self?.update(options: &options, closure: $0)
            }
            
            optionViewModels = [
                .init(title: "Min scale", kind: .singleSlider(current: options.minScale) { n in
                    update { $0.minScale = n }
                    }),
                .init(title: "Max scale", kind: .singleSlider(current: options.maxScale) { n in
                    update { $0.maxScale = n }
                    }),
                .init(title: "Scale ratio", kind: .singleSlider(current: options.scaleRatio) { n in
                    update { $0.scaleRatio = n }
                    }),
                .init(title: "Translation ratio", kind: .doubleSlider(current: options.translationRatio.pair) { n in
                    update { $0.translationRatio = .by(pair: n) }
                    }),
                .init(title: "Min translation ratio", kind: .doubleSlider(current: options.minTranslationRatio?.pair) { n in
                    update { $0.minTranslationRatio = .by(pair: n) }
                    }),
                .init(title: "Max translation ratio", kind: .doubleSlider(current: options.maxTranslationRatio?.pair) { n in
                    update { $0.maxTranslationRatio = .by(pair: n) }
                    }),
                .init(title: "Keep vertical spacing equal", kind: .toggleSwitch(current: options.keepVerticalSpacingEqual) { n in
                    update { $0.keepVerticalSpacingEqual = n }
                    }),
                .init(title: "Keep horizontal spacing equal", kind: .toggleSwitch(current: options.keepHorizontalSpacingEqual) { n in
                    update { $0.keepHorizontalSpacingEqual = n }
                    }),
                .init(title: "Scale curve", kind: .segmented(options: TransformCurve.all.map(\.name), current: options.scaleCurve.name) { n in
                    update { $0.scaleCurve = .by(name: n)! }
                    })
            ]
        } else if var options = selectedLayout.stackOptions {
            updateCodePreview(options: options)
            let update: ((inout StackTransformViewOptions) -> Void) -> Void = {  [weak self] in
                self?.update(options: &options, closure: $0)
            }
            
            optionViewModels = [
                .init(title: "Scale factor", kind: .singleSlider(current: options.scaleFactor) { n in
                    update { $0.scaleFactor = n }
                    }),
                .init(title: "Min scale", kind: .singleSlider(current: options.minScale) { n in
                    update { $0.minScale = n }
                    }),
                .init(title: "Max scale", kind: .singleSlider(current: options.maxScale) { n in
                    update { $0.maxScale = n }
                    }),
                .init(title: "Spacing factor", kind: .singleSlider(current: options.spacingFactor) { n in
                    update { $0.spacingFactor = n }
                    }),
                .init(title: "Max spacing", kind: .singleSlider(current: options.maxSpacing) { n in
                    update { $0.maxSpacing = n }
                    }),
                .init(title: "Alpha factor", kind: .singleSlider(current: options.alphaFactor) { n in
                    update { $0.alphaFactor = n }
                    }),
                .init(title: "Bottom stack alpha speed factor", kind: .singleSlider(current: options.bottomStackAlphaSpeedFactor) { n in
                    update { $0.bottomStackAlphaSpeedFactor = n }
                    }),
                .init(title: "Top stack alpha speed factor", kind: .singleSlider(current: options.topStackAlphaSpeedFactor) { n in
                    update { $0.topStackAlphaSpeedFactor = n }
                    }),
                .init(title: "Perspective ratio", kind: .singleSlider(current: options.perspectiveRatio) { n in
                    update { $0.perspectiveRatio = n }
                    }),
                .init(title: "Shadow enabled", kind: .toggleSwitch(current: options.shadowEnabled) { n in
                    update { $0.shadowEnabled = n }
                    }),
                .init(title: "Shadow opacity", kind: .singleSlider(current: CGFloat(options.shadowOpacity)) { n in
                    update { $0.shadowOpacity = Float(n) }
                    }),
                .init(title: "Shadow offset", kind: .doubleSlider(current: options.shadowOffset.pair) { n in
                    update { $0.shadowOffset = .by(pair: n) }
                    }),
                .init(title: "Shadow radius", kind: .singleSlider(current: options.shadowRadius) { n in
                    update { $0.shadowRadius = n }
                    }),
                .init(title: "Rotate angel", kind: .singleSlider(current: options.stackRotateAngel) { n in
                    update { $0.stackRotateAngel = n }
                    }),
                .init(title: "Pop angle", kind: .singleSlider(current: options.popAngle) { n in
                    update { $0.popAngle = n }
                    }),
                .init(title: "Pop offset ratio", kind: .doubleSlider(current: options.popOffsetRatio.pair) { n in
                    update { $0.popOffsetRatio = .by(pair: n) }
                    }),
                .init(title: "Stack position", kind: .doubleSlider(current: options.stackPosition.pair) { n in
                    update { $0.stackPosition = .by(pair: n) }
                    }),
                .init(title: "Reverse", kind: .toggleSwitch(current: options.reverse) { n in
                    update { $0.reverse = n }
                    }),
                .init(title: "Blur effect enabled", kind: .toggleSwitch(current: options.blurEffectEnabled) { n in
                    update { $0.blurEffectEnabled = n }
                    }),
                .init(title: "Max blur radius", kind: .singleSlider(current: options.maxBlurEffectRadius) { n in
                    update { $0.maxBlurEffectRadius = n }
                    }),
                .init(title: "Blur effect style", kind: .segmented(options: UIBlurEffect.Style.all.map(\.name), current: options.blurEffectStyle.name) { n in
                    update { $0.blurEffectStyle = .by(name: n)! }
                    })
            ]
        } else if var options = selectedLayout.snapshotOptions {
            updateCodePreview(options: options)
            let update: ((inout SnapshotTransformViewOptions) -> Void) -> Void = {  [weak self] in
                self?.update(options: &options, closure: $0)
            }
            optionViewModels = [
                .init(title: "Piece size ratio", kind: .doubleSlider(current: options.pieceSizeRatio.pair) { n in
                    update { $0.pieceSizeRatio = .by(pair: n) }
                    })
            ]
        }
    }
    
}