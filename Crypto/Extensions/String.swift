//
//  String.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 21/06/25.
//

import Foundation

extension String {
    
    var removeHTMLOccurance: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "",options: .regularExpression, range: nil)
        
    }
}
