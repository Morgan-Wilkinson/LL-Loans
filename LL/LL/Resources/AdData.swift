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
import UIKit

final class Ads: NSObject, GADInterstitialDelegate{
    let adID: String = "ca-app-pub-2030770006889815/7603128128"
    //let testAdID: String = "ca-app-pub-3940256099942544/4411468910"
    var interstitial: GADInterstitial
    
    override init() {
        self.interstitial = GADInterstitial(adUnitID: adID)
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
           let root = UIApplication.shared.windows.first?.rootViewController
           self.interstitial.present(fromRootViewController: root!)
        }
       else{
           print("Not Ready")
       }
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitial = GADInterstitial(adUnitID: adID)
        LoadInterstitial()
    }
}
