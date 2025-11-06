#!/bin/bash

# Script to create separate frontend repository for Railway deployment
# Run this from the Automated-Attendance project root

echo "🚀 Creating Frontend Repository for Railway Deployment"
echo "=================================================="

# Check if we're in the right directory
if [ ! -d "src" ]; then
    echo "❌ Error: src directory not found. Run this from project root."
    exit 1
fi

# Create frontend directory
FRONTEND_DIR="../automated-attendance-frontend"
echo "📁 Creating frontend directory: $FRONTEND_DIR"
mkdir -p "$FRONTEND_DIR"

# Copy frontend files
echo "📋 Copying frontend files..."
cp -r src "$FRONTEND_DIR/"
cp -r public "$FRONTEND_DIR/"
cp index.html "$FRONTEND_DIR/"
cp package.json "$FRONTEND_DIR/"
cp package-lock.json "$FRONTEND_DIR/"
cp vite.config.js "$FRONTEND_DIR/"
cp eslint.config.js "$FRONTEND_DIR/"
cp .env.* "$FRONTEND_DIR/" 2>/dev/null || true

# Create .gitignore for frontend
echo "📝 Creating .gitignore..."
cat > "$FRONTEND_DIR/.gitignore" << 'EOF'
# Dependencies
node_modules/
.pnp
.pnp.js

# Testing
coverage/

# Production
dist/
build/

# Misc
.DS_Store
*.log
*.log.*

# Environment
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF

# Create README for frontend
echo "📝 Creating README..."
cat > "$FRONTEND_DIR/README.md" << 'EOF'
# Automated Attendance - Frontend

React + Vite frontend for automated attendance system with facial recognition.

## Tech Stack
- React 19
- Vite
- React Router
- Axios
- Chart.js
- React Icons

## Local Development

1. Install dependencies:
```bash
npm install
```

2. Create `.env.development`:
```env
VITE_API_URL=http://localhost:5000
```

3. Run dev server:
```bash
npm run dev
```

Frontend runs on `http://localhost:5173`

## Production Build

```bash
npm run build
```

Output directory: `dist/`

## Railway Deployment

This frontend is configured for Railway.app:

### Build Settings
- **Build Command**: `npm run build`
- **Start Command**: `npm run preview`
- **Output Directory**: `dist`

### Environment Variables (Required)
Set in Railway dashboard:
- `VITE_API_URL`: Your Railway backend URL
  - Example: `https://your-backend-name.up.railway.app`

## Features

- 📸 Real-time face detection
- 👤 Student enrollment
- 📊 Attendance dashboard
- 📈 Weekly statistics
- 📄 CSV export
- 🔒 Admin authentication

## Pages

- `/` - Live attendance tracking
- `/enroll` - Student enrollment
- `/admin` - Admin login
- `/dashboard` - Analytics dashboard
EOF

cd "$FRONTEND_DIR"

# Update package.json for Railway
echo "📝 Updating package.json for Railway..."
if command -v node >/dev/null 2>&1; then
    node -e "
    const fs = require('fs');
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    pkg.scripts = pkg.scripts || {};
    pkg.scripts.start = 'vite preview --host 0.0.0.0 --port \$PORT';
    fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
    console.log('✅ package.json updated');
    " 2>/dev/null || echo "⚠️  Manually add start script to package.json"
fi

# Initialize git
echo "🔧 Initializing git repository..."
git init
git add .
git commit -m "Initial frontend setup for Railway deployment"

echo ""
echo "✅ Frontend repository created successfully!"
echo ""
echo "📍 Location: $FRONTEND_DIR"
echo ""
echo "Next steps:"
echo "1. Create a new GitHub repository: https://github.com/new"
echo "2. Repository name: automated-attendance-frontend"
echo "3. Run these commands in $FRONTEND_DIR:"
echo ""
echo "   cd $FRONTEND_DIR"
echo "   git remote add origin https://github.com/YOUR_USERNAME/automated-attendance-frontend.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "4. After deploying backend, update .env.production with backend URL"
echo ""
