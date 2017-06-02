//
//  CharUtils.swift
//  JosaFormatter
//
//  Created by Bae Yong-Ju on 2017-05-17.
//
//

import Foundation


public extension CharacterSet {
    public static var hangulSyllables : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "\u{ac00}"..."\u{d7a3}") // "가"..."힣"
            }
            return Static.characterSet
        }
    }
    
    public static var asciiAlphas : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "a"..."z").union(CharacterSet(charactersIn: "A"..."Z"))
            }
            return Static.characterSet
        }
    }
    
    public static var asciiNumbers : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "0"..."9")
            }
            return Static.characterSet
        }
    }
    
    public static var hiraganaCharacters : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "\u{3040}"..."\u{309F}") // "ぁ"..."ゟ"
            }
            return Static.characterSet
        }
    }
    
    public static var katakanaCharacters : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "\u{30A0}"..."\u{30FF}") // "゠"..."ヿ"
            }
            return Static.characterSet
        }
    }
    
    public static var japaneseCharacters : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet.hiraganaCharacters.union(CharacterSet.katakanaCharacters)
            }
            return Static.characterSet
        }
    }

}

class CharUtils {
    public static func hasHangulJongSung (_ ch: UnicodeScalar ) -> Bool {
        return CharacterSet.hangulSyllables.contains(ch) && (ch.value - 0xAC00) % 28 > 0;
    }
}
