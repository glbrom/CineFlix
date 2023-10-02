//
//  SearchViewController.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit

class SearchViewController: ThemedBackgroundViewController {
    
    // MARK: - Properties
    private var movies = [Media]()
    private let viewModelMovie = MediaFetcherViewModel()
    
    var viewModel = MediaSearchViewModel()
    var genres = [Genres]()
    
    // MARK: - UI Elements
    private var searchController: UISearchController = {
        let searchController = UISearchController()
        
        searchController.searchBar.tintColor = .systemOrange
        searchController.searchBar.placeholder = "Search Movie or a TV-shows"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.overrideUserInterfaceStyle = .dark
        searchController.searchBar.backgroundColor = .clear
        searchController.searchBar.searchTextField.layer.borderWidth = 1.2
        searchController.searchBar.searchTextField.layer.cornerRadius = 16
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.systemOrange.withAlphaComponent(0.3).cgColor //
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchController
    }()
    
    private lazy var mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MediaPreviewCollectionViewCell.self,
                                forCellWithReuseIdentifier: MediaPreviewCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let cellWidth: CGFloat = UIScreen.main.bounds.width / 4 * 1.21
    private let cellHeight: CGFloat = UIScreen.main.bounds.height / 5 * 1.21
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupCollectionView()
        
        configureNavigationBar(withLogo: true,
                               backButtonTitle: "",
                               rightBarButtonImageName: "ipad.and.arrow.forward",
                               rightBarButtonAction: #selector(ThemedBackgroundViewController.signOut)
        )
    }
    
    // MARK: - Private Methods
    private func setupCollectionView() {
        viewModel.fetchPopularMovies {
            self.mediaCollectionView.reloadData()
        }
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.backgroundColor = .clear
        mediaCollectionView.showsVerticalScrollIndicator = false
        setupConstraint()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = .systemOrange
        }
    }
    
    // MARK: - Constraints
    private func setupConstraint() {
        view.addSubview(mediaCollectionView)
        
        NSLayoutConstraint.activate([
            mediaCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            mediaCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            mediaCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mediaCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    
    // This method is called when the search query is updated.
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        
        // If the search query is empty, clear the search results and reload the collection view.
        if query.isEmpty {
            viewModel.searched.removeAll()
            mediaCollectionView.reloadData()
        }
        
        // Reset the current page and perform a new search based on the query.
        self.viewModel.currentPage = 0
        viewModel.searchMovie(query: query.trimmingCharacters(in: .whitespaces)) {
            self.mediaCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // This method is called when a collection view cell is about to be displayed.
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let query = searchController.searchBar.text else { return }
        
        let isLastItem = indexPath.row == viewModel.searched.count - 1
        let hasMoreDataToLoad = viewModel.currentPage < viewModel.totalPages
        
        // If the last item is about to be displayed and there's more data to load, fetch additional search results.
        if isLastItem && hasMoreDataToLoad {
            viewModel.searchMovie(query: query.trimmingCharacters(in: .whitespaces)) {
                DispatchQueue.main.async {
                    self.mediaCollectionView.reloadData()
                }
            }
        }
    }
    
    // Return the number of items in the collection view based on whether the search is active or not.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch searchController.isActive {
        case true:
            return viewModel.searched.count
        case false:
            return viewModel.popular.count
        }
    }
    
    // Return a reusable supplementary view for the collection view (header in this case).
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieSectionHeader.headerID, for: indexPath) as! MovieSectionHeader
    }
    
    // Configure and return a cell for the collection view based on the search state and data source.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaPreviewCollectionViewCell.identifier, for: indexPath) as? MediaPreviewCollectionViewCell else { return UICollectionViewCell() }
        
        // Determine which media items to display based on whether the search is active or not.
        let mediaToDisplay = searchController.isActive ? viewModel.searched[indexPath.row] : viewModel.popular[indexPath.row]
        cell.configure(with: mediaToDisplay)
        
        return cell
    }
    
    // Handle the selection of a collection view cell to navigate to the media detail view controller.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MediaDetailInfoViewController") as? MediaDetailInfoViewController else { return }
        
        // Determine the media type and the specific media item to display.
        let mediaType = searchController.isActive ? "movie" : "tv"
        let media = searchController.isActive ? viewModel.searched[indexPath.row] : viewModel.popular[indexPath.row]
        
        vc.configure(mediaType: mediaType, media: media)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
