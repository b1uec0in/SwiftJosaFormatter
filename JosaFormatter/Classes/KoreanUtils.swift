//
//  KoreanUtils.swift
//  Pods
//
//  Created by Bae Yong-Ju on 5/31/17.
//
//

import Foundation

/**
 'KoreanUtils'는 String.format과 유사하게 조사를 교정할 수 있는 format함수를 제공합니다.
 
 예)
     KoreanUtils.format("%@를 %@으로 변경할까요?", "아이폰", "Galaxy");
     
     아이폰을 Galaxy로 변경할까요?
 
 */
open class KoreanUtils {
    /// 기본 JosaFormatter입니다. filter를 추가/수정/삭제하거나 read rule을 추가하여 기본 동작을 수정할 수 있습니다.
    public static var defaultJosaFormatter : JosaFormatter {
        get {
            struct Static {
                static let instance = KoreanUtils.createDefaultJosaFormatter()
            }
        
            return Static.instance
        }
    }
    
    /// 기본 JosaFormatter를 생성하여 리턴합니다. 기본 JosaFormatter를 바탕으로 새로운 JosaFormatter를 생성활 때 유용합니다.
    public static func createDefaultJosaFormatter() -> JosaFormatter{
        let josaFormatter = JosaFormatter()
        return josaFormatter
    }

    /// 현재 locale을 사용하여 format한 문자열을 리턴합니다.
    public static func format(_ format: String, _ arguments: CVarArg...) -> String {
        return KoreanUtils.defaultJosaFormatter.format(format, arguments)
    }
    
    /// 현재 locale을 사용하여 format한 문자열을 리턴합니다.
    public static func format(_ format: String, _ arguments: [CVarArg]) -> String {
        return KoreanUtils.defaultJosaFormatter.format(format, locale: Locale.current, arguments)
    }
    
    /// 주어진 locale을 사용하여 format한 문자열을 리턴합니다.
    public static func format(_ format: String, locale: Locale?, _ arguments: CVarArg...) -> String {
        return KoreanUtils.defaultJosaFormatter.format(format, locale: locale, arguments)
    }
    
    /// 주어진 locale을 사용하여 format한 문자열을 리턴합니다.
    public static func format(_ format: String, locale: Locale?, _ arguments: [CVarArg]) -> String {
        return KoreanUtils.defaultJosaFormatter.format(format, locale: locale, arguments)
    }
}
