💬 Flutter Real-Time Chat App
A cross-platform real-time chat application built with Flutter and Socket.IO, supporting both mobile (Android) and web platforms.

🚀 Features
⚡ Real-time messaging powered by Socket.IO

✍️ Typing indicators to show user activity

💬 chat bubbles

📱 Responsive UI for mobile and web

🔄 Auto-scroll and message grouping

🧑‍💻 Clean and intuitive user experience

📡 Socket.IO Events
The following socket events are used for real-time communication between the client and the server:

| Event Name       | Direction         | Description                                                          |
| ---------------- | ----------------  | -------------------------------------------------------------------- |
| `sendMessage`    | Client ➜ Server  | Triggered when a user sends a new message.                           |
| `receiveMessage` | Server ➜ Clients | Broadcasts a new message to all connected clients except the sender. |
| `typing`         | Client ➜ Server  | Emitted when a user is typing (e.g., showing typing indicators).     |
| `typing`         | Server ➜ Clients | Broadcasts the typing status to other clients.                       |
| `connect`        | Built-in          | Triggered automatically when a client connects to the server.        |
| `disconnect`     | Built-in          | Triggered automatically when a client disconnects from the server.   |


🛠️ Getting Started
🔧 Prerequisites
Ensure the following are installed:

Flutter SDK (v3.13 or later recommended)

Node.js

Git

📲 Running the App
1️⃣ Clone the Repository

git clone https://github.com/harshabarlanka/flutter_realtime_chat_app.git

cd flutter_realtime_chat_app

2️⃣ Install Flutter Packages

flutter pub get

3️⃣ Set Up the Socket.IO Server on second terminal

cd flutter_realtime_chat_app

Use the official Socket.IO backend for this project:

🔗 Socket.IO Backend GitHub Repository:

git clone https://github.com/socketio/socket.io.git

cd socket.io/examples/chat

npm install

node index.js

✅ The server will run on: http://localhost:3000 (Please use your own Localhost IPv4 Address in the below code in place of 192.168.29.***)

socket = IO.io('http://192.168.29.***:3000', -> You can find this code in the services folder socket_service.dart

4️⃣ Run the Flutter App

Android/iOS:

flutter run

Web (Chrome):

flutter run -d chrome

Thank You
