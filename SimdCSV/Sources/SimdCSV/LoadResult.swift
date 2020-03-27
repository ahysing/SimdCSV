//
//  File.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

import Foundation

enum LoadStatus {
    case OK
    case Failed
}

public class LoadResult {
    private let status: LoadStatus
    init(status :LoadStatus = LoadStatus.OK) {
        self.status = status;
    }
}
