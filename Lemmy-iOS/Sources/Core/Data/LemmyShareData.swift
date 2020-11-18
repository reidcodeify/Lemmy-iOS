//
//  LemmyShareData.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// work after auth
class LemmyShareData {

    static let shared = LemmyShareData()
    let loginData = LoginData.shared

    static var isLogined: Bool {
        Self.shared.jwtToken != nil
    }

    enum Constants {
        static let jwt = "jwt"
        static let userId = "userId"
        static let userdata = "userdata"
    }

    let userDefaults = UserDefaults.appShared

    var userdata: LemmyModel.MyUser? {
        get {
            guard let data = userDefaults.data(forKey: Constants.userdata)
                else { return nil }
            return try? LemmyJSONDecoder().decode(LemmyModel.MyUser.self, from: data)
        } set {
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter().then {
                $0.dateFormat = Date.lemmyDateFormat
            }
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Constants.userdata)
        }
    }

    var jwtToken: String? {
        loginData.jwtToken
    }
}