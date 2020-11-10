//
//  ProfileScreenPostsTableDataSource.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProfileScreenPostsTableDataSource: NSObject {
    var viewModels: [LemmyModel.PostView]

    init(viewModels: [LemmyModel.PostView] = []) {
        self.viewModels = viewModels
        super.init()
    }
    

    func update(viewModel: LemmyModel.PostView) {
        if let index = self.viewModels.firstIndex(where: { $0.id == viewModel.id }) {
            self.viewModels[index] = viewModel
        }
    }
}

extension ProfileScreenPostsTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostContentTableCell = tableView.cell(forRowAt: indexPath)
        cell.updateConstraintsIfNeeded()

        let viewModel = self.viewModels[indexPath.row]
        cell.bind(with: viewModel, config: .default)

        return cell
    }
}