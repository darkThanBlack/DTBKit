//
//  GPSMockViewController.swift
//  Demo
//
//  Created by moonShadow on 2023/12/5
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit
import MapKit
import SnapKit

/// 
class GPSMockViewController: UIViewController, XMAuthManagerDelegate {
    
    private lazy var auths = XMAuthManager(delegate: self)
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        auths.startAuthorizations(with: [.location(.whenInUse)]) { success in
            guard success else {
                return
            }
            self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
        }
        
        loadViews(in: view)
    }
    
    @objc private func removeButtonEvent(button: UIButton) {
        GPSCheckInManager.shared.stopMonitor()
        mapView.removeOverlays(mapView.overlays)
    }
    
    enum FieldKeys: String {
        case enter_latitude, enter_longitude, enter_radius
    }
    
    class CreatingModel {
        var lati: CLLocationDegrees
        var longi: CLLocationDegrees
        var radius: CLLocationDistance
        
        var isEmpty: Bool {
            return [lati, longi, radius].contains(where: { $0 <= 0 })
        }
        
        init(lati: CLLocationDegrees, longi: CLLocationDegrees, radius: CLLocationDistance) {
            self.lati = lati
            self.longi = longi
            self.radius = radius
        }
    }
    
    private var creating: CreatingModel?
    
    @objc private func actionsButtonEvent(button: UIButton) {
        let alert = UIAlertController(title: "Menu", message: "desc.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "add", style: .default, handler: { _ in
            self.addButtonEvent(button: button)
        }))
        alert.addAction(UIAlertAction(title: "remove", style: .default, handler: { _ in
            self.removeButtonEvent(button: button)
        }))
        alert.addAction(UIAlertAction(title: "user loc.", style: .default, handler: { _ in
            self.mapView.zoomLevel = 15
            self.mapView.setCenter(self.mapView.region.center, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func addButtonEvent(button: UIButton) {
        let alert = UIAlertController(title: "添加围栏", message: "圆形: 经纬度+半径", preferredStyle: .alert)
        creating = CreatingModel(lati: 0, longi: 0, radius: 0)
        alert.addTextField { field in
            field.placeholder = FieldKeys.enter_latitude.rawValue
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChanged), name: UITextField.textDidChangeNotification, object: field)
        }
        alert.addTextField { field in
            field.placeholder = FieldKeys.enter_longitude.rawValue
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChanged), name: UITextField.textDidChangeNotification, object: field)
        }
        alert.addTextField { field in
            field.placeholder = FieldKeys.enter_radius.rawValue
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChanged), name: UITextField.textDidChangeNotification, object: field)
        }
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { _ in
            self.creating = nil
        }))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            guard let model = self.creating, model.isEmpty == false else {
                self.creating = nil
                return
            }
            GPSCheckInManager.shared.addMonitor(lati: model.lati, longi: model.longi, radius: model.radius)
            
            self.mapView.zoomLevel = 15
            let circle = MKCircle(center: CLLocationCoordinate2D(latitude: model.lati, longitude: model.longi), radius: model.radius)
            self.mapView.addOverlay(circle)
            self.mapView.setCenter(circle.coordinate, animated: true)
        }))
        present(alert, animated: true)
    }
    
    @objc private func textFieldDidChanged(_ notification: Notification) {
        guard let field = notification.object as? UITextField,
              let value = Double(field.text ?? ""),
              let key = FieldKeys(rawValue: field.placeholder ?? "") else {
            return
        }
        switch key {
        case .enter_latitude:
            creating?.lati = value
        case .enter_longitude:
            creating?.longi = value
        case .enter_radius:
            creating?.radius = value
        }
    }
    
    //MARK: View
    
    private func loadViews(in box: UIView) {
        box.addSubview(mapView)
        box.addSubview(actionsButton)
//        box.addSubview(addButton)
//        box.addSubview(removeButton)
        
        mapView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(box)
        }
        actionsButton.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(box.snp.top).offset(120.0)
        }

//        addButton.snp.makeConstraints { make in
//            make.centerX.equalTo(box.snp.centerX)
//            make.top.equalTo(box.snp.top).offset(120.0)
//        }
//        removeButton.snp.makeConstraints { make in
//            make.centerX.equalTo(box.snp.centerX)
//            make.top.equalTo(box.snp.top).offset(160.0)
//        }
    }
    
    private lazy var actionsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Actions", for: .normal)
        button.addTarget(self, action: #selector(actionsButtonEvent(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton(type: .custom)
        addButton.backgroundColor = .green
        addButton.setTitle("add", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonEvent(button:)), for: .touchUpInside)
        return addButton
    }()
    
    private lazy var removeButton: UIButton = {
        let removeButton = UIButton(type: .custom)
        removeButton.backgroundColor = .green
        removeButton.setTitle("remove", for: .normal)
        removeButton.addTarget(self, action: #selector(removeButtonEvent(button:)), for: .touchUpInside)
        return removeButton
    }()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        view.mapType = .hybrid
        view.showsCompass = true
        view.showsScale = true
        view.showsUserLocation = true
        view.userTrackingMode = .followWithHeading
        return view
    }()
}

extension GPSMockViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self) {
            let render = MKCircleRenderer(overlay: overlay)
            render.fillColor = UIColor.yellow
            return render
        }
        return MKOverlayPathRenderer(overlay: overlay)
    }
}

extension MKMapView {
    //缩放级别
    var zoomLevel: Int {
        //获取缩放级别
        get {
            return Int(log2(360 * (Double(self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1)
        }
        //设置缩放级别
        set (newZoomLevel) {
            setCenterCoordinate(coordinate: self.centerCoordinate, zoomLevel: newZoomLevel, animated: true)
        }
    }
     
    //设置缩放级别时调用
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        let region = MKCoordinateRegion(center: self.centerCoordinate, span: span)
        setRegion(region, animated: animated)
        
//        let span = MKCoordinateSpanMake(0, 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
//        setRegion(MKCoordinateRegionMake(centerCoordinate, span), animated: animated)
    }
}
