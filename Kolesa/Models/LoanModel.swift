//
//  LoanModel.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 16.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

struct LoanModel {

    var initialFee: String?
    var loanData: [DictionaryModel]?
    
    init(initialFee: String?, loanData: [DictionaryModel]?) {
        self.initialFee = initialFee
        self.loanData = loanData
    }
}
