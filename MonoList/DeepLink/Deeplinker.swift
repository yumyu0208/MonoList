//
//  Deeplinker.swift
//  MonoList
//
//  Created by 竹田悠真 on 2022/02/21.
//

import Foundation

class Deeplinker {
    enum Deeplink: Equatable {
        case home
        case list(reference: String)
        case newList
        
        var referenceId: String? {
            switch self {
            case .list(let reference):
                return reference
            default:
                return nil
            }
        }
    }
    
    func manage(url: URL) -> Deeplink? {
        guard url.scheme == K.url.scheme else { return nil }
        let pathComponents = url.pathComponents
        print(pathComponents)
        if pathComponents.contains(K.url.listPath) {
            guard let query = url.query else { return nil }
            let components = query.split(separator: ",").flatMap { $0.split(separator: "=")}
            guard let idIndex = components.firstIndex(of: Substring(K.url.referenceQueryName)) else { return nil }
            guard idIndex + 1 < components.count else { return nil }
            return .list(reference: String(components[idIndex.advanced(by: 1)]))
        } else if pathComponents.contains(K.url.newListPath) {
            return .newList
        } else {
            return .home
        }
    }
}
