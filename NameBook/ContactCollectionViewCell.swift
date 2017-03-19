import UIKit
import Contacts

class ContactCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    func configure(with contact: CNContact) {
        if let imageData = contact.thumbnailImageData {
            photoView.image = UIImage(data: imageData)
        } else {
            photoView.image = nil
        }
        let nickname = contact.nickname
        let fullName = CNContactFormatter.string(from: contact, style: .fullName)
        if !nickname.isEmpty && nickname != contact.givenName {
            nameLabel.text = nickname
        } else {
            nameLabel.text = fullName
        }
    }
}
