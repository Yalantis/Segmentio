import UIKit

@IBDesignable
class RoundImageView: UIImageView {
    
    override var bounds: CGRect {
        didSet {
            updateCornerRadiusValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateCornerRadiusValue()
    }
    
    fileprivate func updateCornerRadiusValue() {
        let cornerRadius = min(bounds.size.height, bounds.size.width) / 2
        layer.cornerRadius = cornerRadius
    }
    
}
