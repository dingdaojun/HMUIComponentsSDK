//
//  File.swift
//  StandfordApp
//
//  Created by 余彪 on 2018/2/7.
//  Copyright © 2018年 zhanggui. All rights reserved.
//

import Foundation


public class RepeatingTimer {
    private var state: State = .suspended
    private enum State {
        case suspended
        case resumed
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + repeating, repeating: repeating)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    /// 定时时间
    public var repeating = DispatchTimeInterval.seconds(10)
    
    /// 事件处理回调
    public var eventHandler: (() -> Void)?
    
    public init() {}
    
    /// 执行
    public func resume() {
        if state == .resumed { return }
        state = .resumed
        timer.resume()
    }
    
    /// 暂停
    public func suspend() {
        if state == .suspended { return }
        state = .suspended
        timer.suspend()
    }
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
}
