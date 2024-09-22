from flask import Flask
from flask_socketio import SocketIO, emit
import time

app = Flask(__name__)
socketio = SocketIO(app)

# 클라이언트가 연결되었을 때 실행될 핸들러
@socketio.on('connect')
def send_data():
    # 클라이언트로 최초 데이터 전송
    emit('my_event', {'data': 'Server says hello!'})

# 클라이언트로부터 'my_event' 이벤트를 받았을 때 실행될 핸들러
@socketio.on('my_event')
def handle_my_event(data):
    print(f"Received from client: {data['data']}")
    
    # 받은 데이터를 기반으로 클라이언트에 다시 응답
    emit('my_event', {'data': f"Server received: {data['data']}"})

if __name__ == '__main__':
    socketio.run(app, host='127.0.0.1', port=8080, debug=True)
