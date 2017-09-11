//
//  SKCaptionView.swift
//  SKPhotoBrowser
//
//  Created by suzuki_keishi  on 2015/10/07.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

open class SKCaptionView: UIView {
    fileprivate var photo: SKPhotoProtocol?
    fileprivate var photoLabel: UILabel!
	fileprivate var linkButton: UIButton!
	
	fileprivate let photoLabelPadding: CGFloat = 20
	fileprivate let linkButtonHeight: CGFloat = 20
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(photo: SKPhotoProtocol) {
        let screenBound = UIScreen.main.bounds
        self.init(frame: CGRect(x: 0, y: 0, width: screenBound.size.width, height: screenBound.size.height))
        self.photo = photo
        setup()
    }
    
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		
        let font: UIFont = photoLabel.font
        let width: CGFloat = size.width - photoLabelPadding * 2
        let height: CGFloat = photoLabel.font.lineHeight * CGFloat(photoLabel.numberOfLines)
		
		let textSize: CGSize
		if let text = photoLabel.text {
			let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
			textSize = attributedText.boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, context: nil).size
		} else {
			textSize = CGSize.zero
		}
		
		let linkExtraHeight = linkButton.isHidden ? 0 : (linkButtonHeight + photoLabelPadding * 2)
		let captionExtraHeight = photoLabel.isHidden ? 0 : textSize.height + (photoLabelPadding * 2)
		
        return CGSize(width: textSize.width, height: captionExtraHeight + linkExtraHeight)
    }
}

private extension SKCaptionView {
    func setup() {
        isOpaque = false
        autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin]
		
        setupPhotoLabel()
		setupLinkButton()
    }
    
    func setupPhotoLabel() {
		photoLabel = UILabel(frame: CGRect(
			x: photoLabelPadding,
			y: 0,
			width: bounds.size.width - (photoLabelPadding * 2),
			height: bounds.size.height - (photo?.linkTitle == nil ? 0 : (linkButtonHeight + photoLabelPadding))
		))
        photoLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        photoLabel.isOpaque = false
        photoLabel.backgroundColor = .clear
        photoLabel.textColor = SKCaptionOptions.textColor
        photoLabel.textAlignment = SKCaptionOptions.textAlignment
        photoLabel.lineBreakMode = SKCaptionOptions.lineBreakMode
        photoLabel.numberOfLines = SKCaptionOptions.numberOfLine
        photoLabel.font = SKCaptionOptions.font
        photoLabel.shadowColor = UIColor(white: 0.0, alpha: 0.5)
        photoLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        photoLabel.text = photo?.caption
        addSubview(photoLabel)
		
		photoLabel.isHidden = photo?.caption == nil
    }
	
	func setupLinkButton() {
		linkButton = UIButton(frame: CGRect(
			x: photoLabelPadding,
			y: bounds.size.height - linkButtonHeight - photoLabelPadding,
			width: bounds.size.width - (photoLabelPadding * 2),
			height: linkButtonHeight
		))
		linkButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
		linkButton.backgroundColor = SKCaptionOptions.textColor
		linkButton.titleLabel?.font = SKCaptionOptions.font
		linkButton.layer.cornerRadius = linkButtonHeight/2
		linkButton.setTitle(photo?.linkTitle, for: .normal)
		linkButton.setTitleColor(.black, for: .normal)
		
		linkButton.sizeToFit()
		let padding: CGFloat = 10
		linkButton.center = CGPoint(x: center.x - padding, y: linkButton.center.y)
		var r = linkButton.frame
		r.size.height = linkButtonHeight
		r.size.width += padding * 2
		linkButton.frame = r;
		addSubview(linkButton)
		
		linkButton.isHidden = photo?.linkTitle == nil
		
		linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
	}
	
	@objc func linkButtonTapped() {
		photo?.linkAction?()
	}
}

