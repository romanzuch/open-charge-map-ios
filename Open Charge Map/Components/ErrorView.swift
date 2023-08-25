//
//  ErrorView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 25.08.23.
//

import SwiftUI

struct ErrorView: View {
    
    var error: Error
    
    init(error: some Error) {
        self.error = error
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 32, height: 32, alignment: .center)
                .foregroundColor(.red)
            switch error {
                case APIError.connectionStatus(let code):
                    Text("Beim Verbinden mit der API ist ein Fehler aufgetreten. Fehlercode: \(code)")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                case APIError.decodingError(let message):
                    Text("Es ist beim Decoden zu einem Fehler gekommen: \(message)")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                case APIError.emptyData(let message):
                    Text("Leider haben wir keine Daten erhalten. \(message)")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                case APIError.noConnection(let message):
                    Text("Beim Verbinden mit der API ist ein Fehler aufgetreten.  \(message)")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                case APIError.unknown(let message):
                    Text("Ein unbekannter Fehler ist aufgetreten. \(message)")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                default:
                    Text("Ein unbekannter Fehler ist aufgetreten.")
                        .multilineTextAlignment(.center)
                        .font(.caption)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: APIError.connectionStatus(500))
    }
}
