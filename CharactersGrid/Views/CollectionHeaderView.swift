//
//  CollectionHeaderView.swift
//  CharactersGrid
//
//  Created by Wilson Leung on 3/3/2022.
//

import UIKit
import SwiftUI

class CollectionHeaderView: UICollectionReusableView {
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Xib/storyboard is not supported")
    }
    
    private func setupLayout() {
        textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        
        let padding: CGFloat = 16
        let trailingTextConstraint = textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        trailingTextConstraint.priority = .init(999)
        
        let bottomTextConstraint = textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        bottomTextConstraint.priority = .init(999)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            trailingTextConstraint,
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            bottomTextConstraint,
        ])
    }
    
    func configure(text: String) {
        textLabel.text = text
    }
}

struct CollectionHeaderViewRepresentable: UIViewRepresentable {
    let text: String
    
    func makeUIView(context: Context) -> CollectionHeaderView {
        let collectionHeaderView = CollectionHeaderView()
        collectionHeaderView.configure(text: text)
        return collectionHeaderView
    }
    
    func updateUIView(_ uiView: CollectionHeaderView, context: Context) {
    }
}

struct CollectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionHeaderViewRepresentable(text: "Heroes")
    }
}
