//
//  LoadResult.swift
//  
//
//  Created by Andreas Dreyer Hysing on 27/03/2020.
//

public class LoadResult {
    public let status: LoadStatus
    public var csv: ParseCSV
    public init(status: LoadStatus = LoadStatus.ok, csv: ParseCSV = ParseCSV()) {
        self.status = status
        self.csv = csv
    }

    public init() {
        self.status = LoadStatus.ready
        self.csv = ParseCSV()
   }
}
