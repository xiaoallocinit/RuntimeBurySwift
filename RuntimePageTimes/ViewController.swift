//
//  ViewController.swift
//  RuntimePageTimes
//
//  Created by 🍎上的豌豆 on 2019/7/14.
//  Copyright © 2019 xiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let Btn: UIButton = {
        
        let btn = UIButton.init(type: .custom)
        btn.setTitle("下一页", for: .normal)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        btn.frame = CGRect.init(x: 30, y: 100, width: 200, height: 50)
        btn.xzb.bindClickTag("next下一页")
        return btn
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.view.addSubview(Btn)
        
    }

    @objc func click(){
   
       let vc = SecondViewController()
    vc.xzb.bindDataCollect(page:"SecondViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
