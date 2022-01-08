//
//  Extension.swift
//  DispoTHA
//
//  Created by Shanezzar Sharon on 08/01/2022.
//

import SwiftUI

extension Color {
    
    // MARK:- variables
    static var titleColor = Color("title-color")
    
    static var cardColor = Color("card-color")
    
    static var bodyColor = Color("body-color")
    
}

extension View {
    
    // MARK:- functions
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let impactMed = UIImpactFeedbackGenerator(style: style)
        impactMed.impactOccurred()
    }
    
}

extension String {
    
    // MARK:- variables
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
}
