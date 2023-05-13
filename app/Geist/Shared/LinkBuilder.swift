//
//  LinkBuilder.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import Foundation

final class LinkBuilder {

    enum LinkStyle {
        case universal
        case deeplink
    }

    private let universalLinkHost: String = "https://eth-global-lisboa.vercel.app/"
    private let deeplink: String = "geist://"
    private let keyword: String = "claim"

    func generateLink(for id: String, linkStyle: LinkStyle) -> String {
        switch linkStyle {
        case .universal:
            return "\(universalLinkHost)/\(keyword)?\(id)"
        case .deeplink:
            return "\(deeplink)\(keyword)?\(id)"
        }
    }

    func parseLink(_ link: String) {}
}
