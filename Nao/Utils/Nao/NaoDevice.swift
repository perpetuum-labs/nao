import Foundation

protocol NaoDevice: HasNaoClient { }

class NaoDeviceImpl: NaoDevice {
    let naoClient: NaoClient
    
    init(url: URL) {
        self.naoClient = NaoClientImpl(url: url)
    }
}
