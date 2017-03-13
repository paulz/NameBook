import UIKit
import Contacts

private let reuseIdentifier = "face cell"

class FaceCollectionViewController: UIViewController {
    var contactsService: ContactsService = ContactsService()
    var gameController: GameController!

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nameToGuess: UILabel!
    @IBOutlet var fullNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let orgContacts = contactsService.getContacts(organizationName: "Omada Health")
        gameController = GameController(contacts: orgContacts)
        play()
    }

    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if (sender.state != UIGestureRecognizerState.ended){
            return
        }
        let locationInView = sender.location(in: self.collectionView)

        if let indexPath = collectionView.indexPathForItem(at: locationInView) {
            if let controller = contactsService.editContact(contact: gameController.choices[indexPath.row]) {
                present(controller, animated: true, completion: nil)
            }
        }
    }

    func play()  {
        gameController.nextRound()
        collectionView.reloadData()
        let nickname = gameController.correct.nickname
        let fullName = CNContactFormatter.string(from: gameController.correct, style: .fullName)
        if !nickname.isEmpty && nickname != gameController.correct.givenName {
            nameToGuess.text = gameController.correct.nickname
            fullNameLabel.text = fullName
        } else {
            nameToGuess.text = fullName
            fullNameLabel.text = nil
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension FaceCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)

        let cell = collectionView.cellForItem(at: indexPath) as! FaceCollectionViewCell
        cell.showResult(correct: gameController.isCorrect(selection: indexPath.row)) {
            self.play()
        }
    }
}

extension FaceCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameController.choices.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FaceCollectionViewCell
        cell.configure(with: gameController.choices[indexPath.row])
        return cell
    }
}
