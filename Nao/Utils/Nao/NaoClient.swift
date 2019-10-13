import RxSwift
import Foundation

protocol HasNaoClient {
    var naoClient: NaoClient { get }
}

protocol NaoClient {
    func dispatch(_: NaoCommand) -> Observable<Nao.Response.Simple>
}

class NaoClientImpl: NaoClient {
    private let url: URL
    private let session: URLSession
    
    init(url: URL, session: URLSession = URLSession(configuration: .default)) {
        self.url = url
        self.session = session
    }
    
    private func send<T: Decodable>(_ request: URLRequestConvertible) -> Observable<T> {
        return Observable.just(request)
            .flatMap { [unowned self] in
                self.session.rx
                    .response(request: $0.request(url: self.url))
                    .validate()
            }
            .map()
            .observeOn(MainScheduler.instance)
    }
    
    func dispatch(_ command: NaoCommand) -> Observable<Nao.Response.Simple> {
        return send(command)
    }
}
