//
//  AccountProvider.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import Foundation
import web3swift
import Web3Core

enum AccountProviderError: Error {
    case invalidEntropy
    case generatingMnemonicsFailed
    case generatingWalletFailed
}

final class AccountProvider {
    // TODO: change in production
    static let accountPassword = "geist"
    // 128 - 12 words
    private let bitsOfEntropy: Int = 128

    // Returns mnemonics on succes
    func createAccount() throws -> String  {
        do {
            guard let mnemonics = try BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy) else {
                throw AccountProviderError.invalidEntropy
            }
            // This just checks if we can succesfully create a wallet from the mnemonics
            guard let _ = Wallet(type: .BIP39(mnemonic: mnemonics, password: AccountProvider.accountPassword)) else {
                throw AccountProviderError.generatingWalletFailed
            }
            return mnemonics
        } catch {
            print("Error generating mnemonics: \(error)")
            throw AccountProviderError.generatingMnemonicsFailed
        }
    }

    // Returns wallet if successfully created, throws error otherwise
    func importAccount(mnemonics: String) throws -> Wallet {
        // This just checks if we can succesfully create a wallet from the mnemonics
        guard let wallet = Wallet(type: .BIP39(mnemonic: mnemonics, password: AccountProvider.accountPassword)) else {
            throw AccountProviderError.generatingWalletFailed
        }
        return wallet
    }

    // Returns wallet if successfully created, throws error otherwise
    func importAccount(privateKey: String) throws -> Wallet {
        // This just checks if we can succesfully create a wallet from the mnemonics
        guard let wallet = Wallet(type: .EthereumKeystoreV3(privateKey: privateKey, password: AccountProvider.accountPassword)) else {
            throw AccountProviderError.generatingWalletFailed
        }
        return wallet
    }
}

// MARK: - Convenience

extension AccountProvider {
    func createSenderAccount() throws -> Wallet {
        let wallet = try! importAccount(privateKey: Constants.privateKey0)
        print("Created sender account:", wallet.addressRaw)
        return wallet
    }

    func createReceiverAccount() throws -> Wallet {
        let wallet = try! importAccount(privateKey: Constants.privateKey1)
        print("Created receiver account:", wallet.addressRaw)
        return wallet
    }
}

struct Wallet {

    enum WalletType {
        case BIP39(mnemonic: String, password: String)
        case EthereumKeystoreV3(privateKey: String, password: String)
    }

    let address: EthereumAddress
    let addressRaw: String
    let data: Data
    let isHD: Bool

    init?(type: WalletType) {
        switch type {
        case .EthereumKeystoreV3(privateKey: let privateKey, password: let password):
            let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let dataKey = Data.fromHex(formattedKey) else { return nil }
            do {
                guard let keystore = try EthereumKeystoreV3(privateKey: dataKey, password: password),
                      let addressRaw =  keystore.addresses?.first?.address,
                      let address = EthereumAddress(addressRaw) else { return nil }
                self.address = address
                self.addressRaw = addressRaw
                self.data = try JSONEncoder().encode(keystore.keystoreParams)
                self.isHD = false
            } catch {
                print("Error creating wallet", error)
                return nil
            }
        case .BIP39(mnemonic: let mnemonic, password: let password):
            do {
                guard let keystore = try BIP32Keystore(
                    mnemonics: mnemonic,
                    password: password,
                    mnemonicsPassword: "",
                    language: .english
                ) else { return nil }
                guard let addressRaw =  keystore.addresses?.first?.address,
                      let address = EthereumAddress(addressRaw) else { return nil }
                self.address = address
                self.addressRaw = addressRaw
                // Mostly needed for Web3Provider + PK export
                self.data = try JSONEncoder().encode(keystore.keystoreParams)
                self.isHD = true
            } catch {
                print("Error creating wallet", error)
                return nil
            }
        }
    }
}

extension Wallet {
    var addressFormattedShort: String {
        return "\(String(addressRaw.prefix(6)))...\(String(addressRaw.suffix(4)))"
    }
}
