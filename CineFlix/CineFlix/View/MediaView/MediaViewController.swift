//
//  MediaViewController.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit
import Locksmith
import SwiftUI

class MediaViewController: ThemedBackgroundViewController {
    
    // MARK: - Properties
    private let viewModel = MediaFetcherViewModel()
    private let categoryHeaderID = "categoryHeaderID"
    private var selectedItem: String! {
        if segmentController.selectedSegmentIndex == 0 {
            return "movie"
        } else {
            return "tv"
        }
    }
    
    // MARK: - UI Elements
    private lazy var mediaCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let segmentController: UISegmentedControl = {
        let items = ["Movies", "TVShows"]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchData(type: selectedItem)
        
        configureNavigationBar(withLogo: true, backButtonTitle: "", rightBarButtonImageName: "ipad.and.arrow.forward", rightBarButtonAction: #selector(ThemedBackgroundViewController.signOut))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        segmentController.setupSegment()
        segmentController.addTarget(self, action: #selector(segmentTapped), for: .valueChanged)
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.backgroundColor = .clear
        mediaCollectionView.showsVerticalScrollIndicator = false
        
        mediaCollectionView.register(MovieSectionHeader.self, forSupplementaryViewOfKind: categoryHeaderID, withReuseIdentifier: MovieSectionHeader.headerID)
        
        mediaCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        mediaCollectionView.register(MediaPreviewCollectionViewCell.self, forCellWithReuseIdentifier: MediaPreviewCollectionViewCell.identifier)
    }
    
    @objc func segmentTapped() {
        self.segmentController.setupSegment()
        self.mediaCollectionView.reloadData()
        fetchData(type: selectedItem)
    }
    
    private func fetchData(type: String) {
        let reloadDataClosure: () -> Void = { [weak self] in
            DispatchQueue.main.async {
                self?.mediaCollectionView.reloadData()
            }
        }
        viewModel.fetchGenres(type: type, completion: reloadDataClosure)
        viewModel.fetchTrending(type: type, completion: reloadDataClosure)
        viewModel.fetchTopRated(type: type, completion: reloadDataClosure)
        viewModel.fetchUpcoming(type: type, completion: reloadDataClosure)
        viewModel.fetchPopular(type: type, completion: reloadDataClosure)
        viewModel.fetchDiscover(type: type, completion: reloadDataClosure)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        view.addSubview(mediaCollectionView)
        view.addSubview(segmentController)
        
        NSLayoutConstraint.activate([
            segmentController.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            segmentController.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            segmentController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            mediaCollectionView.topAnchor.constraint(equalTo: segmentController.bottomAnchor, constant: 0),
            mediaCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            mediaCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            mediaCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, enviroment) -> NSCollectionLayoutSection? in
            
            if sectionNumber ==  0 {
                return self.mediaCollectionView.genres()
            } else {
                return self.mediaCollectionView.media(headerID: self.categoryHeaderID)
            }
        }
    }
    
    
}

// MARK: - UICollectionViewDataSource
extension MediaViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource
    // Provide a view for the supplementary header of each section.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieSectionHeader.headerID, for: indexPath) as! MovieSectionHeader
        
        // Determine the section title based on the selected segment.
        let mediaType: String = (segmentController.selectedSegmentIndex == 0) ? "Movies" : "TVShows"
        let sectionTitles = [
            "",
            "Top Rated \(mediaType)",
            "Popular \(mediaType)",
            "Trending \(mediaType)",
            "Upcoming \(mediaType)",
            "Discover \(mediaType)"
        ]
        
        header.label.text = sectionTitles[indexPath.section]
        return header
    }
    
    // Define the number of sections in the collection view.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    // Define the number of items in each section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.genres.count
        case 1:
            return viewModel.topRated.count
        case 2:
            return viewModel.popular.count
        case 3:
            return viewModel.trending.count
        case 4:
            return viewModel.upcoming.count
        case 5:
            return viewModel.discover.count
        default:
            return 0
        }
    }
    
    // Configure and return a cell for each item in the collection view.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as! GenreCollectionViewCell
            cell.configure(with: viewModel.genres[indexPath.row])
            return cell
            
        case 1, 2, 3, 4, 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaPreviewCollectionViewCell.identifier, for: indexPath) as! MediaPreviewCollectionViewCell
            switch indexPath.section {
            case 1:
                cell.configure(with: viewModel.topRated[indexPath.row])
            case 2:
                cell.configure(with: viewModel.popular[indexPath.row])
            case 3:
                cell.configure(with: viewModel.trending[indexPath.row])
            case 4:
                cell.configure(with: viewModel.upcoming[indexPath.row])
            case 5:
                cell.configure(with: viewModel.discover[indexPath.row])
            default:
                break
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    // Handle the selection of a collection view cell to navigate to media details.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaDetailVC = MediaDetailInfoViewController()
        var media: Media?
        
        switch indexPath.section {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let mediaGenresVC = storyboard.instantiateViewController(withIdentifier: MediaGenresViewController.identifier) as? MediaGenresViewController else { return }
            mediaGenresVC.configure(type: selectedItem, genre: viewModel.genres[indexPath.row])
            self.navigationController?.pushViewController(mediaGenresVC, animated: true)
            return
        case 1:
            media = viewModel.topRated[indexPath.row]
        case 2:
            media = viewModel.popular[indexPath.row]
        case 3:
            media = viewModel.trending[indexPath.row]
        case 4:
            media = viewModel.upcoming[indexPath.row]
        case 5:
            media = viewModel.discover[indexPath.row]
        default:
            break
        }
        
        guard let selectedMedia = media else { return }
        
        mediaDetailVC.configure(mediaType: selectedItem, media: selectedMedia)
        self.navigationController?.pushViewController(mediaDetailVC, animated: true)
    }
}

// MARK: - UpdateView
extension MediaViewController: UpdateView {
    
    // MARK: - UpdateView
    // Reload the collection view data when needed.
    func reloadData() {
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
}

//struct ViewControllerProvider: PreviewProvider {
//    static var previews: some View {
//        // ViewController.showPreview
//        MediaViewController().showPreview()
//    }
//}

