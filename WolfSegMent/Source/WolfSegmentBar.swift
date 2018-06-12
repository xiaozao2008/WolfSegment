//
//  WolfSegmentView.swift
//  WolfSegMent
//
//  Created by xiaozao on 2018/5/11.
//  Copyright © 2018年 Tony. All rights reserved.
//

import UIKit

struct WolfButtonConfig {
    
    static func `default`() -> WolfButtonConfig {
        return self.init(font: UIFont.systemFont(ofSize: 14),
                          textColor:UIColor.hex(0x777777),
                          selectTextColor: UIColor.hex(0x333333),
                          bgColor: UIColor.hex(0xffffff),
                          selectBgColor: UIColor.hex(0xdddddd), itemSpace: 40)
    }
    
    var font = UIFont.systemFont(ofSize: 14)    /// bar的标题字体
    var textColor: UIColor?                     /// bar的标题默认颜色
    var selectTextColor: UIColor?               /// bar的标题被选择时候的颜色
    var bgColor: UIColor?                       /// bar的背景颜色
    var selectBgColor: UIColor?                 /// bar选择后的背景颜色
    var itemSpace: CGFloat = 40                 /// item中title两侧空间
}


public class WolfSegmentBar: UIScrollView {
    
    public var selectIndex: ((Int) -> Void)?
    public private(set) var nowSelect = 0
    public func select(_ index: Int) {
        let item = wolfItems[index]
        item.isSelected = true
        let itemCenter = item.frame.origin.x + (item.width ?? 0) / 2
        if itemCenter < frame.width / 2 {
            self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if itemCenter > contentSize.width - frame.width / 2 {
            self.setContentOffset(CGPoint(x: contentSize.width - frame.width, y: 0), animated: true)
        } else {
            let nowX = item.frame.origin.x - frame.width / 2 + (item.width ?? 0) / 2
            self.setContentOffset(CGPoint(x: nowX, y: 0), animated: true)
        }
    }
    
    private var wolfItems = [WolfItemButton]()
    convenience init(frame: CGRect, titles: [String], config: WolfButtonConfig) {
        self.init(frame: frame)
        var contentWidth: CGFloat = 0
        for i in 0..<titles.count {
            let item = WolfItemButton.init(height: frame.height, title: titles[i], config: config)
            item.tag = 1000 + i
            addSubview(item)
            contentWidth += (item.width ?? 0)
            item.contentWidth = contentWidth
            item.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
            wolfItems.append(item)
        }
        contentSize = CGSize.init(width: contentWidth, height: frame.height)
        select(0)
        nowSelect = 0
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    @objc func selectAction(_ control: UIControl) {
        let tag = control.tag - 1000
        select(tag)
        selectIndex?(tag)
        guard tag != nowSelect else { return }
        wolfItems[nowSelect].isSelected = false
        nowSelect = tag
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        var nowWidth: CGFloat = 0
        for i in 0..<wolfItems.count {
            let item = wolfItems[i]
            item.frame = CGRect.init(x: nowWidth, y: 0, width: item.width ?? 0, height: item.height)
            nowWidth += (item.width ?? 0)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("WolfSegmentBar init failture")
    }
}

fileprivate class WolfItemButton: UIControl {
    
    var width: CGFloat?
    var height: CGFloat = 40
    var contentWidth: CGFloat = 0
    var config: WolfButtonConfig?
    convenience init(height: CGFloat, title: String, config: WolfButtonConfig) {
        self.init(frame: .zero)
        addSubview(label)
        label.font = config.font
        label.textAlignment = .center
        label.text = title
        label.isUserInteractionEnabled = false
        self.height = height
        self.config = config
        width = title.sizeOfFont(CGSize.init(width: 1000, height: height), config.font).width + config.itemSpace
        isSelected = false
    }
    
    public override var isSelected: Bool {
        didSet {
            if let config = config {
                label.textColor = isSelected ? config.selectTextColor : config.textColor
                label.backgroundColor = isSelected ? config.selectBgColor : config.bgColor
                label.font = config.font
            }
        }
    }
    
    private let label = UILabel()
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



fileprivate extension String {
    
    func sizeOfFont(_ size: CGSize, _ font: UIFont) -> CGSize {
        return (self as NSString).boundingRect(with: size,
                                               options: [.usesLineFragmentOrigin,.usesFontLeading],
                                               attributes: [NSAttributedStringKey.font: font],
                                               context: nil).size
    }
}

fileprivate extension UIColor {
    
    static func hex(_ hexColor: Int, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red:CGFloat((hexColor & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((hexColor & 0x00FF00) >> 8)  / 255.0,
                       blue:CGFloat(hexColor & 0x0000FF) / 255.0, alpha: alpha)
    }
}
















