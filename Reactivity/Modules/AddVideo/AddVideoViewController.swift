//
//  AddVideoViewController.swift
//  Reactivity
//
//  Created by Данила Бондаренко on 05.05.2024.
//

import UIKit
import SnapKit
import AVFoundation
import AVKit

final class AddVideoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private lazy var backButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        config.title = "x"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 25)
            return outgoing
         }
        config.baseForegroundColor = .white
        config.buttonSize = .large
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        
        return button
    }()
    
    private let videoView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        
        return view
    }()
    
    private let shutterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private lazy var switchCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        return button
    }()
    
    private var session: AVCaptureSession?
    private let previewLayer = AVCaptureVideoPreviewLayer()
    private let movieFileOutput = AVCaptureMovieFileOutput()
    private var outputFileURL: URL?
    private var isRecording = false
    
}

//MARK: - Life cycle
extension AddVideoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        videoView.layer.addSublayer(previewLayer)
        makeSubviewsSettings()
        checkCameraPosition()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeSubviewsLayout()
    }
    
    @objc
    private func dismissScreen() {
        self.dismiss(animated: true)
    }
}

//MARK: - layout and subviews
extension AddVideoViewController {
    private func makeSubviewsSettings() {
        view.addSubview(videoView)
        view.addSubview(backButton)
        view.addSubview(shutterButton)
        view.addSubview(switchCameraButton)
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    private func makeSubviewsLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(32)
        }
        
        shutterButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        switchCameraButton.snp.makeConstraints {
            $0.centerY.equalTo(backButton.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(32)
        }
        
        videoView.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(view.bounds.width),
            height: Int(view.bounds.height)
        )
        
        videoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        previewLayer.frame = videoView.bounds
    }
}

//MARK: - Setup Camera
extension AddVideoViewController {
    private func checkCameraPosition() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                
                DispatchQueue.global(qos: .utility).async {
                    self?.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                let audioDevice = AVCaptureDevice.default(for: .audio)
                if let audioInput = try? AVCaptureDeviceInput(device: audioDevice!) {
                    if session.canAddInput(audioInput) {
                        session.addInput(audioInput)
                    }
                }
                
                if session.canAddOutput(movieFileOutput) {
                    session.addOutput(movieFileOutput)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                session.startRunning()
                self.session = session
            } catch {
                print(error)
            }
        }
    }
    
    @objc
    private func didTapTakePhoto() {
        if isRecording {
            // Остановить запись
            movieFileOutput.stopRecording()
        } else {
            // Начать запись
            guard let outputFileURL = createOutputFileURL() else { return }
            movieFileOutput.startRecording(to: outputFileURL, recordingDelegate: self)
        }
        
        // Изменяем состояние записи и обновляем UI
        isRecording.toggle()
    }
    
    @objc private func switchCamera() {
        guard let session = session else { return }
        
        // Остановим существующий сеанс, чтобы изменить конфигурацию камеры
        session.stopRunning()
        
        // Получим текущее устройство ввода для видеокамеры
        guard let currentVideoInput = session.inputs.first as? AVCaptureDeviceInput else { return }
        
        // Определим, является ли текущее устройство ввода видеокамерой
        let isUsingFrontCamera = currentVideoInput.device.position == .front
        
        // Получим доступные устройства ввода для видеокамеры
        let videoDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: isUsingFrontCamera ? .back : .front).devices
        
        // Переключим устройство ввода видеокамеры на следующее доступное
        guard let newVideoDevice = videoDevices.first else { return }
        guard let newVideoInput = try? AVCaptureDeviceInput(device: newVideoDevice) else { return }
        
        // Удалим текущее устройство ввода
        session.removeInput(currentVideoInput)
        
        // Добавим новое устройство ввода
        if session.canAddInput(newVideoInput) {
            session.addInput(newVideoInput)
        }
        
        // Запустим сеанс с новой конфигурацией камеры
        
        session.startRunning()
    }
}

//MARK: - AVCaptureFileOutputRecordingDelegate
extension AddVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Ошибка записи видео: \(error.localizedDescription)")
        } else {
            self.outputFileURL = outputFileURL
            showVideoPreview()
        }
    }
    
    private func createOutputFileURL() -> URL? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let fileName = dateFormatter.string(from: Date()) + ".mov"
        return documentsPath?.appendingPathComponent(fileName)
    }
    
    private func showVideoPreview() {
        guard let outputFileURL = outputFileURL else { return }
        
        let player = AVPlayer(url: outputFileURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .portrait, body: {
    AddVideoViewController()
})
