//
//  ViewController.swift
//  GradientExample
//
//  Created by Maksim Kudriavtsev on 22/01/2023.
//

import UIKit

class ViewController: UIViewController {
    private let squareContainerView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let startPointView = Point(labelXOffset: 25, labelYOffset: -25)
    private let endPointView = Point(labelXOffset: -15, labelYOffset: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(squareContainerView)
        squareContainerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        squareContainerView.center = view.center
        
        // Add gradient layer to view
        gradientLayer.frame = squareContainerView.bounds
        gradientLayer.colors = [
            UIColor(red: 0.93, green: 0.18, blue: 0.29, alpha: 1.00).cgColor,
            UIColor(red: 0.00, green: 0.62, blue: 1.00, alpha: 1.00).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        squareContainerView.layer.addSublayer(gradientLayer)
        
        // Add start point view
        startPointView.frame = CGRect(
            x: -5,
            y: -5,
            width: 10,
            height: 10
        )
        squareContainerView.addSubview(startPointView)
        
        // Add end point view
        endPointView.frame = CGRect(
            x: squareContainerView.bounds.width - 5,
            y: squareContainerView.bounds.height - 5,
            width: 10,
            height: 10
        )
        squareContainerView.addSubview(endPointView)
        
        // Add pan gesture recognizer to start point view
        let startPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        startPointView.addGestureRecognizer(startPanGesture)
        
        // Add pan gesture recognizer to end point view
        let endPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        endPointView.addGestureRecognizer(endPanGesture)
        
        updatePointLabels()
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let pointView = gesture.view!
        
        switch gesture.state {
        case .began, .changed:
            
            let translation = gesture.translation(in: view)
            
            var newX = pointView.center.x + translation.x
            var newY = pointView.center.y + translation.y
            // Constrain pointView within bounds
            newX = max(0, min(newX, squareContainerView.bounds.width))
            newY = max(0, min(newY, squareContainerView.bounds.height))
            pointView.center = CGPoint(x: newX, y: newY)
            gesture.setTranslation(.zero, in: view)
            
            let startPoint = calculatePoint(for: startPointView)
            let endPoint = calculatePoint(for: endPointView)
            
            if pointView == startPointView {
                gradientLayer.startPoint = startPoint
            } else if pointView == endPointView {
                gradientLayer.endPoint = endPoint
            }
        default:
            break
        }
        updatePointLabels()
    }
    
    func updatePointLabels() {
        let startPoint = calculatePoint(for: startPointView)
        let endPoint = calculatePoint(for: endPointView)
        
        startPointView.setText("startPoint(X: \(startPoint.x.round(to: 2)), Y: \(startPoint.y.round(to: 2)))")
        endPointView.setText("endPoint(X: \(endPoint.x.round(to: 2)), Y: \(endPoint.y.round(to: 2)))")
    }
    
    func calculatePoint(for pointView: UIView) -> CGPoint {
        let x = pointView.frame.midX / (squareContainerView.bounds.width / 100) / 100
        let y = pointView.frame.midY / (squareContainerView.bounds.width / 100) / 100
        return CGPoint(x: x, y: y)
    }
}

class Point: UIView {
    private let pointView = UIView()
    private let label = UILabel()
    private let labelYOffset: CGFloat
    private let labelXOffset: CGFloat
    
    init(labelXOffset: CGFloat, labelYOffset: CGFloat) {
        self.labelYOffset = labelYOffset
        self.labelXOffset = labelXOffset
        super.init(frame: UIScreen.main.bounds)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = pointView.bounds.inset(by: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40))
        return relativeFrame.contains(point)
    }

    func setText(_ text: String) {
        label.text = text
        label.sizeToFit()
        label.layoutIfNeeded()
        label.frame = CGRect(
            x: -(label.bounds.width / 2) + labelXOffset,
            y: labelYOffset,
            width: label.bounds.width,
            height: label.bounds.height
        )
    }
    
    private func setupLayout() {
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        addSubview(label)
        
        backgroundColor = .black
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
}


extension CGFloat {
    func round(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
