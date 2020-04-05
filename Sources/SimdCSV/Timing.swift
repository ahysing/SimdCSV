//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 28/03/2020.
//

import Foundation

class TimingAccumulator {
    public var results :[Timer] = []
    private var working :Bool = true
    init(numPhasesIn: Int, configVec :[Int32]) {
        results = Array(repeating: Timer.init(), count: numPhasesIn)
    }
    
    deinit {
    }
    
    private func reportError(context :String) {
        if self.working {
            // Create a file handle to work with
            let stderr = FileHandle.standardError
            // Write it
            let data = (context.data(using: .utf8, allowLossyConversion: true) ?? Data.init(base64Encoded: ""))!
            stderr.write(data)
        }
        working = false;
    }
    
    public func start(phaseNumber :Int) {
        let timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(eventWith(timer:)), userInfo: nil, repeats: true)

        if phaseNumber < results.count && phaseNumber > 0 {
            results[phaseNumber] = timer
        }
    }
    
    // Timer expects @objc selector
    @objc func eventWith(timer: Timer!) {
        let info = timer.userInfo as Any
        print(info)
    }
    
    public func stop(phaseNumber :Int) {
        if phaseNumber < results.count && phaseNumber > 0 {
            results[phaseNumber].invalidate()
        }
    }
}


// a that is designed to start counting on coming into scope and stop counting, putting its results into
// an Accumulator, when leaving scope. Optional - can just use explicit start/stop
class TimingPhase {
    var acc :TimingAccumulator
    var phaseNumber :Int
    init(accIn :TimingAccumulator, phaseIn: Int) {
        self.acc = accIn
        self.phaseNumber = phaseIn
    }
    deinit {
        acc.stop(phaseNumber: phaseNumber)
    }
}
