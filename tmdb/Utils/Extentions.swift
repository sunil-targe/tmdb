//
//  Extentions.swift
//  tmdb
//
//  Created by Sunil Targe on 2021/9/25.
//

import UIKit

extension UITableViewController {
   func showAlert( _ message: String ) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    func dateYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from:self) {
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: date)
            return "(\(year))"
        } else {
            return ""
        }
    }
    
    func readableDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from:self) {
            dateFormatter.dateFormat = "MMM dd, yyyy" // readable format
            return dateFormatter.string(from: date)
        } else {
            return self
        }
    }
}
