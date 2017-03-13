import UIKit
import Contacts

class FaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoView: UIImageView!
    func configure(with contact: CNContact) {
        resultLabel.alpha = 0
        if let imageData = contact.thumbnailImageData {
            photoView.image = UIImage(data: imageData)
        } else {
            photoView.image = nil
        }
    }
    @IBOutlet var resultLabel: UILabel!

    func showResult(correct:Bool, onComplete:@escaping ()->Void) {
        resultLabel.alpha = 0
        resultLabel.text = correct ? "✔︎" : "✘"
        resultLabel.textColor = correct ? UIColor.green : UIColor.red
        UIView.animate(withDuration: 0.25, animations: { 
            self.resultLabel.alpha = 1
        }) { _ in
            self.resultLabel.alpha = 0
            onComplete()
        }
    }
}
