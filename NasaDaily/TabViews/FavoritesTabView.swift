//
//  FavoritesTabView.swift
//  NasaDaily
//
//  Created by Sanjeev on 27/02/22.
//

import SwiftUI

struct FavoritesTabView: View {
    @EnvironmentObject var viewModel: NasaDailyViewModel
    
    @FetchRequest(fetchRequest: FavoritePics.fetchAll()) var favoritePics: FetchedResults<FavoritePics>
    
    var body: some View {
        if favoritePics.isEmpty {
            VStack(spacing: 20) {
                Spacer()
                Text("Looks like there's nothing to show here.").font(.subheadline)
                    .padding(.vertical)
                Button("Start Searching?") {
                    Task {
                        self.viewModel.tabIndex = 1
                    }
                }.buttonStyle(RoundedButtonStyle(200, color: .yellow))
                Spacer()
            }
        } else {
            List(favoritePics) { item in
                NavigationLink(destination: FavoriteDetailView(model: DailyPicModel(item))) {
                    FavoriteCardView(model: item)
                        .padding()
                        .listRowSeparator(.hidden)
                }
            }.listStyle(.plain)
        }
    }
}

struct FavoriteCardView: View {
    let model: FavoritePics
    
    var body: some View {
        HStack {
            if let imageUrl = model.imageUrl {
                CustomAsyncImage(imageUrl, size: 50)
                    .padding(.trailing)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(model.title ?? "")
                    .font(.subheadline)
                
                if let copyright = model.copyright, !copyright.isEmpty {
                    Text("Copyright: \(copyright)")
                        .font(.footnote)
                        .bold()
                }
                
                Text("Dated: \(model.date ?? "")")
            }
            
            Spacer()
            
            Image(systemName: "star.fill").resizable()
                .frame(width: 15, height: 15)
                .padding(5)
                .background(Color.accentColor.opacity(0.2).shadow(radius: 1, x: 1, y: 1))
                .onTapGesture {
                    Task {
                        if let date = model.date {
                            DataManager.shared.deleteItem(date)
                        }
                    }
                }
        }
    }
}

struct CustomAsyncImage: View {
    let imageUrl: URL
    var size: CGFloat
    let text: String?
    
    init(_ imageUrl: URL, size: CGFloat, text: String? = nil) {
        self.imageUrl = imageUrl
        self.size = size
        self.text = text
    }
    
    var body: some View {
        AsyncImage(url: imageUrl) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
                .frame(width: size, height: size)
        } placeholder: {
            ZStack {
                Color.accentColor.opacity(0.1)
                    .cornerRadius(8)
                ProgressView().scaleEffect(1.0, anchor: .center)
                if let placeholderText = text {
                    Text(placeholderText)
                        .foregroundColor(.accentColor.opacity(0.5))
                        .offset(x: 0, y: 50)
                }
            }.frame(width: size, height: size)
        }
        .frame(width: size, height: size)
    }
}
