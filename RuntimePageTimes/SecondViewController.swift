//
//  SecondViewController.swift
//  RuntimePageTimes
//
//  Created by 🍎上的豌豆 on 2019/7/14.
//  Copyright © 2019 xiao. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.view.addSubview(Btn)
    }
    let Btn: UIButton = {
        
        let btn = UIButton.init(type: .custom)
        btn.setTitle("上一页", for: .normal)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        btn.frame = CGRect.init(x: 30, y: 100, width: 200, height: 50)
         btn.xzb.bindClickTag("pop上一页")
        return btn
        
    }()
    
    
    @objc func click(){
        self.navigationController?.popViewController(animated: true)
    }
}
