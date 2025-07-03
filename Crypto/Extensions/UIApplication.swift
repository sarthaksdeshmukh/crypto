//
//  UIApplication.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 15/05/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
