//
//  CharUtils.swift
//  JosaFormatter
//
//  Created by 1100388 on 5/26/17.
//  Copyright © 2017 1100388. All rights reserved.
//

import Foundation

extension CharacterSet {
    //    func hangulFullChars() ->CharacterSet {
    //        return CharacterSet(charactersIn: UnicodeScalar("\u{ac00}")...UnicodeScalar("\u{d7af}"))
    //    }
    
    public static var hangulFullChars : CharacterSet {
        get {
            return CharacterSet(charactersIn: UnicodeScalar("\u{ac00}")...UnicodeScalar("\u{d7af}"))
        }
    }
    
    public static func isWhitespace (_ ch :Character ) -> Bool {
        return String(ch).rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines) != nil
    }
}

class CharUtils {
    public static func hasHangulJongSung (_ ch: Character ) -> Bool {
        var str = String(ch)
        return str.rangeOfCharacter(from: CharacterSet.hangulFullChars) != nil && (str.unicodeScalars[str.unicodeScalars.startIndex].value - 0xAC00) % 28 > 0;
    }
}
