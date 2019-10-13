struct Intro {
    let view: IntroView
    let callback: IntroCallback
}

protocol IntroCallback { }

struct IntroViewState {
    var index: Int
    var title: String
    var currentSlide: IntroSlideViewModel? {
        return index < slides.count ? slides[index] : nil
    }
    let slides: [IntroSlideViewModel] = IntroSlideViewModel.slides
    
    init(index: Int = 0, title: String = TextContent.Intro.title) {
        self.index = index
        self.title = title
    }
}

enum IntroResult {
    case ready
    case swiped(_ index: Int)
    func reduce(_ previousState: IntroViewState) -> IntroViewState {
        switch self {
        case .swiped(let index):
            return IntroViewState(index: index)
        default:
            return previousState
        }
    }
}
