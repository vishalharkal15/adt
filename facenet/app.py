from flask import Flask
from flask_cors import CORS
from mtcnn import MTCNN
from keras_facenet import FaceNet

# Initialize Flask
app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024
CORS(app)

# Initialize DB
from database import init_db
db, Attendance, Student = init_db(app)

# Initialize FaceNet & MTCNN
detector = MTCNN()
embedder = FaceNet()

# Register routes
from routes import register_routes
register_routes(app, db, Attendance, detector, embedder)

if __name__ == "__main__":
    import os
    port = int(os.environ.get("PORT", 5000))
    # SSL disabled for Railway deployment - Railway handles HTTPS
    app.run(host="0.0.0.0", port=port)
