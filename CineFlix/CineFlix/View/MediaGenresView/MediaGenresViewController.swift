//
//  MediaGenresViewController.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit

class MediaGenresViewController: ThemedBackgroundViewController {
    
    // MARK: - Properties
    static var identifier = "MediaGenresViewController"
    
    private var genreId = Int()
    private var mediaType = String()
    
    private let viewModel = MediaGenresViewModel()
    
    // MARK: - UI Elements
    var mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 4) * 1.21, height: (UIScreen.main.bounds.height / 5) * 1.21)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MediaPreviewCollectionViewCell.self, forCellWithReuseIdentifier: MediaPreviewCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(withLogo: true, backButtonTitle: "", rightBarButtonImageName: "xmark", rightBarButtonAction: #selector(MediaGenresViewController.backButtonTapped))
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.backgroundColor = .clear
        
        mediaCollectionView.showsVerticalScrollIndicator = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .foregroundColor: UIColor.white.withAlphaComponent(0.65)
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        setupConstraint()
    }
    
    // MARK: - Button Action
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
    
    public func configure(type: String, genre: Genre) {
        mediaType = type
        title = genre.name
        genreId = genre.id
        
        viewModel.fetchMedia(type: mediaType, genre: genreId) {
            DispatchQueue.main.async {
                self.mediaCollectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MediaGenresViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // This method is called when a cell is about to be displayed.
    // It checks if we've reached the end of the current data and triggers additional data loading if needed.
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Check if we haven't reached the last page of data and the last cell is being displayed.
        if viewModel.currentPage < viewModel.totalPages && indexPath.row == viewModel.arrayOfMediaByGenre.count - 1 {
            // Fetch more media items of the specified type and genre.
            viewModel.fetchMedia(type: mediaType, genre: genreId) {
                DispatchQueue.main.async {
                    // Reload the collection view to display the newly fetched data.
                    self.mediaCollectionView.reloadData()
                }
            }
        }
    }
    
    // Return the number of media items in the data source.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.arrayOfMediaByGenre.count
    }
    
    // Configure and return a cell for a given index path.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaPreviewCollectionViewCell.identifier, for: indexPath) as? MediaPreviewCollectionViewCell else { return UICollectionViewCell() }
        // Configure the cell with data from the viewModel.
        cell.configure(with: viewModel.arrayOfMediaByGenre[indexPath.row])
        
        return cell
    }
    
    // This method is called when a cell is selected.
    // It creates and configures a MediaDetailInfoViewController to display detailed information about the selected media item.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MediaDetailInfoViewController()
        vc.configure(mediaType: mediaType, media: viewModel.arrayOfMediaByGenre[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
