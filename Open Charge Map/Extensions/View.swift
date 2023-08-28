//
//  View.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 28.08.23.
//

import Foundation
import SwiftUI

extension View {
    
    func vibrantShadow() -> some View {
        return self
            .shadow(color: Color(red: 240/255, green: 46/255, blue: 170/255).opacity(0.4), radius: 0, x: -5, y: 5)
            .shadow(color: Color(red: 240/255, green: 46/255, blue: 170/255).opacity(0.3), radius: 0, x: -10, y: 10)
            .shadow(color: Color(red: 240/255, green: 46/255, blue: 170/255).opacity(0.2), radius: 0, x: -15, y: 15)
            .shadow(color: Color(red: 240/255, green: 46/255, blue: 170/255).opacity(0.1), radius: 0, x: -20, y: 20)
            .shadow(color: Color(red: 240/255, green: 46/255, blue: 170/255).opacity(0.05), radius: 0, x: -25, y: 25)
    }
    
    func decentShadow() -> some View {
        return self
            .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 10)
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
    }
    
    func boxShadow() -> some View {
        return self
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
    }
    
    func extendedBoxShadow() -> some View {
        return self
            .shadow(color: Color(red: 17/255, green: 17/255, blue: 26/255).opacity(0.1), radius: 16, x: 0, y: 4)
            .shadow(color: Color(red: 17/255, green: 17/255, blue: 26/255).opacity(0.1), radius: 24, x: 0, y: 8)
            .shadow(color: Color(red: 17/255, green: 17/255, blue: 26/255).opacity(0.1), radius: 56, x: 0, y: 16)
    }
    
}
