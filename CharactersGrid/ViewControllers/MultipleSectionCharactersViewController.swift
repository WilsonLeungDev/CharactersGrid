//
//  MultipleSectionCharactersViewController.swift
//  CharactersGrid
//
//  Created by Wilson Leung on 6/3/2022.
//

import UIKit
import SwiftUI

class MultipleSectionCharactersViewController: UIViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let segmentedControl = UISegmentedControl(
        items: Universe.allCases.map { $0.title }
    )
    private var sectionCharacters = Universe.ff7r.sectionedStubs {
        didSet {
            updateCollectionView(oldSectionItems: oldValue, newSectionItems: sectionCharacters)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupSegmentedControl()
        setupCollectionView()
        setupLayout()
    }

    private func updateCollectionView(oldSectionItems: [SectionCharacters], newSectionItems: [SectionCharacters]) {
        var sectionsToInsert = IndexSet()
        var sectionsToRemove = IndexSet()
        var indexPathsToInsert = [IndexPath]()
        var indexPathsToRemove = [IndexPath]()

        let sectionDiff = newSectionItems.difference(from: oldSectionItems)
        sectionDiff.forEach { (change) in
            switch change {
                case let .remove(offset, _, _): sectionsToRemove.insert(offset)
                case let .insert(offset, _, _): sectionsToInsert.insert(offset)
            }
        }

        (0..<newSectionItems.count).forEach { (index) in
            let newSection = newSectionItems[index]
            if let oldSectionIndex = oldSectionItems.firstIndex(where: { $0 == newSection }) {
                let oldSection = oldSectionItems[oldSectionIndex]
                let diff = newSection.characters.difference(from: oldSection.characters)
                diff.forEach { (change) in
                    switch change {
                        case let .remove(offset, _, _): indexPathsToRemove.append(IndexPath(item: offset, section: oldSectionIndex))
                        case let .insert(offset, _, _): indexPathsToInsert.append(IndexPath(item: offset, section: index))
                    }
                }
            }
        }

        collectionView.performBatchUpdates {
            self.collectionView.deleteSections(sectionsToRemove)
            self.collectionView.deleteItems(at: indexPathsToRemove)

            self.collectionView.insertSections(sectionsToInsert)
            self.collectionView.insertItems(at: indexPathsToInsert)
        } completion: { (_) in
            let headerIndexPaths = self.collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
            headerIndexPaths.forEach { (indexPath) in
                let collectionHeaderView = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as! CollectionHeaderView
                let section = self.sectionCharacters[indexPath.section]
                collectionHeaderView.configure(text: "\(section.category) (\(section.characters.count))".uppercased())
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
        sectionCharacters = sender.selectedUniverse.sectionedStubs
    }

    @objc func shuffleTapped() {
        sectionCharacters = sectionCharacters.shuffled().map {
            SectionCharacters(category: $0.category, characters: $0.characters.shuffled())
        }
    }
}

extension MultipleSectionCharactersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionCharacters.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sectionCharacters[section].characters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CharacterCell
        let character = sectionCharacters[indexPath.section].characters[indexPath.item]
        cell.configure(character: character)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let collectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionHeaderView
        let section = sectionCharacters[indexPath.section]
        collectionHeaderView.configure(text: "\(section.category) (\(section.characters.count))".uppercased())
        return collectionHeaderView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let collectionHeaderView = CollectionHeaderView()
        let section = sectionCharacters[section]
        collectionHeaderView.configure(text: "\(section.category) (\(section.characters.count))".uppercased())
        return collectionHeaderView.systemLayoutSizeFitting(.init(width: collectionView.bounds.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

struct MultipleSectionCharactersViewControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(rootViewController: MultipleSectionCharactersViewController())
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

struct MultipleSectionCharactersViewController_Previews: PreviewProvider {
    static var previews: some View {
        MultipleSectionCharactersViewControllerRepresentable()
            .edgesIgnoringSafeArea(.vertical)
            .preferredColorScheme(.dark)
    }
}
