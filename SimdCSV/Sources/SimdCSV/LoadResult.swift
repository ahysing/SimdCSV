//
//  LoadResult.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

public class LoadResult {
    private let status: LoadStatus
    
    init(status :LoadStatus = LoadStatus.OK) {
        self.status = status
    }
}
