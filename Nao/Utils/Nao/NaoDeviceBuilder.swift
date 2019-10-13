import Foundation

protocol HasNaoDeviceBuilder {
    var naoDeviceBuilder: NaoDeviceBuilder { get }
}

enum DeviceBuilderError: Swift.Error {
    case invalidUrl
}

protocol NaoDeviceBuilder {
    func build(with: String, port: UInt16) throws -> NaoDevice
}

class NaoDeviceBuilderImpl: NaoDeviceBuilder {
    func build(with ip: String, port: UInt16) throws -> NaoDevice {
        guard let url = URL(string: "http://"+ip+":\(port)") else { throw DeviceBuilderError.invalidUrl }
        return NaoDeviceImpl(url: url)
    }
}
