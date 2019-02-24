//
//  DatesHandler.swift
//  Talks
//
//  Created by Denis Garifyanov on 24/02/2019.
//  Copyright © 2019 Denis Garifyanov. All rights reserved.
//

import Foundation

class DatesHandler {
    
    var generalDateFormatterToPrint: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter
    }
    var recentDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    func stringWithChoisedFromatter(withDate date: Date, howManyDatesIsNotCorrent: Int) -> String {
        
        
        return self.generalDateFormatterToPrint.string(from: date)
    }
}
