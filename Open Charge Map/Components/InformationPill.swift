//
//  InformationPill.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 31.08.23.
//

import SwiftUI

struct InformationPill: View {
    
    var icon: String
    var text: String
    var size: PillSize
    var subTitle: String
    
    init(icon: String, text: String, subTitle: String, size: PillSize) {
        self.icon = icon
        self.text = text
        self.subTitle = subTitle
        self.size = size
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer().frame(width: 12)
                Text(text)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("offprimary"))
                    .boxShadow()
            }
            Text(subTitle)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

struct InformationPill_Previews: PreviewProvider {
    static var previews: some View {
        InformationPill(icon: "eurosign", text: "12,23€", subTitle: "Geschätzer Preis", size: .small)
    }
}

enum PillSize {
    case small
    case medium
    case large
}
