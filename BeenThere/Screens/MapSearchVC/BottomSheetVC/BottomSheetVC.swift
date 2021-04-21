//
//  BottomSheetVC.swift
//  BT_CoreData
//
//  Created by Peyton Shetler on 1/22/21.
//

import UIKit
import MapKit

protocol addButtonDelegate {
    func addButtonTapped()
}


class BottomSheetVC: UIViewController {
    
    
    let mainStackView = UIStackView()
    let shadowImage = UIView()
    
    let nameAndButtonStackView = UIStackView()
    let nameLabel = UILabel()
    let addButton = UIButton()
    
    let separatorView = UIView()
    let separator = UIView()
    
    let addressStackView = UIStackView()
    let addressImageView = UIImageView()
    let addressLabel = UILabel()
    
    let phoneNumberStackView = UIStackView()
    let phoneImageView = UIImageView()
    let phoneNumberLabel = UILabel()
    
    let urlStackView = UIStackView()
    let urlImageView = UIImageView()
    let urlLabel = UILabel()
    
    
    var views: [UIView] = []
    
    var delegate: addButtonDelegate?
    
    var item: MKMapItem? {
        didSet {
            if item != nil {
                
                nameLabel.text = item!.name
                addressLabel.text = Helpers.Location.parseAddress(selectedItem: item!.placemark, format: "%@%@%@%@%@%@%@%@")
                phoneNumberLabel.text = item!.phoneNumber ?? "n/a"
                urlLabel.text = item!.url?.absoluteString ?? "n/a"
                
                moveView(state: .full)
            }
        }
    }
    
    init(delegate: addButtonDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundViews()
        layoutUI()
    }

    
    @objc func addButtonTapped() {
        delegate?.addButtonTapped()
    }

    
    func moveView(state: State) {
        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
    }

    func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        if (minY + translation.y >= Constant.fullViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
}


extension BottomSheetVC {
    
    enum State {
        case partial
        case full
    }
    
    enum Constant {
        static var fullViewYPosition: CGFloat { UIScreen.main.bounds.height * 0.6 }
        static var partialViewYPosition: CGFloat { UIScreen.main.bounds.height - 140 }
    }
}
