//
//  UIViewControllerExtention.swift
//  RuntimePageTimes
//
//  Created by 🍎上的豌豆 on 2019/7/14.
//  Copyright © 2019 xiao. All rights reserved.
//

import UIKit

private var dataCollectPageKey: String = ""

private var pageLeaveDateKey: String = ""

private var pageAccessDateKey: String = ""
private var tagKey: String = ""

extension XZB where Base: UIView {
    
    /// - Parameter tag: 对应埋点枚举
    public func bindClickTag(_ tag: String) {
        objc_setAssociatedObject(base, &tagKey, tag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
extension XZB where Base: UIView {
    
    fileprivate var logTag: String? {
        get {
            return objc_getAssociatedObject(base, &tagKey) as? String
        }
    }
}
extension XZB where Base: UIViewController {
    
    /// 绑定页面访问埋点采集, 必须在viewDidAppear之前调用. (自动捕获并发送埋点数据)
    ///
    /// - Parameter page: 页面对应枚举
    public func bindDataCollect(page:String) {
        self.base.dataCollectPage = page
        
    }
}

extension UIViewController {
    fileprivate var dataCollectPage: String? {
        get {
            return objc_getAssociatedObject(self, &dataCollectPageKey) as? String
        }
        set {
            objc_setAssociatedObject(self,  &dataCollectPageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var leaveDate: Date? {
        get {
            return objc_getAssociatedObject(self, &pageLeaveDateKey) as? Date
        }
        set {
            objc_setAssociatedObject(self,  &pageLeaveDateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var accessDate: Date? {
        get {
            return objc_getAssociatedObject(self, &pageAccessDateKey) as? Date
        }
        set {
            objc_setAssociatedObject(self, &pageAccessDateKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
    }
}
//利用runtime机制补获视图的出现和消失的时间
extension UIViewController {
    fileprivate static func hackLifeCycle() {
        if
            let sysMethod: Method = class_getInstanceMethod(self, #selector(viewDidLoad)),
            let customMethod: Method = class_getInstanceMethod(self, #selector(hack_viewDidLoad))
        {
            method_exchangeImplementations(sysMethod, customMethod)
        }
        if
            let sysMethod: Method = class_getInstanceMethod(self, NSSelectorFromString("dealloc")),
            let customMethod: Method = class_getInstanceMethod(self, #selector(hack_deinit))
        {
            method_exchangeImplementations(sysMethod, customMethod)
        }
        
        if
            let sysMethod: Method = class_getInstanceMethod(self, #selector(viewDidAppear(_:))),
            let customMethod: Method = class_getInstanceMethod(self, #selector(hack_viewDidAppear(_:)))
        {
            method_exchangeImplementations(sysMethod, customMethod)
        }
        if
            let sysMethod: Method = class_getInstanceMethod(self, #selector(viewDidDisappear(_:))),
            let customMethod: Method = class_getInstanceMethod(self, #selector(hack_viewDidDisappear(_:)))
        {
            method_exchangeImplementations(sysMethod, customMethod)
        }
    }
    
    @objc private dynamic func hack_viewDidLoad() {
        
        hack_viewDidLoad()
    }
    
    @objc private dynamic func hack_deinit() {
        
    }
    
    @objc private dynamic func hack_viewDidAppear(_ animated: Bool) {
        if dataCollectPage != nil {
            DispatchQueue.global().async { [weak self] in
                self?.accessDate = Date()
            }
        }
        hack_viewDidAppear(animated)
    }
    
    @objc private dynamic func hack_viewDidDisappear(_ animated: Bool) {
        if
            let collectPage = dataCollectPage,
            let accessDate = self.accessDate
        {
            DispatchQueue.global().async {
                
                print("collectPage===\(collectPage)~~~~~~accessDate======\(accessDate)~~~~~leaveDate====\(Date())")
                
            }
        }
        hack_viewDidDisappear(animated)
    }
}



extension UIControl {
    
    fileprivate class func hackSendAction() {
        if
            let sysMethod: Method = class_getInstanceMethod(self, #selector(sendAction(_:to:for:))),
            let customMethod: Method = class_getInstanceMethod(self, #selector(hack_sendAction(_:to:for:)))
        {
            method_exchangeImplementations(sysMethod, customMethod)
        }
        
    }
    
    
    @objc dynamic private func hack_sendAction(_ action: Selector, to target: AnyObject, for event: UIEvent) {
        switch event.type {
        case .touches:
            if let tag = self.xzb.logTag {
                print("sendAction===\(tag)")
            }
            
        default:
            break
        }
        
        self.hack_sendAction(action, to: target, for: event)
    }
    
}



extension UIApplication {
    
    private static let runOnce: Void = {
        UIControl.hackSendAction()
       UIViewController.hackLifeCycle()
        
    }()
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
    
}
