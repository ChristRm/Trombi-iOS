//
//  ShadowedImageView.swift
//  Trombi
//
//  Created by Christian Rusin on 10/05/2020.
//  Copyright © 2020 Christian Rusin . All rights reserved.
//

import UIKit
import SDWebImage

final class ShadowedImageView: UIView {

    private let imageView = UIImageView()
    private let imageShadowInnerView: UIView = UIView()
    
    private var topShadowViewConstraint: NSLayoutConstraint?
    private var bottomShadowViewConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    internal init() {
        super.init(frame: .zero)
        self.buildView()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initShadows()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = bounds.width * CGFloat(0.03)
        
        imageView.layer.cornerRadius = cornerRadius
        imageShadowInnerView.layer.cornerRadius = cornerRadius
        
//        topShadowViewConstraint?.constant = cornerRadius
//        bottomShadowViewConstraint?.constant = -cornerRadius
    }
    
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
    
    func setImage(with url: URL?, completed: SDExternalCompletionBlock?) {
//        self.imageView.sd_setImage(with: url, completed: { [weak self] _ -> () in
//            self?.layoutSubviews()
//        })
        
        self.imageView.sd_setImage(with: url) { [weak self] (image, error, type, url) in
            self?.layoutSubviews()
        }
    }
    
    // MARK: - Private
    private func buildView() {
        translatesAutoresizingMaskIntoConstraints = false

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
//        imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        let imageShadowView = UIView()
        imageShadowView.translatesAutoresizingMaskIntoConstraints = false
        imageShadowView.backgroundColor = .clear
        
        addSubview(imageShadowView)
        imageShadowView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageShadowView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        imageShadowView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        topShadowViewConstraint = imageShadowView.topAnchor.constraint(equalTo: topAnchor)
        topShadowViewConstraint?.isActive = true
        bottomShadowViewConstraint = imageShadowView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomShadowViewConstraint?.isActive = true

        imageShadowView.addSubview(imageShadowInnerView)
        imageShadowView.backgroundColor = .white
        
        imageShadowInnerView.translatesAutoresizingMaskIntoConstraints = false
        imageShadowInnerView.backgroundColor = .white
        
        imageShadowInnerView.widthAnchor.constraint(equalTo: imageShadowView.widthAnchor).isActive = true
        imageShadowInnerView.topAnchor.constraint(equalTo: imageShadowView.topAnchor).isActive = true
        imageShadowInnerView.bottomAnchor.constraint(equalTo: imageShadowView.bottomAnchor).isActive = true
        imageShadowInnerView.centerXAnchor.constraint(equalTo: imageShadowView.centerXAnchor).isActive = true
        
        bringSubviewToFront(imageView)
    }

    // MARK: - Private
    private func initShadows() {

        // shadow around image view
        imageShadowInnerView.layer.shadowColor = UIColor.black.cgColor
        imageShadowInnerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageShadowInnerView.layer.shadowOpacity = 0.4
        imageShadowInnerView.layer.shadowRadius = 5.0
    }
}
