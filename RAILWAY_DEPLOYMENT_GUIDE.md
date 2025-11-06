# Railway.app Deployment Guide - Automated Attendance System

## 📋 Overview
This guide will help you deploy your Automated-Attendance project on Railway.app using **separate services** for:
- **Backend**: Flask + FaceNet API (Python)
- **Frontend**: React + Vite SPA

---

## 🎯 Prerequisites

1. **Railway.app Account**: Sign up at https://railway.app
2. **GitHub Account**: Repos created for backend and frontend
3. **Local Setup**: Project configured with environment variables

---

## 📦 Part 1: Prepare Backend for Deployment

### Backend Files Created ✅
- `facenet/Procfile` → Tells Railway how to start the app
- `facenet/runtime.txt` → Specifies Python version
- `facenet/requirements.txt` → All Python dependencies
- `facenet/.railwayignore` → Files to exclude from deployment

### Backend Configuration
Your Flask app is now configured to:
- Use environment variable `PORT` (Railway provides this)
- CORS enabled for frontend communication
- SSL disabled (Railway handles HTTPS automatically)

---

## 📦 Part 2: Prepare Frontend for Deployment

### Frontend Files Created ✅
- `src/config/api.js` → Centralized API configuration
- `.env.production` → Production environment variables
- `.env.development` → Local development variables
- Updated `vite.config.js` → Production build settings

### Frontend Configuration
All API calls now use `${API_BASE_URL}` which:
- Uses `VITE_API_URL` environment variable in production
- Falls back to `http://localhost:5000` in development

---

## 🚀 Part 3: Create GitHub Repositories

### Option A: Separate Repositories (Recommended)

#### 1. Create Backend Repository
```bash
# Navigate to project root
cd /home/vishal/Videos/Automated-Attendance

# Create backend-only repo
mkdir -p ../automated-attendance-backend
cp -r facenet/* ../automated-attendance-backend/
cd ../automated-attendance-backend

# Initialize git
git init
git add .
git commit -m "Initial backend setup for Railway deployment"

# Create repo on GitHub and push
git remote add origin https://github.com/vishalharkal15/automated-attendance-backend.git
git branch -M main
git push -u origin main
```

#### 2. Create Frontend Repository
```bash
# Navigate back to project root
cd /home/vishal/Videos/Automated-Attendance

# Create frontend-only repo
mkdir -p ../automated-attendance-frontend
cp -r src public index.html package.json package-lock.json vite.config.js eslint.config.js .env.* ../automated-attendance-frontend/
cd ../automated-attendance-frontend

# Initialize git
git init
git add .
git commit -m "Initial frontend setup for Railway deployment"

# Create repo on GitHub and push
git remote add origin https://github.com/vishalharkal15/automated-attendance-frontend.git
git branch -M main
git push -u origin main
```

### Option B: Monorepo with Railway Root Path (Alternative)
Keep everything in one repo but use Railway's "Root Directory" setting:
- Backend service root: `/facenet`
- Frontend service root: `/` (or create `/frontend` folder)

---

## 🌐 Part 4: Deploy Backend on Railway

### Step-by-Step:

1. **Login to Railway.app** → https://railway.app

2. **Create New Project**
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose `automated-attendance-backend` repo

3. **Configure Backend Service**
   - Railway auto-detects Python
   - Click on the service → "Settings"
   
4. **Verify Build Settings**
   - **Build Command**: (leave empty - Railway uses requirements.txt)
   - **Start Command**: `gunicorn app:app` (from Procfile)
   - **Root Directory**: `/` (or `/facenet` if using monorepo)

5. **Environment Variables** (if needed)
   - Click "Variables" tab
   - Add any custom environment variables
   - Railway automatically provides `PORT`

6. **Generate Domain**
   - Go to "Settings" → "Networking"
   - Click "Generate Domain"
   - Copy the URL (e.g., `https://your-backend-name.up.railway.app`)

7. **Deploy**
   - Railway automatically builds and deploys
   - Check "Deployments" tab for logs
   - Wait for "Success" status

---

## 🌐 Part 5: Deploy Frontend on Railway

### Step-by-Step:

1. **Add New Service to Project**
   - In the same Railway project
   - Click "+ New" → "GitHub Repo"
   - Select `automated-attendance-frontend` repo

2. **Configure Frontend Service**
   - Railway auto-detects Node.js

3. **Set Build Settings**
   - Click service → "Settings"
   - **Build Command**: `npm run build`
   - **Start Command**: `npm run preview` (or use static server)
   - **Root Directory**: `/` (or `/frontend` if monorepo)

4. **Environment Variables** ⚠️ CRITICAL
   - Click "Variables" tab
   - Add: `VITE_API_URL` = `https://your-backend-name.up.railway.app`
   - (Use the backend URL from Step 6 above)

5. **Install Script** (Optional - for static serving)
   Add to package.json:
   ```json
   "scripts": {
     "start": "vite preview --host 0.0.0.0 --port $PORT"
   }
   ```
   Then set Start Command to: `npm start`

6. **Generate Domain**
   - "Settings" → "Networking"
   - "Generate Domain"
   - Copy URL (e.g., `https://your-frontend-name.up.railway.app`)

7. **Deploy**
   - Railway builds and deploys
   - Check logs for any errors

---

## ✅ Part 6: Verify Deployment

### Backend Health Check
```bash
# Test backend API
curl https://your-backend-name.up.railway.app/api/total-students
```

Expected response:
```json
{"count": 0}
```

### Frontend Check
1. Visit `https://your-frontend-name.up.railway.app`
2. Open browser DevTools → Network tab
3. Navigate to Dashboard
4. Verify API calls go to your Railway backend (not localhost)

### CORS Check
- Frontend should successfully fetch data from backend
- No CORS errors in browser console

---

## 🔧 Part 7: Update Environment Variables (Post-Deployment)

### Update .env.production locally
```bash
cd /home/vishal/Videos/Automated-Attendance
echo "VITE_API_URL=https://your-backend-name.up.railway.app" > .env.production
```

### Redeploy Frontend if needed
```bash
cd ../automated-attendance-frontend
git add .env.production
git commit -m "Update API URL for production"
git push origin main
```
Railway auto-redeploys on push.

---

## 🐛 Troubleshooting

### Backend Issues
- **Error: Module not found** → Check `requirements.txt` has all dependencies
- **Error: Port already in use** → Ensure app uses `os.environ.get("PORT")`
- **500 Error** → Check Railway logs: Service → "Deployments" → Click deployment

### Frontend Issues
- **API calls to localhost** → Environment variable not set correctly
- **CORS errors** → Backend CORS not enabled or wrong origin
- **404 on refresh** → Add redirect rules for SPA routing

### Database Issues
- **SQLite in production**: Railway ephemeral filesystem means data is lost on redeploy
- **Solution**: Use Railway's PostgreSQL addon or persistent volume
  - Add PostgreSQL: Click "+ New" → "Database" → "Add PostgreSQL"
  - Update `database.py` to use PostgreSQL instead of SQLite

---

## 📝 Important Notes

1. **Environment Variables**: Must start with `VITE_` for Vite to expose them
2. **Build Time**: First deploy takes longer (installing dependencies)
3. **Free Tier**: Railway gives $5 free credit/month
4. **SSL/HTTPS**: Railway provides automatic HTTPS - don't add SSL certs
5. **Database Persistence**: SQLite files are lost on redeploy - use PostgreSQL for production

---

## 🎉 Deployment Complete!

Your application is now live:
- **Frontend**: https://your-frontend-name.up.railway.app
- **Backend**: https://your-backend-name.up.railway.app

Share your frontend URL to access the attendance system from anywhere!
