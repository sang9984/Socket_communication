import UIKit
import SocketIO

class ViewController: UIViewController {
    // 소켓 매니저를 설정
    var manager: SocketManager!
    var socket: SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 서버 URL 및 포트 설정 (Flask-SocketIO 서버와 일치해야 함)
        let serverURL = URL(string: "http://127.0.0.1:8080")!

        // 매니저 및 소켓 인스턴스를 생성
        manager = SocketManager(socketURL: serverURL, config: [.log(true), .compress])
        socket = manager.defaultSocket

        // 서버로부터 'my_event' 이벤트를 받을 때 실행되는 핸들러
        socket.on("my_event") { dataArray, ack in
            if let data = dataArray[0] as? [String: Any],
               let receivedData = data["data"] as? String {
                print("Received from server: \(receivedData)")
                
                // 서버로 다시 데이터 전송
                self.socket.emit("my_event", ["data": "Client received: \(receivedData)"])
            }
        }

        // 소켓 연결 시도
        socket.connect()
    }
}
