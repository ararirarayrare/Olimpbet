import UIKit

class BasePageVC: UIPageViewController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


class InfoPageViewController: BasePageVC {
    
    private var infoViewControllers = [UIViewController]()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.alpha = 1
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.backgroundStyle = .prominent
        
        pageControl.addTarget(self, action: #selector(pageControlDidChangeValue(_:)), for: .valueChanged)
        
        pageControl.layer.cornerRadius = 8
        
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        delegate = self
        dataSource = self
        
        for index in 1...4 {
            let vc = InfoViewController(image: UIImage(named: "guide\(index)"))
            infoViewControllers.append(vc)
        }
        
        setViewControllers([infoViewControllers[0]],
                           direction: .forward,
                           animated: true)
                
        pageControl.numberOfPages = infoViewControllers.count
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -0),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: 300),
            pageControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
        }
    }
    
    @objc
    private func pageControlDidChangeValue(_ sender: UIPageControl) {
        let vc = infoViewControllers[sender.currentPage]
        setViewControllers([vc], direction: .forward, animated: false)
    }
    
    @objc
    private func swiped() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.backgroundColor = .clear
        } completion: { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    
}

extension InfoPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = infoViewControllers.firstIndex(of: viewController),
              index > 0 else {
            return nil
        }
        
        return infoViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = infoViewControllers.firstIndex(of: viewController),
              index < (infoViewControllers.count - 1) else {
            return nil
        }
        
        return infoViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?.first,
              let index = infoViewControllers.firstIndex(of: pageContentViewController) else {
            return
        }
        
        self.pageControl.currentPage = index
    }
}

class InfoViewController: BaseVC {
    

    init(image: UIImage?) {
        super.init(coordinator: nil)
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 60, y: 20, width: view.bounds.width - 120, height: view.bounds.height - 40)
        imageView.image = image
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: imageView.bounds,
                                       cornerRadius: 24).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        
        imageView.layer.addSublayer(shapeLayer)
        
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        
        view.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
