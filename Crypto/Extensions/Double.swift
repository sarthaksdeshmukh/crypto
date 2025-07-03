//
//  Double.swift
//  Crypto
//
//  Created by Sarthak Deshmukh on 11/05/25.
//

import Foundation

extension Double {
    
    /// convert a Double into a currency with 2 decimal places
    /// '"""
    /// Convert 1234.56 to $1,234.56
    /// """
    private var currencyFormatters2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //        formatter.locale = .current
        //        formatter.currencyCode = "usd"
        //        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// convert a Double into a currency  as a string with 2-6 decimal places
    /// '"""
    /// Convert 1234.56 to "$1,234.56"
    /// Convert 12.3456 to "$12.3456"
    /// Convert  0.123456 to "$0.123456"
    /// """
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatters2.string(from: number) ?? "0.00"
    }
    
    /// convert a Double into a currency with 2-6 decimal places
    /// '"""
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $12.3456
    /// Convert  0.123456 to $0.123456
    /// """
    private var currencyFormatters6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //        formatter.locale = .current
        //        formatter.currencyCode = "usd"
        //        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// convert a Double into a currency  as a string with 2-6 decimal places
    /// '"""
    /// Convert 1234.56 to "$1,234.56"
    /// Convert 12.3456 to "$12.3456"
    /// Convert  0.123456 to "$0.123456"
    /// """
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatters6.string(from: number) ?? "0.00"
    }
    
    /// convert a Double into string representation
    /// '"""
    /// Convert 1.2345 to "1.23"
    /// """
    func asNumberString() -> String {
        return String(format: "%.2f",self)
    }
    
    /// convert a Double into string representation with percent symbol
    /// '"""
    /// Convert 1.2345 to "1.23"
    /// """
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()
            
        default:
            return "\(sign)\(self)"
        }
    }
    
}

