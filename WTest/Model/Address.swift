//
//  Address.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation
import CodableCSV

public struct Address: Codable {
    let postalCodeNumber: Int
    let postalCodeExtension: Int
    let designation: String

    enum CodingKeys: String, CodingKey {
        case postalCodeNumber = "num_cod_postal"
        case postalCodeExtension = "ext_cod_postal"
        case designation = "desig_postal"
    }
}
