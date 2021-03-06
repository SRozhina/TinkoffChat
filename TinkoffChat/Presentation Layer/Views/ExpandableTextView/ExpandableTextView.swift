//
//  SPExpandableTextView.swift
//  Pods
//
//  Created by Sofia on 18/10/2018.
//

import UIKit

protocol ExpandableTextViewDelegate: class {
    func textDidChanged()
}

class ExpandableTextView: UITextView {
    @IBInspectable
    var placeholderColor: UIColor = .gray
    @IBInspectable
    var mainTextColor: UIColor = .black
    var placeholderText = ""
    @IBInspectable
    var maxLineCount: Int = 1
    var sendAction: ((String) -> Void)?
    weak var textViewDelegate: ExpandableTextViewDelegate?
    
    private var textViewHeight: NSLayoutConstraint?
    private var oneLineHeight: CGFloat {
        let lineHeight = font?.lineHeight ?? 1
        let lineSize = UITextView().sizeThatFits(CGSize(width: frame.width, height: lineHeight))
        return lineSize.height
    }
    
    var isEmpty: Bool {
        return text.isEmpty || text == placeholderText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        
        textViewHeight = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: self.frame.height)
        textViewHeight?.isActive = true
    }
    
    func clear() {
        text = ""
        textViewDidChange(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var point = CGPoint.zero
        if !text.isEmpty && contentSize.height > oneLineHeight {
            point = CGPoint(x: 0, y: contentSize.height - frame.height)
        }
        setContentOffset(point, animated: false)
    }
}

extension ExpandableTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let lineHeight = textView.font?.lineHeight ?? 1
        let maxHeight = CGFloat(maxLineCount - 1) * lineHeight + oneLineHeight
        
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: textView.contentSize.height))
        
        if newSize.height >= maxHeight {
            textView.isScrollEnabled = true
            textViewHeight?.constant = maxHeight
        } else {
            textView.isScrollEnabled = false
            textViewHeight?.constant = newSize.height
        }
        textViewDelegate?.textDidChanged()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == mainTextColor { return }
        textView.textColor = mainTextColor
        clear()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty { return }
        textView.textColor = placeholderColor
        textView.text = placeholderText
    }
}
