//
//  GIFView.swift
//  DispoTHA
//
//  Created by Shanezzar Sharon on 08/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct GIfView_Previews: PreviewProvider {
    static var previews: some View {
        GIfView(gif: GIF(id: "", tld: "", title: "", username: "", rating: "", url: ""))
    }
}


struct GIfView: View {
    
    // MARK:- variables
    let gif: GIF
    
    // MARK:- views
    var body: some View {
        HStack(alignment: .center) {
            AnimatedImage(url: URL(string: gif.url))
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(Color.gray)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150, alignment: .center)
                .clipped()
                .cornerRadius(8)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(gif.title)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.titleColor)
                    .font(Font.custom(CustomFont.sofiaProSemiBold, size: 14))
                    .lineSpacing(6)
                    .lineLimit(.max)
                
                Text("\(gif.username.isEmpty ? "..." : gif.username)")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.titleColor)
                    .font(Font.custom(CustomFont.sofiaProLight, size: 12))
                    .lineSpacing(6)
                    .lineLimit(.max)
                    .padding(.top, 16)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.cardColor)
        .cornerRadius(8)
    }
    
}
