import json
from channels.generic.websocket import AsyncWebsocketConsumer

class AppointmentConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()
        await self.send(text_data=json.dumps({"message": "WebSocket Connected"}))

    async def disconnect(self, close_code):
        print("WebSocket Disconnected")

    async def receive(self, text_data):
        data = json.loads(text_data)
        print(f"Received: {data}")
        await self.send(text_data=json.dumps({"message": "Received data"}))
