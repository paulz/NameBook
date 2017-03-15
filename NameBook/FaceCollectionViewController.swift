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
        let orgContacts = contactsService.getContacts(serviceName: "Namely")
        gameController = GameController(contacts: orgContacts)
        play()
    }

    func dismissContact() {
        presentedViewController?.dismiss(animated: true, completion: {
            self.collectionView.reloadData()
        })
    }

    @IBAction func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began){
            let locationInView = sender.location(in: self.collectionView)

            if let indexPath = collectionView.indexPathForItem(at: locationInView) {
                if let controller = contactsService.editContact(identifier: gameController.choices[indexPath.row]) {
                    controller.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                                  target: self,
                                                                                  action: #selector(dismissContact))
                    present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
                }
            }
        }
    }

    func play()  {
        gameController.nextRound()
        collectionView.reloadData()
        let correct = contactsService.contact(identifier:gameController.correctChoice())!
        let nickname = correct.nickname
        let fullName = CNContactFormatter.string(from: correct, style: .fullName)
        if !nickname.isEmpty && nickname != correct.givenName {
            nameToGuess.text = correct.nickname
            fullNameLabel.text = fullName
        } else {
            nameToGuess.text = fullName
            fullNameLabel.text = nil
        }
    }

    func dimIncorrect() {
        for visible in collectionView.indexPathsForVisibleItems {
            if visible.row != gameController.correct {
                if let cell = collectionView.cellForItem(at: visible) {
                    cell.contentView.alpha = 0
                    cell.isHighlighted = false
                }
            }
        }
    }
    
    func restoreDimmed() {
        _ = collectionView.visibleCells.map{$0.contentView.alpha = 1}
    }

    func flashCorrect(onComplete:@escaping ()->()) {
        UIView.animate(withDuration: 1.25, animations: {
            self.dimIncorrect()
        }, completion: { _ in
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
            self.restoreDimmed()
            onComplete()
        })
    }
}

extension FaceCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)

        let cell = collectionView.cellForItem(at: indexPath) as! FaceCollectionViewCell
        let correct = gameController.isCorrect(selection: indexPath.row)
        cell.showResult(correct: correct) {
            if !correct {
                collectionView.deselectItem(at: indexPath, animated: true)
                self.flashCorrect {
                    self.play()
                }
            } else {
                self.play()
            }
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
        cell.configure(with: contactsService.contact(identifier: gameController.choices[indexPath.row])!)
        return cell
    }
}
