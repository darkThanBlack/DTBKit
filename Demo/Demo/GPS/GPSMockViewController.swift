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
class GPSMockViewController: UIViewController {
    
    private lazy var auths = XMAuthManager()
    
    private lazy var lbs = TJStaffCheckInManager()
    
    //MARK: - Timer
    
    private var timer: Timer?
    
    private var timeCount: Int = 0
    
    private func timerFire() {
        if self.timer == nil {
            let t = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeHandler), userInfo: nil, repeats: true)
            t.fire()
            self.timer = t
        }
    }
    
    private func timerInvalidate() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func timeHandler() {
        self.timeCount += 1
        guard self.timeCount % 2 == 0 else {
            return
        }
        
        var extraText = ""
        if states != .NO_PERMISSIONS {
            if let region = lbs.currentRegion {
                states = .IN_RANGE
                extraText = "\n name=\(region.name ?? "")"
            } else {
                states = .OUT_RANGE
            }
        }
        
        stateLabel.text = states.rawValue + extraText
    }
    
    enum CheckInStates: String {
        /// 初始状态 定位中
        case LOCATION_INIT
        /// 无权限
        case NO_PERMISSIONS
        /// 在考勤范围内
        case IN_RANGE
        /// 不在考勤范围内
        case OUT_RANGE
    }
    
    private var states: CheckInStates = .LOCATION_INIT
    
    //MARK: Life Cycle
    
    deinit {
        print("MOON__LOG  mock deinit successfuly...")
        
        lbs.stopLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        auths.startAuthorizations(with: [.location(.whenInUse)]) { success in
            self.states = success ? .LOCATION_INIT : .NO_PERMISSIONS
            
            if success {
                self.lbs.startLocation()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.mapView.zoomLevel = 15
                    self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
                    
                    self.lbs.locationCallback = { [weak self] p in
                        self?.mapView.centerCoordinate = p
                    }
                }
            }
        }
        
        loadViews(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timerFire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timerInvalidate()
    }
    
    @objc private func removeButtonEvent(button: UIButton) {
        lbs.stopMonitor()
        mapView.removeOverlays(mapView.overlays)
    }
    
    enum FieldKeys: String {
        case enter_latitude, enter_longitude, enter_radius
        
        var desc: String {
            switch self {
            case .enter_latitude:  return "(纬度)"
            case .enter_longitude: return "(经度)"
            case .enter_radius:    return "(半径)"
            }
        }
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
        alert.addAction(UIAlertAction(title: "添加区域", style: .default, handler: { _ in
            self.addButtonEvent(button: button)
        }))
        alert.addAction(UIAlertAction(title: "移除区域", style: .default, handler: { _ in
            self.removeButtonEvent(button: button)
        }))
        alert.addAction(UIAlertAction(title: "当前用户位置", style: .default, handler: { _ in
            self.mapView.zoomLevel = 15
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func addButtonEvent(button: UIButton) {
        let alert = UIAlertController(title: "添加区域", message: "圆形: 经纬度+半径", preferredStyle: .alert)
        creating = CreatingModel(lati: 0, longi: 0, radius: 0)
        alert.addTextField { field in
            field.placeholder = FieldKeys.enter_latitude.rawValue + "," + FieldKeys.enter_latitude.desc
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChanged), name: UITextField.textDidChangeNotification, object: field)
        }
        alert.addTextField { field in
            field.placeholder = FieldKeys.enter_longitude.rawValue + "," + FieldKeys.enter_longitude.desc
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldDidChanged), name: UITextField.textDidChangeNotification, object: field)
        }
        alert.addTextField { field in
            field.placeholder = FieldKeys.enter_radius.rawValue + "," + FieldKeys.enter_radius.desc
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
            let key = UUID().uuidString
            self.lbs.addMonitor(list: [TJStaffCheckInRegionModel(region: CLCircularRegion(center: CLLocationCoordinate2D(latitude: model.lati, longitude: model.longi), radius: model.radius, identifier: key), id: 0, name: key)])
            
            self.mapView.zoomLevel = 15
            let circle = MKCircle(center: CLLocationCoordinate2D(latitude: model.lati, longitude: model.longi).dtb.isWGS.toGCJ, radius: model.radius)
            self.mapView.addOverlay(circle)
            self.mapView.setCenter(circle.coordinate, animated: true)
        }))
        present(alert, animated: true)
    }
    
    @objc private func textFieldDidChanged(_ notification: Notification) {
        guard let field = notification.object as? UITextField,
              let value = Double(field.text ?? ""),
              let rawValue = field.placeholder?.split(separator: ",").first,
              let key = FieldKeys(rawValue: String(rawValue)) else {
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
        box.addSubview(stateLabel)
        
        mapView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(box)
        }
        actionsButton.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(box.snp.top).offset(120.0)
        }
        stateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(box.snp.centerX)
            make.top.equalTo(actionsButton.snp.bottom).offset(16.0)
            make.width.lessThanOrEqualToSuperview()
        }
    }
    
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
    
    private lazy var actionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("菜单", for: .normal)
        button.addTarget(self, action: #selector(actionsButtonEvent(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var stateLabel: UILabel = {
        let stateLabel = UILabel()
        stateLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        stateLabel.textColor = .orange
        stateLabel.text = " "
        stateLabel.numberOfLines = 0
        stateLabel.textAlignment = .center
        return stateLabel
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
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let p = userLocation.location?.coordinate {
            print("MOON__Log  userLocation latitude=\(p.latitude), longitude=\(p.longitude)")
//            mapView.centerCoordinate = p
        }
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
            setCenterCoordinate(coordinate: self.centerCoordinate, zoomLevel: newZoomLevel, animated: false)
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
