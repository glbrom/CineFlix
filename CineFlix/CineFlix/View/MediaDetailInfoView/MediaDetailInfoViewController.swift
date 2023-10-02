//
//  MediaDetailInfoViewController.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class MediaDetailInfoViewController: ThemedBackgroundViewController {
    
    // MARK: - Properties
    private let viewModel = MediaDetailInfoViewModel()
    static var identifier = "MediaDetailInfoViewController"
    
    private var mediaId = Int()
    private var mediaType = String()
    private var watchlistType = String()
    
    // MARK: - UI Elements
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isUserInteractionEnabled = true
        pageControl.currentPageIndicatorTintColor = .systemOrange.withAlphaComponent(0.8)
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.6)
        return pageControl
    }()
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.6).cgColor,
            UIColor.clear.cgColor
        ]
        return gradient
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white.withAlphaComponent(0.85)
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white.withAlphaComponent(0.75)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let myListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        button.configuration?.baseForegroundColor = .systemOrange
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.image = UIImage(systemName: "plus.square.on.square")
        button.configuration?.imagePadding = 6
        button.configuration?.imagePlacement = .top
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        button.setAttributedTitle(NSAttributedString(string: "Favorites", attributes: attributes), for: .normal)
        
        return button
    }()
    
    private let sharedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        button.configuration?.baseForegroundColor = .systemOrange
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.image = UIImage(systemName: "arrowshape.turn.up.right")
        button.configuration?.imagePadding = 6
        button.configuration?.imagePlacement = .top
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        button.setAttributedTitle(NSAttributedString(string: "Share", attributes: attributes), for: .normal)
        
        return button
    }()
    
    private let scoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .plain()
        button.configuration?.baseForegroundColor = .systemOrange
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.image = UIImage(systemName: "star")
        button.configuration?.imagePadding = 6
        button.configuration?.imagePlacement = .top
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var trailerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TrailerCollectionViewCell.self, forCellWithReuseIdentifier: TrailerCollectionViewCell.identifier)
        return collectionView
    }()
    
    private func createLayout() -> UICollectionViewLayout {
        var layout = UICollectionViewLayout()
        let spacing: CGFloat = 0
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(view.frame.size.width / 1.77))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trailerCollectionView.delegate = self
        trailerCollectionView.dataSource = self
        
        sharedButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getWatchlist(type: watchlistType) { [self] in
            
            self.myListButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
            self.myListButton.setImage(UIImage(systemName: "plus.square.on.square"), for: .normal)
            self.myListButton.reloadInputViews()
            
            for movie in self.viewModel.watchlist {
                if movie.id == self.mediaId {
                    
                    self.myListButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
                    self.myListButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    self.myListButton.reloadInputViews()
                    return
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Button Actions
    @objc func shareAction() {
        // Determine the size of the snapshot, including all elements
        let imageSize = CGSize(width: posterView.frame.width, height: posterView.frame.height + titleLabel.frame.height + genreLabel.frame.height + releaseDateLabel.frame.height)
        
        // Create a context for the snapshot
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        
        // Render posterView onto the image
        posterView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        // Define the position of titleLabel on the image
        let titleLabelFrame = CGRect(x: 0, y: posterView.frame.height, width: posterView.frame.width, height: titleLabel.frame.height)
        titleLabel.drawText(in: titleLabelFrame)
        
        // Define the position of genreLabel on the image
        let genreLabelFrame = CGRect(x: 0, y: posterView.frame.height + titleLabel.frame.height, width: posterView.frame.width, height: genreLabel.frame.height)
        genreLabel.drawText(in: genreLabelFrame)
        
        // Define the position of releaseDateLabel on the image
        let releaseDateLabelFrame = CGRect(x: 0, y: posterView.frame.height + titleLabel.frame.height + genreLabel.frame.height, width: posterView.frame.width, height: releaseDateLabel.frame.height)
        releaseDateLabel.drawText(in: releaseDateLabelFrame)
        
        // Get the final image
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let combinedImage = combinedImage {
            let shareController = UIActivityViewController(activityItems: [combinedImage], applicationActivities: nil)
            shareController.completionWithItemsHandler = { _, bool, _, _ in
                if bool {
                    print("Shared successfully")
                }
            }
            present(shareController, animated: true, completion: nil)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addTapped() {
        viewModel.addToWatchlist(watchlist: true, mediaType: mediaType, mediaId: mediaId) {
            self.myListButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
    }
    
    @objc func removeTapped() {
        viewModel.addToWatchlist(watchlist: false, mediaType: mediaType, mediaId: mediaId) {
            self.myListButton.setImage(UIImage(systemName: "plus.square.on.square"), for: .normal)
        }
    }
    
    public func configure(mediaType: String, media: Media) {
        mediaId = media.id
        
        func choosingGenres(genres: [Genre]) -> String {
            var g = ""
            for id in media.genre_ids {
                for genre in genres {
                    if id == genre.id {
                        if id == media.genre_ids.last {
                            g += genre.name
                        } else {
                            g += genre.name + " • "
                        }
                    }
                }
            }
            return g
        }
        
        if media.title != nil {
            self.mediaType = "movie"
            self.watchlistType = "movies"
            viewModel.fetchMovieGenres { genres in
                self.genreLabel.text = choosingGenres(genres: genres)
            }
        } else {
            self.mediaType = "tv"
            self.watchlistType = "tv"
            viewModel.fetchTVGenres { genres in
                self.genreLabel.text = choosingGenres(genres: genres)
            }
        }
        
        title = media.title ?? "" + (media.name ?? "")
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        scoreButton.setAttributedTitle(NSAttributedString(
            string: String(media.vote_average),
            attributes: attributes), for: .normal)
        
        titleLabel.text = media.original_title ?? "" + (media.original_name ?? "")
        let date = media.release_date ?? "" + (media.first_air_date ?? "")
        releaseDateLabel.text = String(date.dropLast(6))
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (media.poster_path ?? "")) else { return }
        posterView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        posterView.sd_setImage(with: url, completed: nil)
        overviewLabel.text = media.overview
        viewModel.loadTrailers(mediaType: mediaType, movieId: media.id) {
            self.trailerCollectionView.reloadData()
        }
    }
    
    // MARK: - Constraints
    private func setupConstraint() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterView)
        posterView.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = posterView.bounds
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(trailerCollectionView)
        contentView.addSubview(pageControl)
        
        stackView.addArrangedSubview(myListButton)
        stackView.addArrangedSubview(scoreButton)
        stackView.addArrangedSubview(sharedButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterView.topAnchor.constraint(equalTo: view.topAnchor),
            posterView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 380),
            
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 8),
            
            releaseDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            genreLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            genreLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            genreLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40),
            stackView.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            overviewLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            overviewLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            overviewLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            
            trailerCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            trailerCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            trailerCollectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 8),
            trailerCollectionView.heightAnchor.constraint(equalTo: trailerCollectionView.widthAnchor, multiplier: 0.56),
            
            pageControl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            pageControl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            pageControl.topAnchor.constraint(equalTo: trailerCollectionView.bottomAnchor, constant: 0),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MediaDetailInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Define the number of items in the collection, set the number of pages in the pageControl
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.viewModel.arrayOfViedos.count
        if count == 1 {
            pageControl.numberOfPages = 0
        } else {
            pageControl.numberOfPages = count
        }
        return count
    }
    
    // Configure the collection cell for displaying videos
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCollectionViewCell.identifier, for: indexPath) as? TrailerCollectionViewCell else { return UICollectionViewCell() }
        
        // Load a video using information from the viewModel
        cell.playerView.load(withVideoId: self.viewModel.arrayOfViedos[indexPath.row].key)
        return cell
    }
    
    // Handle the end of collection scrolling, update the current page of pageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    // Handle the display of a collection cell, set the current page of pageControl
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}
