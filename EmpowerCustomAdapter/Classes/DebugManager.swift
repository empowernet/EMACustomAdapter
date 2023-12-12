//
//  DebugManager.swift
//  Copyright © 2017 Empower. All rights reserved.
//

import Foundation

internal class DebugManager {
    
    /// Prints the logs based on **isDebugging's** value
    internal static func printLog(_ log: String) {
        print("[EmpowerCustomAdapter] " + log)
    }
}
