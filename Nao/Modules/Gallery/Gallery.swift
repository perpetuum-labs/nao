struct Gallery {
    let view: GalleryView
    let callback: GalleryCallback?
}

protocol GalleryCallback { }

struct GalleryViewState {
    let errorMessage: String?
    let isActivityIndicatorAnimating: Bool
    let commands: [NaoCommand]

    init(
        errorMessage: String? = nil,
        isActivityIndicatorAnimating: Bool = false,
        commands: [NaoCommand]
    ) {
        self.errorMessage = errorMessage
        self.isActivityIndicatorAnimating = isActivityIndicatorAnimating
        self.commands = commands
    }
}

enum GalleryResult {
    case showControl(NaoDevice)
    case disconnected
    case sending
    case sent
    case error(_: Error)

    func reduce(previousState: GalleryViewState) -> GalleryViewState {
        switch self {
        case .error(let error):
            return GalleryViewState(errorMessage: error.localizedDescription, commands: Nao.Command.posture)
        case .sending:
            return GalleryViewState(isActivityIndicatorAnimating: true, commands: Nao.Command.posture)
        default:
            return GalleryViewState(commands: Nao.Command.posture)
        }
    }
}
