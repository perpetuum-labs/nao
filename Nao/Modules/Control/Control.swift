struct ControlModule {
    let view: ControlView
    let callback: ControlCallback
}

protocol ControlCallback { }

struct ControlViewState {
    let errorMessage: String?
    let isActivityIndicatorAnimating: Bool
    let commands: [NaoCommand]
    
    init(errorMessage: String? = nil,
         isActivityIndicatorAnimating: Bool = false,
         commands: [NaoCommand]) {
        self.errorMessage = errorMessage
        self.isActivityIndicatorAnimating = isActivityIndicatorAnimating
        self.commands = commands
    }
}

enum ControlResult {
    case sending
    case sent
    case error(_: Error)
    func reduce(previousState: ControlViewState) -> ControlViewState {
        switch self {
        case .error(let error):
            return ControlViewState(errorMessage: error.localizedDescription, commands: Nao.Command.posture)
        case .sending:
            return ControlViewState(isActivityIndicatorAnimating: true, commands: Nao.Command.posture)
        default:
            return ControlViewState(commands: Nao.Command.posture)
        }
    }
}
