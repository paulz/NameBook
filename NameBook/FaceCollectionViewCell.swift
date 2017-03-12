import UIKit
import Contacts

class FaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoView: UIImageView!
    func configure(with contact: CNContact) {
        if let imageData = contact.thumbnailImageData {
            photoView.image = UIImage(data: imageData)
        }
    }

    func showResult(correct:Bool) {
        
    }
}
