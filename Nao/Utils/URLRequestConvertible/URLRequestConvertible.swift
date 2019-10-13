import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol URLRequestConvertible {
    var method: HTTPMethod { get }
    var pathComponents: [String: String] { get }
}

extension URLRequestConvertible {
    var pathComponents: [String: String] { return [:] }
    var method: HTTPMethod { return .GET }
    
    func request(url: URL) -> URLRequest {
        var urlComponents = URLComponents(string: url.absoluteString)
        urlComponents?.queryItems = pathComponents.map { URLQueryItem(name: $0.key, value: $0.value) }
        var request = URLRequest(url: urlComponents?.url ?? url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 20.0
        return request
    }
}
