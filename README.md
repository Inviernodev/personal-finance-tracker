# Personal Finance Tracker

A full-stack personal finance management application built with Python, Flask, MySQL, and Docker.

## Features (Planned)
- Track income and expenses
- Categorize transactions
- Set monthly budgets
- View spending analytics
- Generate reports
- Visualize data with charts

## Tech Stack
- **Backend:** Python 3.10, Flask, SQLAlchemy
- **Database:** MySQL 8.0
- **Frontend:** HTML, CSS, JavaScript, Chart.js
- **Infrastructure:** Docker, Docker Compose
- **Cloud:** AWS (EC2, RDS)

## Setup Instructions

### Prerequisites
- Docker Desktop
- Git

### Installation

1. Clone the repository:
```bash
git clone <aun-sin-url>
cd personal-finance-tracker
```

2. Create `.env` file:
```bash
cp .env.example .env
# Edit .env with your passwords
```

3. Start the application:
```bash
docker-compose up -d
```

4. Access MySQL:
```bash
docker exec -it finance_tracker_db mysql -u finance_user -p
```

## Project Structure

personal-finance-tracker/
├── backend/          # Flask API
├── database/         # SQL schema and migrations
├── frontend/         # Web interface
└── docker-compose.yml

## Author
Pablo Valenzuela López

## License
MIT