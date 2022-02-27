//
//  DailyPicViewModel.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import Foundation

enum ActiveAlert { case custom(_ message: String) }

@MainActor
class NasaDailyViewModel: ObservableObject {
    
    static let shared = NasaDailyViewModel()
    
    @Published var dataManager: PersistenceContainer
    @Published var activeAlert: ActiveAlert?
    @Published var isLoading: Bool
    @Published var errorMessage: Error?
    @Published var dailyPicModel: DailyPicModel?
    
    @Published var tabIndex: Int = 1
    //Temporary - If There are more fields this is not saved here
    @Published var dateField: Field
    @Published var lastOnlineTime: Date?
    
    init() {
        self.isLoading = false
        self.errorMessage = nil
        self.dailyPicModel = nil
        
        self.dataManager = .shared
        self.dateField = .init(name: "Date", type: .date)
        
        self.lastOnlineTime = nil
    }
}

extension NasaDailyViewModel: ServiceHandler {
    
    func fetchPicOfTheDay(for date: String) async {
        guard dateField.value.isValidDate else {
            Task { self.activeAlert = .custom("Please enter valid date!") }
            return
        }
        
        Task { self.isLoading = true }
        defer { Task { self.isLoading = false } }
        
        do {
            let dailyPicModel: DailyPicModel = try await serve(endpoint: .fetchPicOfDay(date))
            
            DispatchQueue.main.async {
                self.dailyPicModel = dailyPicModel
                self.lastOnlineTime = Date()
            }
            
        } catch (let err as CustomError) {
            Task {
                self.activeAlert = .custom(err.localizedDescription)
            }
        } catch (let err) {
            Task {
                self.activeAlert = .custom(err.localizedDescription)
            }
        }
    }
    
    func fetchTodaysPicOfTheDay() async {
        guard dailyPicModel == nil else { return }
        
        Task { self.isLoading = true }
        defer { Task { self.isLoading = false } }
        
        do {
            let dailyPicModel: DailyPicModel = try await serve(endpoint: .fetchPicOfDay(nil))
            
            DispatchQueue.main.async {
                self.dailyPicModel = dailyPicModel
                self.lastOnlineTime = Date()
            }
            
        } catch (let err as CustomError) {
            Task {
                self.activeAlert = .custom(err.localizedDescription)
            }
        } catch (let err) {
            Task {
                self.activeAlert = .custom(err.localizedDescription)
            }
        }
    }
}
