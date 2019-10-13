import RxSwift
import Foundation

public protocol OptionalType {
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

extension Observable where Element: OptionalType {
    struct EmptyElementError: Swift.Error { }
    
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
    
    func errorOnNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.error(EmptyElementError())
        }
    }
}

extension ObservableType where Element == (response: HTTPURLResponse, data: Data) {
    func validate() -> Observable<Element> {
        return flatMap({ response -> Observable<Element> in
            switch response.response.statusCode {
            case 200:
                return .just(response)
            default:
                let message = HTTPURLResponse.localizedString(forStatusCode: response.response.statusCode)
                return .error(NaoError.invalidStatusCode(response.response.statusCode, message: message))
            }
        })
    }
}

extension ObservableType where Element == (response: HTTPURLResponse, data: Data) {
    func map<T>() -> Observable<T> where T: Decodable {
        return flatMap { response -> Observable<T> in
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return .just(try decoder.decode(T.self, from: response.data))
            } catch {
                return .error(NaoError.decodingError(error.localizedDescription))
            }
        }
    }
}
