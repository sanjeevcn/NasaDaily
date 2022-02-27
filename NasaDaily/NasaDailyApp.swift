//
//  NasaDailyApp.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import SwiftUI

@main
struct NasaDailyApp: App {
    @ObservedObject var dataManager: PersistenceContainer = .shared
    @ObservedObject var model: NasaDailyViewModel = .shared
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            HomeTabView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environmentObject(model)
                .environment(\.managedObjectContext, dataManager.context)
                .modifier(AlertViewModifier())
        }.onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                debugPrint("App going active")
            case .inactive:
                debugPrint("App going inactive")
            case .background:
                debugPrint("App going background")
                dataManager.saveContext()
            default:
                debugPrint("Unknown scenePhase")
            }
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        dataManager.saveContext()
    }
}

//.preferredColorScheme(.light) //System Based scheme

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier(HiddenNavigationBar())
    }
    
    func appNavigationBarStyle() -> some View {
        modifier(UnHideNavigationBar())
    }
}

