//
//  KoreanUtils.swift
//  Pods
//
//  Created by Bae Yong-Ju on 5/31/17.
//
//

import Foundation

open class KoreanUtils {
    public static var defaultJosaFormatter : JosaFormatter {
        get {
            struct Static {
                static let instance = KoreanUtils.createDefaultJosaFormatter()
            }
        
            return Static.instance;
        }
    }
    
    public static func createDefaultJosaFormatter() -> JosaFormatter{
        let josaFormatter = JosaFormatter()
        return josaFormatter;
    }
    
    public static func format(_ format: String, _ arguments: CVarArg...) -> String {
        return KoreanUtils.defaultJosaFormatter.format(format, arguments)
    }
    
    public static func format(_ format: String, _ arguments: [CVarArg]) -> String {
        return KoreanUtils.defaultJosaFormatter.format(format, locale: Locale.current, arguments)
    }
    
    public static func format(_ format: String, locale: Locale?, _ arguments: CVarArg...) -> String {
        return KoreanUtils.defaultJosaFormatter.format(format, locale: locale, arguments)
    }
    
    public static func format(_ format: String, locale: Locale?, _ arguments: [CVarArg]) -> String {
        return KoreanUtils.defaultJosaFormatter.format(format, locale: locale, arguments)
    }
}
