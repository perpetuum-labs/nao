import UIKit

struct IntroSlideViewModel {
    var title: String
    var image: UIImage
    var description: String
    var showsLink: Bool
    var buttonTitle: String
    static var numberOfSlides: Int { return slides.count }
    
    static var slides: [IntroSlideViewModel] {
        return [IntroSlideViewModel(title: TextContent.Intro.Slide.One.title,
                                    image: UIImage.assetName(ImageContent.introOne)!,
                                    description: TextContent.Intro.Slide.One.description,
                                    showsLink: false,
                                    buttonTitle: TextContent.Intro.Slide.One.buttonTitle),
                IntroSlideViewModel(title: TextContent.Intro.Slide.Two.title,
                                    image: UIImage.assetName(ImageContent.introTwo)!,
                                    description: TextContent.Intro.Slide.Two.description,
                                    showsLink: true,
                                    buttonTitle: TextContent.Intro.Slide.Two.buttonTitle),
                IntroSlideViewModel(title: TextContent.Intro.Slide.Three.title,
                                    image: UIImage.assetName(ImageContent.introThree)!,
                                    description: TextContent.Intro.Slide.Three.description,
                                    showsLink: false,
                                    buttonTitle: TextContent.Intro.Slide.Three.buttonTitle)]
    }
}
