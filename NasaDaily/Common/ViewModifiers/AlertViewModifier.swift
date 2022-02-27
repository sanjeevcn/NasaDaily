//
//  AlertViewModifier.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import SwiftUI

struct AlertViewModifier: ViewModifier {

    @ObservedObject var viewModel: NasaDailyViewModel = .shared
    
    @Environment(\.dismiss) var dismiss
    
    func body(content: Content) -> some View {
        content
            .alert(using: $viewModel.activeAlert) { alert in
                switch alert {
                case .custom(let message):
                    return Alert(title: Text(Constants.appName), message: Text(message))
                }
            }
            .popup(isPresented: viewModel.isLoading, alignment: .center, content: Loader.init)
    }
}

