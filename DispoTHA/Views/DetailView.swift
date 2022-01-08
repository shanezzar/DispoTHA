//
//  DetailView.swift
//  DispoTHA
//
//  Created by Shanezzar Sharon on 08/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: "")
    }
}

struct DetailView: View {
    
    // MARK:- variables
    @Environment(\.dismiss) var dismiss
    
    var id: String
    
    @State var isLoading: Bool = false
    
    @State var error: String = ""
    
    @State var gif: GIF? = nil
    
    // MARK:- views
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button {
                    haptic()
                    dismiss()
                } label: {
                    Image("arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, alignment: .center)
                        .rotationEffect(Angle(degrees: -90))
                }
                
                Spacer()
                
                Text("Details")
                    .foregroundColor(.titleColor)
                    .font(Font.custom(CustomFont.sofiaProSemiBold, size: 23))
            }
            .padding(.horizontal, 32)
            .padding(.top, 64)
            .padding(.bottom, 24)
            
            if isLoading {
                PlaceholderView(type: .loading)
            }
            else if !error.isEmpty {
                PlaceholderView(type: .error(message: error))
            }
            else {
                ScrollView {
                    AnimatedImage(url: URL(string: gif?.url ?? Constants.placeholderImage))
                        .resizable()
                        .placeholder {
                            Rectangle().foregroundColor(Color.gray)
                        }
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.width/1.5, alignment: .center)
                        .clipped()
                        .cornerRadius(8)
                    
                    Group {
                        HStack(alignment: .top) {
                            Text("Id: ")
                                .frame(width: 60, alignment: .leading)
                                .foregroundColor(.titleColor)
                                .font(Font.custom(CustomFont.sofiaProSemiBold, size: 16))
                            
                            Text((gif?.id ?? "").isEmpty ? "..." : gif?.id ?? "")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.bodyColor)
                                .font(Font.custom(CustomFont.sofiaProLight, size: 14))
                                .lineSpacing(4)
                                .lineLimit(.max)
                            
                            Spacer()
                        }
                        .padding(.top, 64)
                        
                        HStack(alignment: .top) {
                            Text("Tld: ")
                                .frame(width: 60, alignment: .leading)
                                .foregroundColor(.titleColor)
                                .font(Font.custom(CustomFont.sofiaProSemiBold, size: 16))
                            
                            Text((gif?.tld ?? "").isEmpty ? "..." : gif?.tld ?? "")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.bodyColor)
                                .font(Font.custom(CustomFont.sofiaProLight, size: 14))
                                .lineSpacing(4)
                                .lineLimit(.max)
                            
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                        HStack(alignment: .top) {
                            Text("Title: ")
                                .frame(width: 60, alignment: .leading)
                                .foregroundColor(.titleColor)
                                .font(Font.custom(CustomFont.sofiaProSemiBold, size: 16))
                            
                            Text((gif?.title ?? "").isEmpty ? "..." : gif?.title ?? "")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.bodyColor)
                                .font(Font.custom(CustomFont.sofiaProLight, size: 14))
                                .lineSpacing(4)
                                .lineLimit(.max)
                            
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                        HStack(alignment: .top) {
                            Text("By: ")
                                .frame(width: 60, alignment: .leading)
                                .foregroundColor(.titleColor)
                                .font(Font.custom(CustomFont.sofiaProSemiBold, size: 16))
                            
                            Text((gif?.username ?? "").isEmpty ? "..." : gif?.username ?? "")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.bodyColor)
                                .font(Font.custom(CustomFont.sofiaProLight, size: 14))
                                .lineSpacing(4)
                                .lineLimit(.max)
                            
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                        HStack(alignment: .top) {
                            Text("Rating: ")
                                .frame(width: 60, alignment: .leading)
                                .foregroundColor(.titleColor)
                                .font(Font.custom(CustomFont.sofiaProSemiBold, size: 16))
                            
                            Text((gif?.rating ?? "").isEmpty ? "..." : gif?.rating ?? "")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.bodyColor)
                                .font(Font.custom(CustomFont.sofiaProLight, size: 14))
                                .lineSpacing(4)
                                .lineLimit(.max)
                            
                            Spacer()
                        }
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 36)
                    
                }
            }
            
            Spacer()
            
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.all)
        .task {
            DispatchQueue.main.async {
                isLoading = true
                NetworkModel.shared.fetchGIF(id) { gif, error in
                    if let error = error {
                        isLoading = false
                        self.error = error.localizedDescription
                        return
                    }
                    
                    isLoading = false
                    self.error = ""
                    self.gif = gif
                }
            }
        }
    }
    
}
