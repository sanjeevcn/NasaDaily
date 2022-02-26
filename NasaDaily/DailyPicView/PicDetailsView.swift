//
//  PicDetailsView.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import SwiftUI

struct PicDetailsView: View {
    @Binding var model: DailyPicModel?
    @ObservedObject var dataManager: DataManager = .shared
    @EnvironmentObject var viewModel: DailyPicViewModel
    
    init(_ dailyPicModel: Binding<DailyPicModel?>) {
        self._model = dailyPicModel
    }
    
    var body: some View {
        VStack {
            if let model = model,
               let imageUrl = model.imageUrl {
                Text(model.title)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .frame(height: 100)
                
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .frame(maxWidth: .deviceWidth)
                } placeholder: {
                    ZStack {
                        Color.accentColor.opacity(0.1)
                            .cornerRadius(8)
                        ProgressView().scaleEffect(1.0, anchor: .center)
                        Text("Somedays it just loads faster..")
                            .foregroundColor(.accentColor.opacity(0.5))
                            .offset(x: 0, y: 50)
                    }.frame(height: 300)
                }
                .frame(idealHeight: 300)
                .padding(.horizontal)
                
                VStack(spacing: 10) {
                    if let copyright = model.copyright {
                        Text("Copyright: \(copyright)").bold()
                    }
                    
                    Text("Dated: \(model.date)")
                    
                    Label("\(dataManager.checkIfItemExist(model.date) ? "Added" : "Add") to favorite", systemImage: dataManager.checkIfItemExist(model.date) ? "star.fill" : "star")
                        .font(.headline)
                        .padding()
                        .background(Color.gray.opacity(0.3).cornerRadius(10))
                        .onTapGesture {
                            Task {
                                if dataManager.checkIfItemExist(model.date) {
                                    dataManager.deleteItem(model.date)
                                } else {
                                    dataManager.savePicModel(model)
                                    viewModel.activeAlert = .custom("Added to favorite!")
                                    viewModel.dailyPicModel = nil
                                }
                            }
                        }
                    
                }.font(.footnote)
                
                Text(model.explanation)
                    .multilineTextAlignment(.leading)
                    .frame(minHeight: 300)
                    .padding()
                
                Spacer(minLength: 100)
            }
        }
    }
}

struct FavoriteDetailView: View {
    var model: DailyPicModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if let model = model,
                   let imageUrl = model.imageUrl {
                    Text(model.title)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .frame(height: 100)
                    
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(8)
                            .frame(maxWidth: .deviceWidth)
                    } placeholder: {
                        ZStack {
                            Color.accentColor.opacity(0.1)
                                .cornerRadius(8)
                            ProgressView().scaleEffect(1.0, anchor: .center)
                            Text("Somedays it just loads faster..")
                                .foregroundColor(.accentColor.opacity(0.5))
                                .offset(x: 0, y: 50)
                        }.frame(height: 300)
                    }
                    .frame(idealHeight: 300)
                    .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        if let copyright = model.copyright {
                            Text("Copyright: \(copyright)").bold()
                        }
                        
                        Text("Dated: \(model.date)")
                        
                    }.font(.footnote)
                    
                    Text(model.explanation)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 300)
                        .padding()
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
}

