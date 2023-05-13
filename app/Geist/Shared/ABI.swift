//
//  ABI.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import Foundation

struct GeistContract {
    static let abi: String = "[{\"inputs\": [{\"internalType\": \"address\",\"name\": \"benficiary\",\"type\": \"address\"},{\"internalType\": \"contract ERC20\",\"name\": \"token\",\"type\": \"address\"},{\"internalType\": \"uint256\",\"name\": \"amount\",\"type\": \"uint256\"}],\"stateMutability\": \"nonpayable\",\"type\": \"function\",\"name\": \"depositToken\"}]"
}
