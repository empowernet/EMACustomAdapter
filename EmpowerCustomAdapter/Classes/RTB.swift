//
//  RTB.swift
//  EmpowerAdapter
//
//  Created by Sena on 18.10.2023.
//

import Foundation

class RTB {
    var url: String = ""
    var params: [RTBParams] = []
    var timeout: Int = 1200
    
    init(data: [String: Any]) {
        if let value = data["url"] as? String {
            url = value
        }
        
        if let value = data["params"] as? [[String: Any]] {
            for parameter in value {
                params.append(RTBParams(data: parameter))
            }
        }
        
        if let value = data["timeour"] as? Int {
            timeout = value
        }
    }
}
