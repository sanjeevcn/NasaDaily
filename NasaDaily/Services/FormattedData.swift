//
//  FormattedData.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import Foundation

extension String {
    var isValidDate: Bool {
        let pattern = #"^\d{4}[\/-]\d{1,2}[\/-]\d{1,2}$"#
//        let pattern = #"^\d{1,2}[\/-]\d{1,2}[\/-]\d{4}$"#
        let result = self.range(of: pattern, options: .regularExpression)
        return result != nil
    }
    
    var removeSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}

extension DateFormatter {
    static var formate: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"//"dd-MM-YYYY"
        return dateFormatter
    }
}
