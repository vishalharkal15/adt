# 🚂 Railway Deployment Guide - Same Repo, Two Services

## Project Structure
```
Automated-Attendance/
├── facenet/          ← 🧠 Flask Backend
│   ├── app.py
│   ├── Procfile
│   ├── runtime.txt
│   └── requirements.txt
├── src/              ← ⚛️ React Frontend
├── vite.config.js
└── package.json
```

---

## 🚀 Deployment Steps

### 📋 Prerequisites
1. Push your code to GitHub: `https://github.com/vishalharkal15/adt.git`
2. Sign up at https://railway.app
3. Connect your GitHub account to Railway

---

## 🧠 SERVICE 1: Backend (Flask)

### 1. Create New Project
- Go to Railway Dashboard → **"New Project"**
- Select **"Deploy from GitHub repo"**
- Choose: `vishalharkal15/adt`

### 2. Configure Backend Service

**Root Directory:**
```
facenet
```
*(This tells Railway to only deploy the Flask folder)*

**Build Settings:**
- **Builder**: Nixpacks (auto-detected)
- **Build Command**: *(leave empty - Railway auto-installs from requirements.txt)*

**Start Command:**
```
gunicorn app:app
```
*(or leave empty if using Procfile)*

**Runtime:**
- Automatically uses `python-3.12.3` from `runtime.txt`

### 3. Generate Backend Domain
- Go to **Settings** → **Networking**
- Click **"Generate Domain"**
- Copy the URL (example): `https://adt.up.railway.app`
- **Save this URL** - you'll need it for the frontend!

### 4. Verify Backend
Test in browser or terminal:
```bash
curl https://adt.up.railway.app/api/total-students
```

Expected: `{"count": 0}` or similar JSON response

---

## ⚛️ SERVICE 2: Frontend (React/Vite)

### 1. Add Second Service
- In the **same Railway project**, click **"+ New"**
- Select **"GitHub Repo"**
- Choose: `vishalharkal15/adt` *(same repo!)*

### 2. Configure Frontend Service

**Root Directory:**
```
.
```
*(Dot means root - where package.json lives)*

**Build Settings:**
- **Build Command**:
```
npm install && npm run build
```

- **Start Command**:
```
npm start
```

- **Output Directory**:
```
dist
```

### 3. Environment Variables ⚠️ CRITICAL
- Go to **Variables** tab
- Add new variable:

| Name | Value |
|------|-------|
| `VITE_API_URL` | `https://adt.up.railway.app` |

*(Use the backend URL from Step 1.3)*

### 4. Generate Frontend Domain
- Go to **Settings** → **Networking**
- Click **"Generate Domain"**
- You'll get: `https://adt-frontend.up.railway.app`

### 5. Deploy
- Railway automatically builds and deploys
- Check **"Deployments"** tab for progress
- Wait for **"Success"** status

---

## ✅ Verification Checklist

### Backend Health Check
```bash
# Test each endpoint
curl https://adt.up.railway.app/api/total-students
curl https://adt.up.railway.app/api/students-today
```

### Frontend Check
1. Open `https://adt-frontend.up.railway.app`
2. Open browser DevTools → **Console**
3. Check for errors (should be none)
4. Open **Network** tab
5. Navigate to Dashboard
6. Verify requests go to: `https://adt.up.railway.app/api/...`

### CORS Verification
- No CORS errors in browser console
- API calls return data successfully
- ✅ CORS is already enabled in `facenet/app.py`:
  ```python
  from flask_cors import CORS
  CORS(app)
  ```

---

## 🔧 Configuration Summary

### Backend Service (`facenet/`)
| Setting | Value |
|---------|-------|
| Root Directory | `facenet` |
| Start Command | `gunicorn app:app` |
| Port | Auto (Railway sets `$PORT`) |
| Python Version | `3.12.3` (from runtime.txt) |

### Frontend Service (Root `/`)
| Setting | Value |
|---------|-------|
| Root Directory | `.` |
| Build Command | `npm install && npm run build` |
| Start Command | `npm start` |
| Output Dir | `dist` |
| Env Variable | `VITE_API_URL=https://adt.up.railway.app` |

---

## 🔄 Updating Your App

### Update Backend
```bash
cd /home/vishal/Videos/Automated-Attendance
# Make changes to facenet/
git add facenet/
git commit -m "Update backend"
git push
```
Railway auto-redeploys the backend service.

### Update Frontend
```bash
# Make changes to src/
git add src/
git commit -m "Update frontend"
git push
```
Railway auto-redeploys the frontend service.

### Update Backend URL (if it changes)
1. Go to Frontend service in Railway
2. Click **"Variables"**
3. Update `VITE_API_URL` to new backend URL
4. Service will auto-restart

---

## 🐛 Troubleshooting

### Backend Issues

**Problem**: Import errors or missing modules
```
Solution: Ensure all dependencies are in facenet/requirements.txt
```

**Problem**: App crashes on startup
```
Solution: Check Railway logs
- Click on backend service
- Go to "Deployments" tab
- Click latest deployment
- View build and deploy logs
```

**Problem**: 502 Bad Gateway
```
Solution: Ensure app uses Railway's $PORT
✅ Already fixed in facenet/app.py:
   port = int(os.environ.get("PORT", 5000))
```

### Frontend Issues

**Problem**: API calls go to localhost
```
Solution: Environment variable not set
- Check Railway frontend Variables tab
- Ensure VITE_API_URL is set correctly
- Redeploy if needed
```

**Problem**: CORS errors
```
Solution: Already enabled in backend
- flask_cors is in requirements.txt
- CORS(app) is in app.py
- If still errors, check backend logs
```

**Problem**: 404 on page refresh
```
Solution: SPA routing issue
- Vite preview handles this automatically
- If using serve, add: serve -s dist
```

### Database Issues

**Problem**: Data lost after redeploy
```
Solution: Railway filesystem is ephemeral
- SQLite data is lost on restart
- Use Railway PostgreSQL for persistence:
  1. Click "+ New" → "Database" → "PostgreSQL"
  2. Update database.py to use PostgreSQL
  3. Set DATABASE_URL environment variable
```

---

## 📊 Expected Costs

**Railway Free Tier:**
- $5 free credits/month
- ~500 hours of runtime
- Perfect for testing and small apps

**Upgrade if needed:**
- Hobby plan: $5/month per service
- Unlimited hours

---

## 🎉 Final URLs

After deployment, you'll have:

| Service | URL | Purpose |
|---------|-----|---------|
| Backend | `https://adt.up.railway.app` | Flask API |
| Frontend | `https://adt-frontend.up.railway.app` | React App |

**Share the frontend URL** with your team! 🚀

---

## 📝 Quick Reference Commands

```bash
# Check current repo
git remote -v

# View all changes
git status

# Push updates
git add .
git commit -m "Your message"
git push

# Test backend locally
cd facenet
python app.py

# Test frontend locally  
npm run dev
```

---

## ✨ Tips

1. **Monitor Usage**: Check Railway dashboard for resource usage
2. **View Logs**: Click service → "Deployments" → Click deployment → View logs
3. **Environment Variables**: Never commit `.env` files with secrets
4. **Database**: Consider PostgreSQL for production (Railway offers it)
5. **Custom Domain**: Add your own domain in Settings → Networking

---

**Need help?** Check Railway docs: https://docs.railway.app
