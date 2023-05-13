//
//  Manager.swift
//  Geist
//
//  Created by Ümit Gül on 12.05.23.
//

import BigInt
import Foundation
import web3swift
import Web3Core

enum TxError: Error {
    case encodingFailed
}

final class Manager {
    static let shared = Manager()
    let accountProvider = AccountProvider()
    let linkBuilder = LinkBuilder()

    var balanceProvider: BalanceProvider!
    var provider: Web3Provider!

    var senderAccount: Wallet!
    var receiverAccount: Wallet!

    func configSender() async {
        let account = try! accountProvider.createSenderAccount()
        self.senderAccount = account
        self.provider = await Web3Provider(with: senderAccount, chain: EtherumNetwork.localhost)
        self.balanceProvider = BalanceProvider(provider: provider)
    }

    func configReceiver() async {
        let account = try! accountProvider.createReceiverAccount()
        self.receiverAccount = account
        self.provider = await Web3Provider(with: receiverAccount, chain: EtherumNetwork.mainnet)
        self.balanceProvider = BalanceProvider(provider: provider)
    }
}

/// READ

extension Manager {}

/// WRITE

extension Manager {

    func signMessage() {}

    func transfer() async {
        let accountContract = EthereumAddress("0xe7f1725e7734ce288f8367e1bb143e90bb3f0512")
        let gho = EthereumAddress("0x5FbDB2315678afecb367f032d93F642f64180aa3")!
        let amount = Utilities.parseToBigUInt("10", units: .ether)
        print(amount)
        let parameters = [gho.address, amount] as [AnyObject]
        let web3Provider = provider.web3.provider
        let contract = provider.web3.contract(Web3.Utils.erc20ABI, at: gho)!
        let writeOperation = contract.createWriteOperation("transfer", parameters: parameters)!
        var tx = writeOperation.transaction
        tx.from = senderAccount.address
        tx.chainID = provider.web3.provider.network!.chainID
        print(tx)
        let hash = await sendTx(tx)
        print(hash ?? "n/a", "---")
    }

    func depositGho() async {
//        await transfer()
//        return

        let accountContract = EthereumAddress(Constants.aliceSender)
        let gho = EthereumAddress(Tokens.GHO)!
        let amount = Utilities.parseToBigUInt("10", units: .ether)
        let parameters = [senderAccount.address, gho.address, amount] as [AnyObject]
        let web3Provider = provider.web3.provider
        let contract = provider.web3.contract(GeistContract.abi, at: accountContract)!
        let writeOperation = contract.createWriteOperation("depositToken", parameters: parameters)!
        var tx = writeOperation.transaction
        tx.from = senderAccount.address
        tx.chainID = provider.web3.provider.network!.chainID
        print(tx)
        let hash = await sendTx(tx)
        print(hash ?? "n/a", "---")
    }

    func sendTx(_ transaction: CodableTransaction) async -> String? {
        do {
            let web3Provider = provider.web3.provider
            let keystore = web3Provider.attachedKeystoreManager!
            var tx = transaction
            // resolve - to determine nonce + gas
            let resolver = PolicyResolver(provider: provider.web3.provider)
            try await resolver.resolveAll(for: &tx)
            print(tx.gasLimit, tx.gasPrice)
            tx.gasPrice = BigUInt(1000000000)
            print(tx)
            // sign + encode
            let password = AccountProvider.accountPassword
            try Web3Signer.signTX(transaction: &tx, keystore: keystore, account: tx.from!, password: password)
            guard let encodedTx = tx.encode() else {
                throw TxError.encodingFailed
            }
            let res = try await provider.web3.eth.send(raw: encodedTx)
            print(res, "tx.hash")
            return res.hash
        } catch {
            print("Error sending tx: \(error)")
            return nil
        }
    }
}
