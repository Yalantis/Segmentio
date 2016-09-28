import Foundation

private let BadgeCounterMaxValue = 99
private let BadgeCounterOverMaxValueText = "99+"
private let standardSizedNibName = "BadgeWithCounterViewStandardSized"
private let bigSizedNibName = "BadgeWithCounterViewBigSized"

enum CounterBadgeSize {
    case Standard
    case Big
}

class BadgeWithCounterView: UIView {
    
    @IBOutlet private weak var counterValueLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    
    class func instanceFromNib(size size: CounterBadgeSize) -> BadgeWithCounterView {
        let nibName = nibNameForSize(size)
        let podBundle = NSBundle(forClass: self.classForCoder())
        
        if let bundleURL = podBundle.URLForResource("Segmentio", withExtension: "bundle"), bundle = NSBundle(URL: bundleURL) {
            return UINib(nibName: nibName, bundle: bundle).instantiateWithOwner(nil, options: nil)[0] as! BadgeWithCounterView
        }
        return BadgeWithCounterView(frame: CGRectZero)
    }

    func setBadgeCounterValue(counterValue: Int) {
        var counterText: String!
        if counterValue > BadgeCounterMaxValue {
            counterText = BadgeCounterOverMaxValueText
        } else {
            counterText = String(counterValue)
        }
        counterValueLabel.text = counterText
    }
    
    func setBadgeBackgroundColor(color: UIColor) {
        backgroundImageView.backgroundColor = color
    }
    
    private class func nibNameForSize(size: CounterBadgeSize) -> String {
        return (size == .Standard) ? standardSizedNibName : bigSizedNibName
    }
    
}