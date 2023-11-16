//
//  SurveyPageView.swift
//  TestNimble
//
//  Created by Abraham Escamilla Pinelo on 08/11/23.
//

import UIKit

protocol SurveyPageViewDelegate: AnyObject {
    func didPressStartButton()
    func didSwipeToRightAction(sender: UISwipeGestureRecognizer)
    func didSwipeToLeftAction(sender: UISwipeGestureRecognizer)
    func didPressProfileImageView(sender: UITapGestureRecognizer)
}

class SurveyPageView: UIView {
    
    //MARK: - UI
    var backgroundImageView: UIImageView!
    var profileImageView: UIImageView!
    var surveyTitleLabel: UILabel!
    var surveyDescriptionLabel: UILabel!
    var dateLabel: UILabel!
    var dayLabel:UILabel!
    var pageControl: UIPageControl!
    var startImageView: UIImageView!
    
    //MARK: - Variables
    weak var delegate: SurveyPageViewDelegate?
    var viewModel = SurveyPageViewVM() {
        didSet {
            updateUI()
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    //MARK: - Helper
    private func setupUI() {
        setupButton()
        setupImageViews()
        setupLabels()
        setupSwipesGestures()
        setupPageControl()
    }
    
    func updateUI() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.backgroundImageView.image = viewModel.currentImage?.withRenderingMode(.alwaysOriginal)
            self.surveyTitleLabel.text = viewModel.currentItem?.attributes.title
            self.surveyDescriptionLabel.text = viewModel.currentItem?.attributes.description
            self.dateLabel.text = viewModel.mediumFormattedDate
            self.dayLabel.text = viewModel.shortFormattedDate
            self.pageControl.currentPage = viewModel.currentIndex
            self.pageControl.numberOfPages = viewModel.count
        }
    }
    
    private func setupSwipesGestures() {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightAction))
        swipeRightGesture.direction = .right
        self.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftAction))
        swipeLeftGesture.direction = .left
        self.addGestureRecognizer(swipeLeftGesture)
    }
    
    //MARK: - Setup Page Control
    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 0
        pageControl.backgroundColor = .gray.withAlphaComponent(0.5)
        self.addSubview(pageControl)
        
        pageControl.bottomAnchor.constraint(equalTo: surveyTitleLabel.topAnchor, constant: -10).isActive = true
        pageControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
    }
    
    // MARK: - Image Views Setup
    private func setupImageViews() {
        backgroundImageView = UIImageView(image: UIImage(named: "SurveyBackground"))
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.backgroundColor = .lightGray
        backgroundImageView.contentMode = .scaleAspectFill
        
        self.addSubview(backgroundImageView)
        
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        //Profile image view
        profileImageView = UIImageView(image: UIImage(named: "ProfilePicture"))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTappedAction))
        tapGesture.numberOfTapsRequired = 1
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        self.addSubview(profileImageView)
        
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 110).isActive = true
        profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    
    // MARK: - Labels Setup
    private func setupLabels() {
        let basicFont = UIFont(name: "NeuzeitSLTStd-Book", size: 17)
        let heavyFont = UIFont(name: "NeuzeitSLTStd-BookHeavy", size: 17)
        
        //Description
        surveyDescriptionLabel = UILabel()
        surveyDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        surveyDescriptionLabel.numberOfLines = 2
        surveyDescriptionLabel.textColor = .white
        surveyDescriptionLabel.text = "We would like to know how you feel about our work from home..." // Set the initial text
        surveyDescriptionLabel.font = basicFont?.withSize(17) ?? .preferredFont(forTextStyle: .headline)
        
        self.addSubview(surveyDescriptionLabel)
        
        surveyDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        surveyDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60).isActive = true
        surveyDescriptionLabel.rightAnchor.constraint(equalTo: self.startImageView.leftAnchor, constant: 10).isActive = true
        
        
        //Title
        surveyTitleLabel = UILabel()
        surveyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        surveyTitleLabel.text = "Survey Title"
        surveyTitleLabel.textColor = .white
        surveyTitleLabel.font = heavyFont?.withSize(28) ?? .preferredFont(forTextStyle: .footnote)
        self.addSubview(surveyTitleLabel)
        
        surveyTitleLabel.bottomAnchor.constraint(equalTo: self.surveyDescriptionLabel.topAnchor, constant: -10).isActive = true
        surveyTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        //Date
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .white
        dateLabel.font = heavyFont?.withSize(13)
        self.addSubview(dateLabel)
        
        dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 10).isActive = true
        dateLabel.text = "Monday June 15"
        
        //Day
        dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.font = heavyFont?.withSize(34)
        dayLabel.textColor = .white
        self.addSubview(dayLabel)
        
        dayLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        dayLabel.text = "Today"
    }
    
    
    // MARK: - Button Setup
    private func setupButton() {
        let nextArrowIcon = UIImage(named: "NextArrow")!
        
        startImageView = UIImageView(image: nextArrowIcon)
        startImageView.isUserInteractionEnabled = true
        startImageView.translatesAutoresizingMaskIntoConstraints = false
        startImageView.backgroundColor = .white
        startImageView.contentMode = .center
        startImageView.layer.cornerRadius = 55/2
        
        self.addSubview(startImageView)
        //Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startSurveyButtonAction))
        tapGesture.numberOfTapsRequired = 1
        startImageView.addGestureRecognizer(tapGesture)
        
        startImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        startImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        startImageView.widthAnchor.constraint(equalToConstant: 55).isActive = true
        startImageView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        startImageView.layer.zPosition = 1
    }
    
    //MARK: - Actions
    @objc func startSurveyButtonAction() {
        delegate?.didPressStartButton()
    }
    
    @objc func swipeLeftAction(sender: UISwipeGestureRecognizer) {
        delegate?.didSwipeToLeftAction(sender: sender)
        viewModel.nextItem()
        updateUI()
    }
    
    @objc func swipeRightAction(sender: UISwipeGestureRecognizer) {
        delegate?.didSwipeToRightAction(sender: sender)
        viewModel.previousItem()
        updateUI()
    }
    
    @objc func profileImageViewTappedAction(sender: UITapGestureRecognizer) {
        delegate?.didPressProfileImageView(sender: sender)
    }
}
