//
//  Cache.swift
//  AJDA_B2C
//
//  Created by PTBLR-1128 on 03/06/19.
//  Copyright © 2019 Provab Technosoft Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit


class Cache {
    
    public static let shared = Cache()
    
    open var currency = "₹"

    open var tabBarheight: CGFloat = 0
    open var notificationCount: String = ""
    open var bid_percentage : Double = 0.0
    open var bid_minimum_value : Double = 0.0
    
  
    
    open var symptomsInputStruct = SymtompsInputValue(DOB: "", name: "", sex: "", text: "")
    open var cartCount = "0"
    open var Medicine_image_url: String = ""
    open var Category_image_url: String = ""
    open var Lab_image_url: String = ""
    open var LAB_CAT_ID: String = ""
    
   
    
}


struct SymtompsInputValue {
    var DOB = ""
    var name = ""
    var sex = ""
    var text = ""
    
}
