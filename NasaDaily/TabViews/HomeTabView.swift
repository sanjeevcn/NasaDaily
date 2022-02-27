//
//  CustomTabView.swift
//  NasaDaily
//
//  Created by Sanjeev on 27/02/22.
//

import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject var viewModel: NasaDailyViewModel
    var body: some View {
        NavigationView {
            TabView(selection: $viewModel.tabIndex) {
                SearchTabView()
                    .tabItem({
                        Label("Search", systemImage: "magnifyingglass.circle.fill")
                    })
                    .tag(1)
                
                FavoritesTabView()
                    .tabItem({
                        Label("Favorites", systemImage: "star.circle.fill")
                    })
                    .tag(2)
            }
            .navigationBarTitle(Text("Nasa Daily"), displayMode: .inline)
        }
    }
}
