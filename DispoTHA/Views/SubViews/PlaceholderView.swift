//
//  PlaceholderView.swift
//  DispoTHA
//
//  Created by Shanezzar Sharon on 08/01/2022.
//

import SwiftUI

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView(type: .loading)
    }
}

struct PlaceholderView: View {
    
    // MARK:- variables
    var type: PlaceholderViewType
    
    @State var message: String = ""
    
    // MARK:- views
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .foregroundColor(.titleColor)
                    .scaledToFit()
                    .frame(width: 60, height: 60, alignment: .center)
                
                ProgressView()
                    .padding(.vertical, 16)
                
                Text(message)
                    .foregroundColor(.titleColor)
                    .font(Font.custom(CustomFont.sofiaProSemiBold, size: 19))
                    .padding(.horizontal, 24)
                
                Spacer()
            }
            
            Spacer()
        }
        .onAppear {
            switch type {
            case .loading:
                message = "loading..."
            case .noData:
                message = "no results found!"
            case .error(let message):
                self.message = message
            }
        }
        
    }
    
}
