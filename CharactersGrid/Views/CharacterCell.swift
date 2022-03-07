//
//  CharacterCell.swift
//  CharactersGrid
//
//  Created by Wilson Leung on 3/3/2022.
//

import UIKit
import SwiftUI

class CharacterCell: UICollectionViewCell {
    private var imageView = RoundedImageView()
    private let textLabel = UILabel()
    private let vStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Xib/storyboard is not supported")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let padding: CGFloat = 8
        let numOfItems = (traitCollection.horizontalSizeClass == .compact) ? 4 : 8
        let itemWidth = floor((UIScreen.main.bounds.width - (padding * 2)) / CGFloat(numOfItems))
        return super.systemLayoutSizeFitting(.init(width: itemWidth, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    private func setupLayout() {
        imageView.contentMode = .scaleAspectFit
        
        textLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.textAlignment = .center
        
        let padding: CGFloat = 8
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(textLabel)
        
        let imageHeightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        imageHeightConstraint.priority = .init(999)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.widthAnchor.constraint(equalTo: vStack.widthAnchor),
            imageHeightConstraint,
        ])
    }
    
    func configure(character: Character) {
        imageView.image = UIImage(named: character.imageName)
        textLabel.text = character.name
    }
}

fileprivate class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = bounds.width / 2
    }
}

struct CharacterCellViewRepresentable: UIViewRepresentable {
    
    let character: Character
    
    func makeUIView(context: Context) -> CharacterCell {
        let cell = CharacterCell()
        cell.configure(character: character)
        return cell
    }
    
    func updateUIView(_ uiView: CharacterCell, context: Context) {
    }
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CharacterCellViewRepresentable(character: Universe.ff7r.stubs[0])
                .frame(width: 120, height: 150)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(Universe.ff7r.stubs) { character in
                        CharacterCellViewRepresentable(character: character)
                            .frame(width: 120, height: 150)
                    }
                    
                }
            }
        }
    }
}
