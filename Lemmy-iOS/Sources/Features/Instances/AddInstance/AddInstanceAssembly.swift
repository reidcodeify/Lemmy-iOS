//
//  AddInstanceAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import UIKit

final class AddInstanceAssembly: Assembly {
    
    var completionHandler: (() -> Void)?
    
    func makeModule() -> UINavigationController {
        let viewModel = AddInstanceViewModel(userAccountService: UserAccountService())
        let vc = AddInstanceViewController(viewModel: viewModel)
        let navController = UINavigationController(
            rootViewController: vc
        )
        completionHandler = vc.completionHandler

        viewModel.viewController = vc
        
        return navController
    }
}