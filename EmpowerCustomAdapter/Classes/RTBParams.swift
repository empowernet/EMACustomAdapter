//
//  RTBParams.swift
//  EmpowerAdapter
//
//  Created by Sena on 18.10.2023.
//

import Foundation

class RTBParams {
    var zoneId: String = ""
    
    init(data: [String: Any]) {
        if let value = data["zoneId"] as? String {
            zoneId = value
        }
    }
}
