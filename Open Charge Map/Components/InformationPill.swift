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
    var subTitle: String?
    var geometryProxy: GeometryProxy
    let length: CGFloat = 32
    
    init(icon: String, text: String, size: PillSize, geo: GeometryProxy) {
        self.icon = icon
        self.text = text
        self.subTitle = nil
        self.size = size
        self.geometryProxy = geo
    }
    
    init(icon: String, text: String, subTitle: String, size: PillSize, geo: GeometryProxy) {
        self.icon = icon
        self.text = text
        self.subTitle = subTitle
        self.size = size
        self.geometryProxy = geo
    }
    
    var body: some View {
        switch subTitle {
        case .none:
            switch size {
            case .small:
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer().frame(width: 12)
                    Text(text)
                }
                .padding()
                .frame(width: geometryProxy.size.width*(1/3)-(12), height: length*2, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("offprimary"))
                        .boxShadow()
                }
            case .medium:
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer().frame(width: 12)
                    Text(text)
                }
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(width: geometryProxy.size.width*(2/3)-(3*12), height: length*4+10, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("offprimary"))
                        .boxShadow()
                }
            case .large:
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer().frame(width: 12)
                    Text(text)
                }
                .padding()
                .frame(width: length*10, height: length*5, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("offprimary"))
                        .boxShadow()
                }
            }
        case .some(let subtitle):
            switch size {
            case .small:
                VStack {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                    HStack {
                        Image(systemName: icon)
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer().frame(width: 12)
                        Text(text)
                    }
                }
                .padding()
                .frame(width: geometryProxy.size.width*(1/3), height: length*2, alignment: .center)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("offprimary"))
                        .boxShadow()
                }
            case .medium:
                VStack {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                    HStack {
                        Image(systemName: icon)
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer().frame(width: 12)
                        Text(text)
                    }
                    .font(.title)
                    .fontWeight(.bold)
                }
                .padding()
                .frame(width: geometryProxy.size.width*(2/3)-(3*12), height: length*4+10, alignment: .center)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("offprimary"))
                        .boxShadow()
                }
            case .large:
                VStack {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                    HStack {
                        Image(systemName: icon)
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer().frame(width: 12)
                        Text(text)
                    }
                }
                .padding()
                .frame(width: geometryProxy.size.width, height: length*5, alignment: .center)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("offprimary"))
                        .boxShadow()
                }
            }
        }
    }
}

struct InformationPill_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            InformationPill(icon: "eurosign", text: "12,23€", subTitle: "Klein", size: .small, geo: geo)
        }
        GeometryReader { geo in
            InformationPill(icon: "eurosign", text: "12,23€", subTitle: "Mittel", size: .medium, geo: geo)
        }
        GeometryReader { geo in
            InformationPill(icon: "eurosign", text: "12,23€", subTitle: "Groß", size: .large, geo: geo)
        }
    }
}

enum PillSize {
    case small
    case medium
    case large
}
