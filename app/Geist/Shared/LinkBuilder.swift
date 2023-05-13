//
//  LinkBuilder.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import Foundation

final class UrlBuilder {
    private let host: String = "https://geist.xyz"
    private let keyword: String = "claim"

    func generateLink(for id: String) -> String {
        let url = "\(host)/\(keyword)?\(id)"
        return url
    }

    func parseUrl(_ url: String) {}
}
