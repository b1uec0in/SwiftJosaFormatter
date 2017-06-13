//
//  CharUtils.swift
//  JosaFormatter
//
//  Created by Bae Yong-Ju on 2017-05-17.
//
//

import Foundation


public extension CharacterSet {
    /// 한글 음절 문자 집합 (가-힣)
    public static var hangulSyllables : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "\u{ac00}"..."\u{d7a3}") // "가"..."힣"
            }
            return Static.characterSet
        }
    }
    
    /// ASCII 영문 문자 집합 (a-zA-Z)
    public static var asciiAlphas : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "a"..."z").union(CharacterSet(charactersIn: "A"..."Z"))
            }
            return Static.characterSet
        }
    }
    
    /// ASCII 숫자 (0-9)
    public static var asciiNumbers : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "0"..."9")
            }
            return Static.characterSet
        }
    }

    /// 일본어 - 히라가나 문자 집합
    public static var hiraganaCharacters : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "\u{3040}"..."\u{309F}") // "ぁ"..."ゟ"
            }
            return Static.characterSet
        }
    }
    
    /// 일본어 - 카타가나 문자 집합
    public static var katakanaCharacters : CharacterSet {
        get {
            struct Static {
                static let characterSet = CharacterSet(charactersIn: "\u{30A0}"..."\u{30FF}") // "゠"..."ヿ"
            }
            return Static.characterSet
        }
    }
    
    /// 일본어 문자 집합 (히라가나 + 카타가나)
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
    /// 한글 유니코드에 받침(종성)이 있는지 검사합니다.
    public static func hasHangulJongSung (_ ch: UnicodeScalar ) -> Bool {
        return CharacterSet.hangulSyllables.contains(ch) && (ch.value - 0xAC00) % 28 > 0
    }
}
