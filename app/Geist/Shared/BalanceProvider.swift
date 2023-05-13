//
//  BalanceProvider.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import BigInt
import Foundation
import web3swift
import Web3Core

enum BalanceError: Error {
    case notFound
}

final class BalanceProvider {
    private let provider: Web3Provider

    init(provider: Web3Provider) {
        self.provider = provider
    }

    func balanceOf(erc20Token: EthereumAddress, for address: EthereumAddress) async -> BigUInt {
        let result = await readContract(erc20Token, account: address.address.lowercased())
        return (try? result.get()) ?? BigUInt(0)
    }
}

// MARK: - Read Contract

extension BalanceProvider {

    private func readContract(_ contractAddress: EthereumAddress, account: String) async -> Result<BigUInt,  Error> {
        guard let contract = provider.web3.contract(Web3.Utils.erc20ABI, at: contractAddress) else { return .failure(BalanceError.notFound) }
        do {
            let readOp = contract.createReadOperation("balanceOf", parameters: [account as AnyObject])!
            let response = try await readOp.callContractMethod()
            let balance = (response["balance"] as? BigUInt) ?? BigUInt(0)
            return .success(balance)
        } catch {
            print("Error - reading balanceOf", error)
            return .failure(BalanceError.notFound)
        }
    }
}
