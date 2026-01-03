# Server Setup Guide for Community Health Survey App

This guide will help you set up a backend server to store and manage survey data from the Flutter mobile application.

## Technology Stack Options

### Option 1: Node.js + Express + PostgreSQL (Recommended)

**Why this stack:**
- Easy to set up and deploy
- PostgreSQL is robust and free
- Good documentation and community support
- Works well with Flutter

### Option 2: Python + FastAPI + PostgreSQL

**Why this stack:**
- Fast and modern Python framework
- Automatic API documentation
- Easy to learn

### Option 3: Firebase (Easiest for beginners)

**Why this stack:**
- No server setup required
- Real-time database
- Free tier available
- Google handles hosting

---

## Option 1: Node.js + Express Setup

### Prerequisites
- Node.js (v16 or higher) installed
- PostgreSQL installed
- Basic knowledge of JavaScript

### Step 1: Create Project Directory

```bash
mkdir survey-server
cd survey-server
npm init -y
```

### Step 2: Install Dependencies

```bash
npm install express cors dotenv pg
npm install --save-dev nodemon
```

### Step 3: Create Project Structure

```
survey-server/
├── server.js
├── config/
│   └── database.js
├── routes/
│   └── surveys.js
├── models/
│   └── survey.js
└── .env
```

### Step 4: Create Database

```sql
-- Connect to PostgreSQL and run:
CREATE DATABASE health_survey_db;

-- Then connect to the database and create table:
CREATE TABLE surveys (
    id SERIAL PRIMARY KEY,
    survey_data JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    surveyor_name VARCHAR(255),
    area_name VARCHAR(255),
    synced BOOLEAN DEFAULT true
);

CREATE INDEX idx_area_name ON surveys(area_name);
CREATE INDEX idx_created_at ON surveys(created_at);
```

### Step 5: Create .env File

```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=health_survey_db
DB_USER=your_username
DB_PASSWORD=your_password
```

### Step 6: Create server.js

```javascript
const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const surveyRoutes = require('./routes/surveys');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/surveys', surveyRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Server is running' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
```

### Step 7: Create config/database.js

```javascript
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

module.exports = pool;
```

### Step 8: Create routes/surveys.js

```javascript
const express = require('express');
const router = express.Router();
const pool = require('../config/database');

// Get all surveys
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM surveys ORDER BY created_at DESC'
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching surveys:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get survey by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      'SELECT * FROM surveys WHERE id = $1',
      [id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Survey not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching survey:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create new survey
router.post('/', async (req, res) => {
  try {
    const { survey_data, surveyor_name, area_name } = req.body;
    
    const result = await pool.query(
      `INSERT INTO surveys (survey_data, surveyor_name, area_name)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [JSON.stringify(survey_data), surveyor_name, area_name]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error creating survey:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Sync multiple surveys
router.post('/sync', async (req, res) => {
  try {
    const { surveys } = req.body;
    const results = [];
    
    for (const survey of surveys) {
      const { survey_data, surveyor_name, area_name } = survey;
      const result = await pool.query(
        `INSERT INTO surveys (survey_data, surveyor_name, area_name)
         VALUES ($1, $2, $3)
         RETURNING *`,
        [JSON.stringify(survey_data), surveyor_name, area_name]
      );
      results.push(result.rows[0]);
    }
    
    res.status(201).json({ message: 'Surveys synced successfully', count: results.length });
  } catch (error) {
    console.error('Error syncing surveys:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update survey
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { survey_data, surveyor_name, area_name } = req.body;
    
    const result = await pool.query(
      `UPDATE surveys 
       SET survey_data = $1, surveyor_name = $2, area_name = $3, updated_at = CURRENT_TIMESTAMP
       WHERE id = $4
       RETURNING *`,
      [JSON.stringify(survey_data), surveyor_name, area_name, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Survey not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating survey:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete survey
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      'DELETE FROM surveys WHERE id = $1 RETURNING *',
      [id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Survey not found' });
    }
    
    res.json({ message: 'Survey deleted successfully' });
  } catch (error) {
    console.error('Error deleting survey:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
```

### Step 9: Update package.json

```json
{
  "name": "survey-server",
  "version": "1.0.0",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  }
}
```

### Step 10: Run the Server

```bash
npm run dev
```

The server will run on `http://localhost:3000`

---

## Option 2: Python + FastAPI Setup

### Prerequisites
- Python 3.8+ installed
- PostgreSQL installed

### Step 1: Create Project Directory

```bash
mkdir survey-server-python
cd survey-server-python
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### Step 2: Install Dependencies

```bash
pip install fastapi uvicorn psycopg2-binary python-dotenv
```

### Step 3: Create main.py

```python
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import psycopg2
from psycopg2.extras import RealDictCursor
import json
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database connection
def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        database=os.getenv("DB_NAME", "health_survey_db"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        cursor_factory=RealDictCursor
    )

# Models
class SurveyData(BaseModel):
    survey_data: dict
    surveyor_name: Optional[str] = None
    area_name: Optional[str] = None

class SurveySync(BaseModel):
    surveys: List[dict]

# Routes
@app.get("/api/health")
def health_check():
    return {"status": "OK", "message": "Server is running"}

@app.get("/api/surveys")
def get_surveys():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM surveys ORDER BY created_at DESC")
    surveys = cur.fetchall()
    cur.close()
    conn.close()
    return surveys

@app.get("/api/surveys/{survey_id}")
def get_survey(survey_id: int):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM surveys WHERE id = %s", (survey_id,))
    survey = cur.fetchone()
    cur.close()
    conn.close()
    
    if not survey:
        raise HTTPException(status_code=404, detail="Survey not found")
    return survey

@app.post("/api/surveys")
def create_survey(survey: SurveyData):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO surveys (survey_data, surveyor_name, area_name) VALUES (%s, %s, %s) RETURNING *",
        (json.dumps(survey.survey_data), survey.surveyor_name, survey.area_name)
    )
    new_survey = cur.fetchone()
    conn.commit()
    cur.close()
    conn.close()
    return new_survey

@app.post("/api/surveys/sync")
def sync_surveys(sync_data: SurveySync):
    conn = get_db_connection()
    cur = conn.cursor()
    results = []
    
    for survey in sync_data.surveys:
        cur.execute(
            "INSERT INTO surveys (survey_data, surveyor_name, area_name) VALUES (%s, %s, %s) RETURNING *",
            (json.dumps(survey.get('survey_data', survey)), survey.get('surveyor_name'), survey.get('area_name'))
        )
        results.append(cur.fetchone())
    
    conn.commit()
    cur.close()
    conn.close()
    return {"message": "Surveys synced successfully", "count": len(results)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3000)
```

### Step 4: Run the Server

```bash
uvicorn main:app --reload --port 3000
```

---

## Option 3: Firebase Setup (Easiest)

### Step 1: Create Firebase Project
1. Go to https://console.firebase.google.com
2. Create a new project
3. Enable Firestore Database
4. Get your Firebase configuration

### Step 2: Update Flutter App

Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^2.24.2
  cloud_firestore: ^4.13.6
```

Update `lib/services/api_service.dart` to use Firestore instead of HTTP.

---

## Deployment Options

### Heroku (Easy)
1. Create account at heroku.com
2. Install Heroku CLI
3. `heroku create your-app-name`
4. `git push heroku main`

### DigitalOcean (Affordable)
1. Create Droplet
2. Install Node.js and PostgreSQL
3. Clone your code
4. Run with PM2: `pm2 start server.js`

### AWS (Scalable)
1. Use AWS RDS for PostgreSQL
2. Deploy server on EC2 or Lambda
3. Use API Gateway for endpoints

---

## Update Flutter App API URL

In `lib/services/api_service.dart`, update:

```dart
static const String baseUrl = 'https://your-server-url.com/api';
```

For local testing:
- Android Emulator: `http://10.0.2.2:3000/api`
- iOS Simulator: `http://localhost:3000/api`
- Physical Device: `http://YOUR_COMPUTER_IP:3000/api`

---

## Testing the API

Use Postman or curl:

```bash
# Health check
curl http://localhost:3000/api/health

# Create survey
curl -X POST http://localhost:3000/api/surveys \
  -H "Content-Type: application/json" \
  -d '{"survey_data": {...}, "surveyor_name": "Test", "area_name": "Test Area"}'
```

---

## Security Recommendations

1. Add authentication (JWT tokens)
2. Use HTTPS in production
3. Validate all input data
4. Add rate limiting
5. Use environment variables for secrets
6. Regular database backups

---

## Support

For issues or questions, refer to:
- Express.js: https://expressjs.com
- PostgreSQL: https://www.postgresql.org/docs/
- FastAPI: https://fastapi.tiangolo.com

