//
//  EmpowerCustomAdapterUtils.swift
//  EmpowerCustomAdapter
//
//  Created by Sena on 12.12.2023.
//

import Foundation
import GoogleMobileAds

public class EmpowerCustomAdapterUtils {
    
    public static func initialize() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}
