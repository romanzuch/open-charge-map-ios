//
//  ActiveChargingPill.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 03.09.23.
//

import SwiftUI

struct ActiveChargingPill: View {
    
    var transaction: Transaction
    
    init(for transaction: Transaction) {
        self.transaction = transaction
    }
    
    var body: some View {
        VStack {
            Text("\(transaction.start)")
            Text("\(transaction.powerValues.count)")
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("offprimary"))
                .boxShadow()
        }
    }
}

struct ActiveChargingPill_Previews: PreviewProvider {
    static let transaction: Transaction = Transaction(time: Date())
    static var previews: some View {
        ActiveChargingPill(for: transaction)
    }
}
