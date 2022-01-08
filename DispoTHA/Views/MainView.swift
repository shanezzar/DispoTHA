//
//  MainView.swift
//  DispoTHA
//
//  Created by Shanezzar Sharon on 08/01/2022.
//

import SwiftUI

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct MainView: View {
    
    // MARK:- variables
    @ObservedObject var networkModel = NetworkModel.shared
    
    @State var search: String = ""
    
    @State var showError: Bool = false
    
    // MARK:- views
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 42, alignment: .center)
                    
                    Spacer()
                    
                    Text("Welcome")
                        .foregroundColor(.titleColor)
                        .font(Font.custom(CustomFont.sofiaProSemiBold, size: 23))
                }
                .padding(.horizontal, 32)
                .padding(.top, 8)
                
                HStack {
                    Spacer()
                    
                    TextField("Search gif here...", text: $search)
                        .foregroundColor(.titleColor)
                        .font(Font.custom(CustomFont.sofiaProMedium, size: 16))
                        .keyboardType(.webSearch)
                        .frame(height: 50, alignment: .center)
                    
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                HStack {
                                    Spacer()
                                    
                                    Button("Done") {
                                        haptic()
                                        hideKeyboard()
                                    }
                                }
                            }
                        }
                        .onChange(of: search) { newValue in
                            networkModel.refresh(search: newValue)
                        }
                    
                    Button(action: {
                        haptic()
                        search = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(search == "" ? 0 : 1)
                            .frame(width: 12, height: 12)
                            .foregroundColor(.bodyColor)
                            .padding()
                    }
                    
                    Button {
                        haptic()
                        hideKeyboard()
                        DispatchQueue.main.async {
                            networkModel.refresh(search: search)
                        }
                    } label: {
                        Image("search-icon")
                            .padding()
                    }
                }
                .padding(.horizontal, 24)
                
                if showError {
                    PlaceholderView(type: .error(message: networkModel.error))
                }
                else if networkModel.gifs.count > 0 {
                    List {
                        ForEach(networkModel.gifs.indices, id: \.self) { index in
                            NavigationLink {
                                DetailView(id: networkModel.gifs[index].id)
                            } label: {
                                GIfView(gif: networkModel.gifs[index])
                            }
                            .padding(.trailing, 16)
                            .onAppear {
                                if index == networkModel.gifs.count - 2 {
                                    DispatchQueue.main.async {
                                        networkModel.loadMore(search: search)
                                    }
                                }
                            }
                        }
                        .listRowSeparatorTint(.clear)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .listRowSeparator(.hidden)
                    .refreshable {
                        haptic()
                        SoundModel.shared.playRefresh()
                        DispatchQueue.main.async {
                            networkModel.refresh(search: search)
                        }
                    }
                }
                else {
                    if networkModel.isLoading {
                        PlaceholderView(type: .loading)
                    }
                    else {
                        PlaceholderView(type: .noData)
                    }
                }
                
                Spacer()
                
                    .navigationBarTitle("")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
            }
            .task {
                if networkModel.gifs.count == 0 {
                    networkModel.refresh(search: search)
                }
            }
            .onChange(of: networkModel.error) { newValue in
                showError = !newValue.isEmpty ? true : false
            }
        }
    }
    
}
