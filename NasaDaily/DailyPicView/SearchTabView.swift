//
//  ContentView.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import SwiftUI

struct SearchTabView: View {
    @EnvironmentObject var viewModel: DailyPicViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                topSearchView()
                
                if viewModel.dailyPicModel != nil {
                    PicDetailsView($viewModel.dailyPicModel)
                } else {
                    Spacer(minLength: 100)
                    todayButton()
                    Spacer(minLength: 100)
                }
            }
        }
    }
    
    func topSearchView() -> some View {
        ZStack {
            Color.accentColor
                .opacity(0.2)
            
            VStack(spacing: 10) {
                DateTextField(data: $viewModel.dateField)
                    .padding()
                
                Button("Get pic of the day") {
                    Task {
                        await viewModel.fetchPicOfTheDay(for: viewModel.dateField.value)
                    }
                }.buttonStyle(RoundedButtonStyle())
                
                Text("Last Online: \(viewModel.lastOnlineTime, formatter: Self.dateFormat)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            }.padding()
        }
    }
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        return formatter
    }()
    
    func todayButton() -> some View {
        Button("Todays Pic") {
            Task {
                await viewModel.fetchTodaysPicOfTheDay()
            }
        }.buttonStyle(RoundedButtonStyle(200, color: .gray))
    }
}
