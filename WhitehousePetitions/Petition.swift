//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Rodrigo Cavalcanti on 16/04/24.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
    var deadline: Double
}

extension Petition {
    var deadlineDate: Date {
        Date(timeIntervalSince1970: deadline)
    }
}
