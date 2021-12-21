import UIKit

class TutorialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    func setupView() {
        view.backgroundColor = .clear
    }
    func setupConstraints() {
        let TutorialView = TutorialView()
        // 4. Add subviews
        view.addSubview(TutorialView.dimmedView)
        view.addSubview(TutorialView.containerView)
        TutorialView.dimmedView.translatesAutoresizingMaskIntoConstraints = false
        TutorialView.containerView.translatesAutoresizingMaskIntoConstraints = false
        // 5. Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            TutorialView.dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            TutorialView.dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            TutorialView.dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            TutorialView.dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            TutorialView.containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            TutorialView.containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        // 6. Set container to default height
        TutorialView.containerViewHeightConstraint = TutorialView.containerView.heightAnchor.constraint(equalToConstant: TutorialView.defaultHeight)
        // 7. Set bottom constant to 0
        TutorialView.containerViewBottomConstraint = TutorialView.containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        // Activate constraints
        TutorialView.containerViewHeightConstraint?.isActive = true
        TutorialView.containerViewBottomConstraint?.isActive = true
        TutorialView.tutorialGif.frame = CGRect(
            x: self.view.frame.size.width*0.3,
            y: self.view.frame.size.height*0.1,
            width: self.view.frame.size.width*0.4,
            height: self.view.frame.size.height*0.4
        )
        TutorialView.title.frame = CGRect(
            x: self.view.frame.size.width*0.0,
            y: self.view.frame.size.height*0.0,
            width: self.view.frame.size.width*1.0,
            height: self.view.frame.size.height*0.05
        )
        TutorialView.explanation.frame = CGRect(
            x: self.view.frame.size.width*0.0,
            y: self.view.frame.size.height*0.5,
            width: self.view.frame.size.width*1.0,
            height: self.view.frame.size.height*0.2
        )
        TutorialView.dismissbutton.frame = CGRect(
            x: self.view.frame.size.width * 0.9,
            y: self.view.frame.size.height * 0.0,
            width: self.view.frame.size.width * 0.1,
            height: self.view.frame.size.height * 0.05
        )
        TutorialView.dismissbutton.addTarget(self, action: #selector(didTapDismissButton(_ :)), for: .touchUpInside)
        TutorialView.containerView.addSubview(TutorialView.tutorialGif)
        TutorialView.containerView.addSubview(TutorialView.title)
        TutorialView.containerView.addSubview(TutorialView.explanation)
        TutorialView.containerView.addSubview(TutorialView.dismissbutton)
    }
    
    @objc func didTapDismissButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
