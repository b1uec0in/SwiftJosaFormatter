//
//  String+IntegerIndex.swift
//  JosaFormatter
//
//  Created by Bae Yong-Ju on 5/30/17.
//
//

import Foundation

extension String {
    public func indexOf(_ str: String, fromIndex: Int) -> Int {
        if let range = self.range(of: str, options: .literal, range: self.index(self.startIndex, offsetBy: fromIndex)..<self.endIndex) {
            return self.distance(from: str.startIndex, to: range.lowerBound)
        }
        
        return -1
    }
    
    public func indexOf(_ str: String) -> Int {
        return self.indexOf(str, fromIndex: 0)
    }
    
    public func indexOf(_ ch: Character) -> Int {
        return self.indexOf(String(ch))
    }
    
    public func indexOf(_ ch: UnicodeScalar) -> Int {
        return self.indexOf(String(ch))
    }
    public var length : Int {
        get {
            return self.characters.count
        }
    }
    
    public func unicodeScalarAt(_ index: Int) -> UnicodeScalar  {
        return self.unicodeScalars[self.unicodeScalars.index(self.unicodeScalars.startIndex, offsetBy: index)]
    }
    
    public func substring(_ beginIndex: Int, _ endIndex: Int) -> String {
        return self.substring(with: self.index(self.startIndex, offsetBy: beginIndex)..<self.index(self.startIndex, offsetBy: endIndex))
    }
    
    public func substring(_ beginIndex: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: beginIndex))
    }
}
