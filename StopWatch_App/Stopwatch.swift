//
//  Stopwatch.swift
//  StopWatch_App
//
//  Created by 초코크림 on 2023/05/22.
//

import UIKit

enum StopWatchType: String {
    case start = "Start" // 새로 시작, stop 가능
    case stop = "Stop" // 멈춤, resume 및 reset 가능
    case resume = "Resume" // 다시 시작, stop 가능
    case reset // 초기화, start 가능
}

enum LapResetType: String {
    case lap = "Lap"
    case reset = "Reset"
}


class Stopwatch {
    // 최초 상태를 reset으로 초기화 해 start 표시
    var stopWatchType = StopWatchType.reset {
        didSet {
            switch stopWatchType {
            case .start:
                start()
            case .stop:
                stop()
            case .resume:
                resume()
            case .reset:
                reset()
            }
        }
    }
    
    var lapResetType: LapResetType {
        switch stopWatchType {
        case .start:
            return .lap
        case .stop:
            return .reset
        case .resume:
            return .lap
        case .reset:
            return .lap
        }
    }
    
    var timer: Timer?
    var startTime: Date?
    var middleStartTime: Date?
    var stopTime: Date?
    var lapList = [String]()
    var showElapsedTime: ((String) -> Void)?
    var showElapsedMiddleTime: ((String) -> Void)?
    
    var possibleType: StopWatchType{
        switch stopWatchType {
        case .start:
            return .stop
        case .stop:
            return .resume
        case .resume:
            return .stop
        case .reset:
            return .start
        }
    }
    
    func possibleButtonTitle() -> String {
        return possibleType.rawValue
    }
    
    func runPossibleType() {
        stopWatchType = self.possibleType
    }
    
    func runPossibleLeftType()  -> LapResetType {
        if lapResetType == .reset {
            stopWatchType = .reset
        }
        else if lapResetType == .lap {
            lap()
        }
        
        return lapResetType
    }
    
    func lapResetTitle() -> String {
        lapResetType.rawValue
    }
    
    // 진행되는 시간을 화면에 표시
    func registTimer() {
        timer = Timer(timeInterval: 0.01, repeats: true, block: { _ in
            self.showElapsedTime?(self.elapsedTime())
            self.showElapsedMiddleTime?(self.elapsedMiddleTime())
        })
        
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func elapsedTime() -> String {
        let interval = (self.startTime?.timeIntervalSinceNow ?? 0) * -1
        let customDate = Date(timeIntervalSinceReferenceDate: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss:SS"
        
        return dateFormatter.string(from: customDate)
    }
    
    // lap 한 시간
    func elapsedMiddleTime() -> String {
        let interval = (self.middleStartTime?.timeIntervalSinceNow ?? 0) * -1
        let customDate = Date(timeIntervalSinceReferenceDate: interval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss:SS"
        
        return dateFormatter.string(from: customDate)
    }
    
    func start() {
        startTime = Date()
        middleStartTime = startTime
        
        registTimer()
    }
    
    func stop() {
        stopTime = Date()
        timer?.invalidate()
        timer = nil
    }
    
    func resume() { // 저장해뒀던 멈춘 시간대를 더함(진짜로 일시정지한 것 처럼 보이게)
        if let elapsedStopTime = stopTime?.timeIntervalSinceNow{
            startTime = startTime?.addingTimeInterval(elapsedStopTime * -1)
            registTimer()
        }
    }
    
    func lap() {
        lapList.insert(elapsedMiddleTime(), at: 0)
        middleStartTime = Date()
    }
    
    func reset() {
        lapList.removeAll()
    }
}
