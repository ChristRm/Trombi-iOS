//
//  TrombiApiRequests.swift
//  Trombi
//
//  Created by Chris Rusin on 11/24/18.
//  Copyright © 2018 Christian Rusin . All rights reserved.
//

import Foundation

/// HTTP method definitions.
///
/// See RFC https://tools.ietf.org/html/rfc7231#section-4.3
enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum TrombiApiRequests {

    static var baseUrl: String {
        return "https://trombi.corp.netatmo.com"// "https://trombi.mogmi.fr"
    }

    fileprivate static var defaultRequestTimeout: TimeInterval = TimeInterval(5.0)// 5 seconds

    case getPersons
    case getUsefulLinks
    case getTeams

    func asURLRequest() -> URLRequest {

        let requestData: (method: HTTPMethod, path: String, parameters: [String: AnyObject]?) = {
                switch self {
                case .getPersons:
                    return (.get, EndpointsHelper.Resource.getPersons, nil)
                case .getUsefulLinks:
                    return (.get, EndpointsHelper.Resource.getUsefulLinks, nil)
                case .getTeams:
                    return (.get, EndpointsHelper.Resource.getTeams, nil)
                }
        }()

        guard let requestUrl = URL(string: TrombiApiRequests.baseUrl + requestData.path) else {
            fatalError("Unable to genreate URL from invalid string")
        }

        var urlRequest = URLRequest(url: requestUrl,
                                    cachePolicy: .returnCacheDataElseLoad,
                                    timeoutInterval: TrombiApiRequests.defaultRequestTimeout)

        urlRequest.httpMethod = requestData.method.rawValue

        return urlRequest
    }
}

struct EndpointsHelper {

    static let prefix = ""

    enum Resource {
        static let getPersons = "/api/persons"
        static let getUsefulLinks = "/api/links"
        static let getTeams = "/api/teams"
    }
}
