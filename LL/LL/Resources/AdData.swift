//
//  AdData.swift
//  LL
//
//  Created by Morgan Wilkinson on 6/13/20.
//  Copyright © 2020 Morgan Wilkinson. All rights reserved.
//

import Foundation
import SwiftUI
import GoogleMobileAds
import AdColony
import UIKit

// Add tp pod file first = pod 'GoogleMobileAdsMediationTestSuite'
// import GoogleMobileAdsMediationTestSuite

final class Ads: NSObject, GADInterstitialDelegate{
    let adID: String = "ca-app-pub-2030770006889815/7603128128"
    let testAdID: String = "ca-app-pub-3940256099942544/4411468910"
    var interstitial: GADInterstitial
    
    override init() {
        self.interstitial = GADInterstitial(adUnitID: testAdID)
        super.init()
        LoadInterstitial()
    }
    
    func LoadInterstitial(){
        let req = GADRequest()
        self.interstitial.load(req)
        self.interstitial.delegate = self
    }
    
    func showAd(){
        if self.interstitial.isReady{
            self.interstitialDidReceiveAd(interstitial)
            let root = UIApplication.shared.windows.first?.rootViewController
            self.interstitial.present(fromRootViewController: root!)
            
            //Testing for ad mediation
            //GoogleMobileAdsMediationTestSuite.present(on: root!, delegate:nil)
        }
       else{
           print("Not Ready")
       }
    }
    
    // Function that tests to see where the add came from
    func interstitialDidReceiveAd(_ interstitial: GADInterstitial) {
        print("Interstitial adapter class name: \(String(describing: interstitial.responseInfo?.adNetworkClassName))")
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitial = GADInterstitial(adUnitID: testAdID)
        LoadInterstitial()
    }
}
