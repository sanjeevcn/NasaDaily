//
//  ContentView.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import SwiftUI

struct SearchTabView: View {
    @EnvironmentObject var viewModel: NasaDailyViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                topSearchView()
                    .padding(.all)
                
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
            Color.yellow
                .opacity(0.1)
                .cornerRadius(10)
            
            VStack(spacing: 10) {
                DateTextField(data: $viewModel.dateField)
                    .padding(.vertical)
                    .padding(.horizontal, 5)
                
                Button("Get Picture") {
                    Task {
                        await viewModel.fetchPicOfTheDay(for: viewModel.dateField.value)
                    }
                }.buttonStyle(RoundedButtonStyle())
                
                if let onlineTime = viewModel.lastOnlineTime {
                    Text("Last Online: \(onlineTime, formatter: Self.dateFormat)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }.padding()
        }
    }
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        return formatter
    }()
    
    func todayButton() -> some View {
        Button("Today's Picture") {
            Task {
                await viewModel.fetchTodaysPicOfTheDay()
            }
        }.buttonStyle(RoundedButtonStyle(200, color: .yellow))
    }
}
