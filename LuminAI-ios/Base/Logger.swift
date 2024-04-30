//
//  Logger.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 25.04.24.
//

import os.log

struct Logger {
    
    static func error(data: String) {
        os_log("%s", type: .error, data)
    }

    static func info(data: String) {
        os_log("%s", type: .info, data)
    }

    static func debug(data: String) {
        os_log("%s", type: .debug, data)
    }
}
