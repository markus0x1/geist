//
//  LinkBuilder.swift
//  Geist
//
//  Created by Jann Driessen on 13.05.23.
//

import Foundation

final class LinkBuilder {

    private let scheme = "https://"
    private let universalLinkHost = "eth-global-lisboa.vercel.app"
    private let keyword = "claim"

    func generateLink(for id: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "eth-global-lisboa.vercel.app"
        components.path = "/claim"

        components.queryItems = [
            URLQueryItem(name: "id", value: "\(id)"),
        ]

        guard let url = components.url else {
            fatalError("Could not create URL from components")
        }

        print("Created URL: \(url)")

        return url
    }

    func parseLink(_ link: String) {}
}
