//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 22/12/2023.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFortmatter = DateFormatter()
        dateFortmatter.dateFormat = "MMM yyyy"
        
        return dateFortmatter.string(from: self)
    }
}
