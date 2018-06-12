//
//  ViewController.swift
//  WolfSegMent
//
//  Created by xiaozao on 2018/5/11.
//  Copyright © 2018年 Tony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    let tmpView = WolfSegmentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wolfSegment = WolfSegmentBar.init(frame: CGRect.init(x: 0, y: 100, width: view.frame.width, height: 40),
                                           titles: ["Apple Store", "头条", "世界杯", "测试长文字", "新时代", "娱乐", "体育", "要闻", "段子", "微资讯", "本地", "科技", "Apple Store"],
                                           config: WolfButtonConfig.default())
        view.addSubview(wolfSegment)
        wolfSegment.selectIndex = { index in
            print(index)
        }
        
    }
    
    @objc func changeFrame() {
//        tmpView.frame = CGRect.init(x: 100, y: 100, width: 100, height: 200)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

