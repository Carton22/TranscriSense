import Foundation
import AVFoundation
import SwiftUI

//申请麦克风权限
func openAudioSession() {
    print("Audio Access")
    let permissionStatus = AVAudioSession.sharedInstance().recordPermission
    if permissionStatus == AVAudioSession.RecordPermission.undetermined {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
        }
    }
}

//检测麦克风权限
func checkMicroPermission() -> Bool{
    let mediaType = AVMediaType.audio
    let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
    switch authorizationStatus {
        case .notDetermined:  //用户尚未做出选择
            print("Not chosen")
            return false
        case .authorized:  //已授权
            print("Granted")
            return true
        case .denied:  //用户拒绝
            print("Denied")
            return false
        case .restricted:  //家长控制
            print("Other")
            return false
    }
}

class RecordManager {
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    let file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/record.wav")
    //开始录音
    func getVoiceDB()->Double {
        recorder!.updateMeters()
        var averageV:Float = recordManager.recorder!.averagePower(forChannel: 0)
        var maxV:Float = recordManager.recorder!.peakPower(forChannel: 0)
        var lowPassResult:Double = pow(Double(10), Double(0.05*maxV))
        // print("录音音量:\(lowPassResult)")
        return lowPassResult
    }
    func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
                                            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
                                            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
                                            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
                                            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
                                            ];

        //开始录音
        openAudioSession()
        checkMicroPermission()
        do {
            let url = URL(fileURLWithPath: file_path!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            recorder!.isMeteringEnabled = true
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }

    //结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("结束录音，保存路径：\(file_path!)")
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
    
    //播放
    func play() {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file_path!))
            print("音频长度：\(player!.duration)")
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
}

//struct recorderView_Previews: PreviewProvider {
//    static var previews: some View {
//        recorderView()
//    }
//}


