//
//  PlaygroundViewController.swift
//  Demo
//
//  Created by moonShadow on 2023/12/21
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///Playground
class PlaygroundViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        loadViews(in: view)
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(backgroundView)
        box.addSubview(imageView)
        
        backgroundView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(imageView)
        }
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(460.0/750.0)
        }
    }
    
    private let backgroundView: UIImageView = {
        let view = UIImageView(image: UIImage.gradientImage(colors: [XMVisual.Color.Orange.A, XMVisual.Color.Orange.B], insets: .zero))
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bg_three_ball"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
}

fileprivate extension UIImage {
    
    static func gradientImage(colors: [UIColor], cornerRadius: CGFloat = 0, insets: UIEdgeInsets, stops: (start: CGPoint, end: CGPoint) = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0))) -> UIImage? {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: insets.left + insets.right + 50,
                height: insets.top + insets.bottom + 50
            )
        )
        gradient.startPoint = stops.start
        gradient.endPoint = stops.end
        gradient.colors = colors.map { $0.cgColor }
        gradient.cornerRadius = cornerRadius
        return UIImage.imageWithLayer(gradient)?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
    }
    
    static func imageWithLayer(_ layer: CALayer) -> UIImage? {
        if #available(iOS 17.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.opaque = layer.isOpaque
            format.scale = 0.0
            let render = UIGraphicsImageRenderer(size: layer.bounds.size, format: format)
            let image = render.image { renderContext in
                let context = renderContext.cgContext
                layer.render(in: context)
            }
            return image
        } else {
            UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
            guard let context =  UIGraphicsGetCurrentContext() else {
                return nil
            }
            layer.render(in: context)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img
        }
    }
}
