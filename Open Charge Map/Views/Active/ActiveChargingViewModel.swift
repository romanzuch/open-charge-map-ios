//
//  ActiveChargingViewModel.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 02.09.23.
//

import Foundation
import SwiftUI

class ActiveChargingViewModel: ObservableObject {
    var connection: ChargePointConnection
    @Published var transactionTime: Int = 0
    @Published var power: Float = 0.0
    @Published var powerValues: [PowerValue] = []
    @Published var timerString: String = ""
    @AppStorage("ActiveTransaction") var activeTransaction: Transaction?
    var timer: Timer?
    
    init(connection: ChargePointConnection) {
        self.connection = connection
        self.startTransaction()
    }
}

extension ActiveChargingViewModel {
    
    func isRoamingLocation() -> Bool {
        return true
    }
    
    func startTransaction() {
        self.activeTransaction = Transaction(time: Date())
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.transactionTime += 1
                self?.getTimerString()
                let newPowerValue: Float = self?.calculatePower() ?? 0.0
                self?.power += newPowerValue
                self?.powerValues.append(PowerValue(for: newPowerValue))
            }
        }
    }
    
    func calculatePower() -> Float? {
        if let power = connection.power {
            return Float.random(in: power*0.75...power)
        }
        return nil
    }
    
    func getTimerString() {
        let hours = Int(transactionTime) / 3600
        let minutes = Int(transactionTime) / 60 % 60
        let seconds = Int(transactionTime) % 60
        self.timerString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func stopTransaction(handler: @escaping ((Result<Bool, Error>) -> Void)) {
        self.activeTransaction = nil
        timer?.invalidate()
        timer = nil
        handler(.success(true))
    }
    
}
