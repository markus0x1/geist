//
//  Web3Provider.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import BigInt
import Foundation
import web3swift
import Web3Core

class Web3Provider {
    let chain: Network
    let web3: Web3

    init?(with wallet: Wallet, chain: Network) async {
        do {
            let provider = try await Web3HttpProvider(url: chain.rpcUrl, network: Networks.Custom(networkID: BigUInt(chain.chainId.rawValue)))
            self.chain = chain
            self.web3 = web3swift.Web3(provider: provider)
            guard let keystoreManager = Web3Provider.getKeystoreManager(for: wallet) else {
                print("Error initializing web3 provider - can not init keystore")
                return nil
            }
            web3.addKeystoreManager(keystoreManager)
        } catch {
            return nil
        }
    }
}

// MARK: - Keystore

extension Web3Provider {

    static func getKeystoreManager(for wallet: Wallet) -> KeystoreManager? {
        let data = wallet.data

        if wallet.isHD {
            guard let keystore = BIP32Keystore(data) else { return nil }
            return KeystoreManager([keystore])
        } else {
            guard let keystore = EthereumKeystoreV3(data) else { return nil }
            return KeystoreManager([keystore])
        }
    }

}
