//
//  Constants.swift
//  AJDA_B2C
//
//  Created by PTBLR-1128 on 12/11/18.
//  Copyright © 2018 Provab Technosoft Pvt. Ltd. All rights reserved.
//

import Foundation


class Constants {
  
  //    static let GOOGLE_API_KEY = "AIzaSyDkgIjLEEluZjwX-GvgLZDiGwr3Sf9vhXk"

  static let BASE_URL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/"
  
  static let GET_PROFILE_INFO = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
  
  
//  struct KEYS {
//    static let isLoggedIn = "isLoggedIn"
//    static let LoginResponse = "LoginResponse"
//    static let AUTH_TOKEN = "AUTH_TOKEN"
//    static let REFRESH_TOKEN = "REFRESH_TOKEN"
//    static let FCMID = "FCMID"
//     static let Device_ID = "Device_ID"
//  }
  
  enum DocumentType: Int {
    case REGISTRATION_PAPERS = 0,
    OWNERS_ID,
    DIN,
    OTHERS,
    NONE
  }
  
  enum BidType: Int {
    case open = 0,
    pending,
    close
  }
  
  
}
