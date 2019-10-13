import RxSwift

struct SetUp {
    let view: SetUpView
    let callback: SetUpCallback
}

struct SetUpInfo {
    let ip: String
    let port: UInt16
}

protocol SetUpCallback {
    func connected() -> Observable<NaoDevice>
}

struct SetUpViewState {
    var isSetUpButtonEnabled: Bool
    var ipAddressEvaluated: Bool
    var ipAddressValidationErrorMessage: String?
    var connectionErrorMessage: String?
    var isActivityIndicatorAnimating: Bool
    
    init(isSetUpButtonEnabled: Bool = false,
         ipAddressEvaluated: Bool = false,
         ipAddressValidationErrorMessage: String? = nil,
         connectionErrorMessage: String? = nil,
         isActivityIndicatorAnimating: Bool = false) {
        self.isSetUpButtonEnabled = isSetUpButtonEnabled
        self.ipAddressEvaluated = ipAddressEvaluated
        self.ipAddressValidationErrorMessage = ipAddressValidationErrorMessage
        self.connectionErrorMessage = connectionErrorMessage
        self.isActivityIndicatorAnimating = isActivityIndicatorAnimating
    }
}

enum SetUpResult {
    typealias ValidationResult = Result<ValidationError>
    
    case ipAddressValidation(_ result: ValidationResult)
    case connecting
    case connected(device: NaoDevice)
    case connectionError(error: Error)
    case dismiss
    
    func reduce(previousState: SetUpViewState) -> SetUpViewState {
        switch self {
        case .ipAddressValidation(let result):
            var state = previousState
            state.isSetUpButtonEnabled = result.isSuccess
            state.ipAddressEvaluated = true
            state.ipAddressValidationErrorMessage = result.underlyingError?.message
            state.connectionErrorMessage = nil
            return state
        case .connectionError(let error):
            return SetUpViewState(connectionErrorMessage: error.localizedDescription)
        case .connecting:
            return SetUpViewState(isActivityIndicatorAnimating: true)
        default:
            return previousState
        }
    }
}
