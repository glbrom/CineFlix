//
//  FavoritesViewController.swift
//  CineFlix
//
//  Created by Macbook on 26.08.2023.
//

import UIKit

class FavoritesViewController: ThemedBackgroundViewController {
    
    // MARK: - Properties
    private let viewModel = FavoritesViewModel()
    
    private let viewModelMovie = MediaFetcherViewModel()
    private var watchlistOfMovies = [Media]()
    private var watchlistOfTVShows = [Media]()
    
    // MARK: - UI Elements
    private let segmentController: UISegmentedControl = {
        let items = ["Movies", "TVShows"]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        
        return segmentControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentController.setupSegment()
        segmentController.addTarget(self, action: #selector(segmentTapped), for: .valueChanged)
        
        setupTableView()
        
        configureNavigationBar(withLogo: true, backButtonTitle: "", rightBarButtonImageName: "ipad.and.arrow.forward", rightBarButtonAction: #selector(ThemedBackgroundViewController.signOut))
        navigationItem.backButtonTitle = ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchMovieWatchlist {
            self.tableView.reloadData()
        }
        
        viewModel.fetchTVShowsWatchlist {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteMediaTableViewCell.self, forCellReuseIdentifier: FavoriteMediaTableViewCell.identifier)
    }
    
    @objc func segmentTapped() {
        segmentController.setupSegment()
        self.tableView.reloadData()
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(segmentController)
        
        NSLayoutConstraint.activate([
            segmentController.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            segmentController.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            segmentController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: segmentController.bottomAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Determine the number of rows in the table view based on the selected segment (movies or TV shows).
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentController.selectedSegmentIndex {
        case 0: return viewModel.arrayOfMoviesWatchlist.count
        case 1: return viewModel.arrayOfTVShowsWatchlist.count
        default:
            return 0
        }
    }
    
    // Configure and return a table view cell based on the selected segment and data source.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteMediaTableViewCell.identifier) as? FavoriteMediaTableViewCell else { return UITableViewCell() }
        switch segmentController.selectedSegmentIndex {
        case 0: cell.configure(media: self.viewModel.arrayOfMoviesWatchlist[indexPath.row])
        case 1: cell.configure(media: self.viewModel.arrayOfTVShowsWatchlist[indexPath.row])
        default:
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        
        return cell
    }
    
    // Define the height for each row in the table view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.width * 0.5 + 10
    }
    
    // Configure trailing swipe actions for deleting items from the watchlist.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(style: .normal, title: "Delete") { [weak self]_, _, completion in
            switch self?.segmentController.selectedSegmentIndex {
            case 0:
                self?.viewModel.remove(mediaType: "movie", mediaId: self?.viewModel.arrayOfMoviesWatchlist[indexPath.row].id ?? 0) {
                    self?.viewModel.arrayOfMoviesWatchlist.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            case 1:
                self?.viewModel.remove(mediaType: "tv", mediaId: self?.viewModel.arrayOfTVShowsWatchlist[indexPath.row].id ?? 0) {
                    self?.viewModel.arrayOfTVShowsWatchlist.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            default:
                return
            }
        }
        
        // Set the background color for the delete action.
        removeAction.backgroundColor = .systemRed.withAlphaComponent(0.4)
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
    // Handle row selection to navigate to the media detail view controller.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: MediaDetailInfoViewController.identifier) as? MediaDetailInfoViewController else { return }
        
        switch self.segmentController.selectedSegmentIndex {
        case 0:
            vc.configure(mediaType: "movie", media: viewModel.arrayOfMoviesWatchlist[indexPath.row])
        case 1:
            vc.configure(mediaType: "tv", media: viewModel.arrayOfTVShowsWatchlist[indexPath.row])
        default:
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
