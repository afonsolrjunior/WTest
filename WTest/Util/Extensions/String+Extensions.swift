//
//  String+Extensions.swift
//  WTest
//
//  Created by afonso.junior on 25/05/22.
//

import Foundation

public extension String {

    var isNumber: Bool {
        self.allSatisfy({ $0.isWholeNumber })
    }

}
