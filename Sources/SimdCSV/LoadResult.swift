//
//  LoadResult.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

public class LoadResult {
    public let status: LoadStatus
    public let csv: ParseCSV
    init(status: LoadStatus = LoadStatus.OK, csv: ParseCSV = ParseCSV()) {
        self.status = status
        self.csv = csv
    }

    init() {
        self.status = LoadStatus.Failed
        self.csv = ParseCSV()
   }
}
