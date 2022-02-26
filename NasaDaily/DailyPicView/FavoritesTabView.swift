//
//  FavoritesTabView.swift
//  NasaDaily
//
//  Created by Sanjeev on 27/02/22.
//

import SwiftUI

struct FavoritesListView: View {
    
    @FetchRequest(fetchRequest: FavoritePics.fetchAll()) var favoritePics: FetchedResults<FavoritePics>
    
    var body: some View {
        List(favoritePics) { item in
            NavigationLink(destination: FavoriteDetailView(model: DailyPicModel(item))) {
                FavoriteCardView(model: item)
                    .padding()
                    .listRowSeparator(.hidden)
            }
        }.listStyle(.plain)
    }
}

struct FavoritesTabView: View {
    
    @FetchRequest(fetchRequest: FavoritePics.fetchAll()) var favoritePics: FetchedResults<FavoritePics>
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(favoritePics) { pic in
                    FavoriteCardView(model: pic)
                        .padding()
                        .background(
                            Color.accentColor
                                .opacity(0.2)
                                .cornerRadius(10)
                        )
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
        }
    }
}

struct FavoriteCardView: View {
    let model: FavoritePics
    
    var body: some View {
        HStack {
            if let imageUrl = model.imageUrl {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ZStack {
                        Color.accentColor.opacity(0.1)
                            .cornerRadius(8)
                        ProgressView().scaleEffect(1.0, anchor: .center)
                    }.frame(width: 50, height: 50)
                }
                .frame(width: 50, height: 50)
                .padding(.trailing)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(model.title ?? "")
                    .font(.subheadline)
                
                if let copyright = model.copyright {
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
