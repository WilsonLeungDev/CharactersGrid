//
//  SingleSectionCharactersViewController.swift
//  CharactersGrid
//
//  Created by Wilson Leung on 4/3/2022.
//

import UIKit
import SwiftUI

class SingleSectionCharactersViewController: UIViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let segmentedControl = UISegmentedControl(
        items: Universe.allCases.map { $0.title }
    )
    private var characters = Universe.ff7r.stubs {
        didSet {
            updateCollectionView(oldItems: oldValue, newItems: characters)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupSegmentedControl()
        setupCollectionView()
        setupLayout()
    }

    private func updateCollectionView(oldItems: [Character], newItems: [Character]) {
        collectionView.performBatchUpdates {
            let diff = newItems.difference(from: oldItems)
            diff.forEach { [weak self] (change) in
                switch change {
                    case let .remove(offset, _, _): self?.collectionView.deleteItems(at: [IndexPath(item: offset, section: 0)])
                    case let .insert(offset, _, _): self?.collectionView.insertItems(at: [IndexPath(item: offset, section: 0)])
                }
            }
        } completion: { (_) in
            let headerIndexPaths = self.collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
            headerIndexPaths.forEach { (indexPath) in
                let collectionHeaderView = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as! CollectionHeaderView
                collectionHeaderView.configure(text: "\(self.characters.count) Character(s)")
            }
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private func setupCollectionView() {
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")

        view.addSubview(collectionView)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func setupLayout() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let padding: CGFloat = 8
        flowLayout.sectionInset = .init(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }

    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        navigationItem.titleView = segmentedControl
    }

    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "shuffle"), style: .plain, target: self, action: #selector(shuffleTapped))
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        characters = sender.selectedUniverse.stubs
    }

    @objc func shuffleTapped() {
        characters.shuffle()
    }
}

extension SingleSectionCharactersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CharacterCell
        let character = characters[indexPath.item]
        cell.configure(character: character)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let collectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionHeaderView
        collectionHeaderView.configure(text: "\(characters.count) Character(s)")
        return collectionHeaderView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let collectionHeaderView = CollectionHeaderView()
        collectionHeaderView.configure(text: "\(characters.count) Character(s)")
        return collectionHeaderView.systemLayoutSizeFitting(.init(width: collectionView.bounds.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

struct SingleSectionCharactersViewControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: SingleSectionCharactersViewController())
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

struct SingleSectionCharactersViewController_Previews: PreviewProvider {
    static var previews: some View {
        SingleSectionCharactersViewControllerRepresentable()
            .edgesIgnoringSafeArea(.vertical)
            .preferredColorScheme(.dark)
    }
}
