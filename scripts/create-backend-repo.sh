#!/bin/bash

# Script to create separate backend repository for Railway deployment
# Run this from the Automated-Attendance project root

echo "🚀 Creating Backend Repository for Railway Deployment"
echo "=================================================="

# Check if we're in the right directory
if [ ! -d "facenet" ]; then
    echo "❌ Error: facenet directory not found. Run this from project root."
    exit 1
fi

# Create backend directory
BACKEND_DIR="../automated-attendance-backend"
echo "📁 Creating backend directory: $BACKEND_DIR"
mkdir -p "$BACKEND_DIR"

# Copy backend files
echo "📋 Copying backend files..."
cp -r facenet/* "$BACKEND_DIR/"

# Create .gitignore for backend
echo "📝 Creating .gitignore..."
cat > "$BACKEND_DIR/.gitignore" << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/
.venv/
ENV/
*.egg-info/
dist/
build/

# Database
*.db
*.db-journal
*.sqlite3
*.sqlite3-journal

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Logs
*.log

# Environment
.env
.env.local
EOF

# Create README for backend
echo "📝 Creating README..."
cat > "$BACKEND_DIR/README.md" << 'EOF'
# Automated Attendance - Backend API

Flask backend with FaceNet facial recognition for automated attendance tracking.

## Tech Stack
- Flask
- FaceNet (keras-facenet)
- MTCNN
- SQLite / PostgreSQL
- OpenCV

## Local Development

1. Create virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate  # Windows
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run server:
```bash
python app.py
```

Server runs on `http://localhost:5000`

## Railway Deployment

This backend is configured for Railway.app deployment:
- `Procfile`: Defines start command
- `runtime.txt`: Python version
- Environment variable `PORT` is auto-provided by Railway

### Environment Variables
- `PORT`: Auto-set by Railway
- Add any custom variables in Railway dashboard

## API Endpoints

- `POST /recognize`: Face recognition
- `POST /enroll`: Enroll new student
- `POST /api/verify`: Admin authentication
- `GET /api/total-students`: Total enrolled count
- `GET /api/students-today`: Today's attendance count
- `GET /api/students-absent-today`: Absent count
- `GET /api/weekly-attendance`: Weekly stats
- `GET /api/attendance-all`: All attendance records

## Database

SQLite by default. For production on Railway:
1. Add PostgreSQL database
2. Update `database.py` to use PostgreSQL connection
3. Set `DATABASE_URL` environment variable
EOF

cd "$BACKEND_DIR"

# Initialize git
echo "🔧 Initializing git repository..."
git init
git add .
git commit -m "Initial backend setup for Railway deployment"

echo ""
echo "✅ Backend repository created successfully!"
echo ""
echo "📍 Location: $BACKEND_DIR"
echo ""
echo "Next steps:"
echo "1. Create a new GitHub repository: https://github.com/new"
echo "2. Repository name: automated-attendance-backend"
echo "3. Run these commands in $BACKEND_DIR:"
echo ""
echo "   cd $BACKEND_DIR"
echo "   git remote add origin https://github.com/YOUR_USERNAME/automated-attendance-backend.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
