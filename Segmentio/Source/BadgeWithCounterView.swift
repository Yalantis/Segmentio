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
        return UINib(nibName: nibName, bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! BadgeWithCounterView
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