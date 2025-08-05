//
//  DefaultHUDProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/12
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

public class DefaultHUDProvider: HUDProvider {
    
    public func showHUD(on view: UIView?, param: Any?) {
        DispatchQueue.main.async {
            guard let depends = view ?? UIViewController.dtb.topMost()?.view else {
                return
            }
            guard depends.subviews.contains(where: { $0.tag == SystemHUDView.treeTag }) == false else {
                return
            }
            let hud = SystemHUDView()
            depends.addSubview(hud)
            hud.frame = depends.bounds
            depends.bringSubviewToFront(hud)
            hud.play()
        }
    }
    
    public func hideHUD(on view: UIView?, param: Any?) {
        DispatchQueue.main.async {
            guard let depends = view ?? UIViewController.dtb.topMost()?.view else {
                return
            }
            guard let hud = depends.subviews.first(where: { $0.tag == SystemHUDView.treeTag }) as? SystemHUDView else {
                return
            }
            hud.stop()
            hud.removeFromSuperview()
        }
    }
}

///
fileprivate class SystemHUDView: UIView {
    
    static let treeTag = 20250101
    
    func play() {
        indicator.startAnimating()
    }
    
    func stop() {
        indicator.stopAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        loadViews(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViews(in box: UIView) {
        [indicator].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: box.centerXAnchor, constant: 0.0),
            indicator.centerYAnchor.constraint(equalTo: box.centerYAnchor, constant: 0.0),
        ])
    }
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            view.style = .medium
        } else {
            view.style = .gray
        }
        return view
    }()
}

