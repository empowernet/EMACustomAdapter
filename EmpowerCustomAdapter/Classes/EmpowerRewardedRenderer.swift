//
//  EmpowerRewardedRendererSwift.swift
//  EmpowerAdapter
//
//  Created by Sena on 25.10.2023.
//

import Foundation
import GoogleMobileAds

class EmpowerRewardedRendererSwift: NSObject, GADMediationRewardedAd, GADFullScreenContentDelegate {
    
    private var empowerRewardedAd: GADRewardedAd?
    
    var adLoadCallback: GADMediationRewardedAdEventDelegate?
    
    
    var completionHandler: GADMediationRewardedLoadCompletionHandler!
    var adConfiguration: GADMediationRewardedAdConfiguration!
    
    private var codes: [String] = []
    private var waterfallIndex: Int = 0
    
    
    func loadRewarded() {
        let adRequest = GAMRequest()
        
        var adJSON: [String: Any] = [:]
        
        print("EmpowerRewardedRendererSwift load rewarded")
        
        if let receivedParameter = adConfiguration.credentials.settings["parameter"] as? String {
            adJSON = convertToDictionary(text: receivedParameter) ?? [:]
            
            let empowerAdModel = EmpowerAdModel(data: adJSON)
            
            if codes.isEmpty {
                if empowerAdModel.hasOptimized {
                    if let size = adJSON["optimize"] as? Int {
                        for index in stride(from: size, through: 1, by: -1) {
                            print("AdUnits: \(empowerAdModel.code)_FP\(index)")
                            
                            codes.append("\(empowerAdModel.code)_FP\(index)")
                        }
                        codes.append(empowerAdModel.code)
                    }
                } else {
                    codes.append(empowerAdModel.code)
                }
            }
            GADRewardedAd.load(withAdUnitID: codes[waterfallIndex], request: adRequest, completionHandler:  { [self] ad, error in
                
            if let error = error {
                print("EmpowerRewardedRendererSwift Failed to load rewarded ad with error: \(error.localizedDescription)")
                  
                if let handler = completionHandler {
                    adLoadCallback = handler(self, error)
                }
                    
                return
            }
                empowerRewardedAd = ad
            
                if let handler = completionHandler {
                    adLoadCallback = handler(self, nil)
                }
                
                print("EmpowerRewardedRendererSwift Rewarded ad loaded.")
            })
            
            empowerRewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        
        if codes.count-1 > waterfallIndex {
            waterfallIndex += 1
            
            self.loadRewarded()
            
        } else {
            waterfallIndex = 0
            
            print("EmpowerRewardedRendererSwift Failed to load rewarded ad with error: \(error.localizedDescription)")
            
            if let handler = completionHandler {
                adLoadCallback = handler(self, error)
            }
        }
    }
    
    
    func present(from viewController: UIViewController) {
        
        if let ad = empowerRewardedAd {
            ad.present(fromRootViewController: viewController, userDidEarnRewardHandler: {
                
            })
        } else {
            print("EmpowerRewardedRendererSwift Rewarded ad is not ready.")
        }
    }
    
    func convertToDictionary(text: String) -> [String: String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
}
