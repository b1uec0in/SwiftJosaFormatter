//
//  String+IntegerIndex.swift
//  JosaFormatter
//
//  Created by Bae Yong-Ju on 5/30/17.
//  Copyright © 2017 1100388. All rights reserved.
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
    
    public var length : Int {
        get {
            return self.characters.count
        }
    }
    
    public func charAt(_ index: Int) -> Character  {
        return self.characters[self.characters.index(self.characters.startIndex, offsetBy: index)]
    }
    
    public func substring(beginIndex: Int, endIndex: Int) -> String {
        return self.substring(with: self.index(self.startIndex, offsetBy: beginIndex)..<self.index(self.startIndex, offsetBy: endIndex))
    }
    
    public func substring(beginIndex: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: beginIndex))
    }
}
