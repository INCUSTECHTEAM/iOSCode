//
//  Debouncer.swift
//  Score NEET PG
//
//  Created by Manoj kumar on 12/01/23.
//

import Foundation

class Debouncer {
    let timeInterval: TimeInterval
    var callback: (() -> Void)?
    private var timer: Timer?

    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] timer in
            self?.callback?()
        })
    }
}
