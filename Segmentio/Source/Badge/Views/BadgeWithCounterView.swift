import UIKit

private let BadgeCounterMaxValue = 99
private let BadgeCounterOverMaxValueText = "99+"
private let standardSizedNibName = "BadgeWithCounterViewStandardSized"
private let bigSizedNibName = "BadgeWithCounterViewBigSized"

enum BadgeSize {
    
    case standard
    case big
    
}

class BadgeWithCounterView: UIView {
    
    @IBOutlet fileprivate weak var counterValueLabel: UILabel!
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    
    class func instanceFromNib(size: BadgeSize) -> BadgeWithCounterView {
        let nibName = nibNameForSize(size)
        #if SWIFT_PACKAGE
        let bundle: Bundle? = Bundle.module
        #else
        let podBundle = Bundle(for: self.classForCoder())
        let bundle = podBundle.url(forResource: "Segmentio", withExtension: "bundle").flatMap(Bundle.init(url:))
        #endif

        if let bundle = bundle, bundle.url(forResource: nibName, withExtension: "nib") != nil {
            return UINib(nibName: nibName, bundle: bundle)
                .instantiate(withOwner: nil, options: nil)[0] as! BadgeWithCounterView
        }
        return BadgeWithCounterView(frame: .zero)
    }

    func setBadgeCounterValue(_ counterValue: Int) {
        var counterText: String!
        if counterValue > BadgeCounterMaxValue {
            counterText = BadgeCounterOverMaxValueText
        } else {
            counterText = String(counterValue)
        }
        counterValueLabel.text = counterText
    }
    
    func setBadgeBackgroundColor(_ color: UIColor) {
        backgroundImageView.backgroundColor = color
    }
    
    fileprivate class func nibNameForSize(_ size: BadgeSize) -> String {
        return size == .standard ? standardSizedNibName : bigSizedNibName
    }
}
