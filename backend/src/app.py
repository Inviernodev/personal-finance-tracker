"""
Main Flask application
Personal Finance Tracker API
"""
from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from config import config
from sqlalchemy import text

# Initialize Flask app
app = Flask(__name__)
app.config.from_object(config)

# Enable CORS (Cross-Origin Resource Sharing) for frontend
CORS(app)

# Initialize SQLAlchemy (database ORM)
db = SQLAlchemy(app)

# ============================================================================
# ROUTES / ENDPOINTS
# ============================================================================

@app.route('/')
def index():
    """Root endpoint - API information"""
    return jsonify({
        'name': 'Personal Finance Tracker API',
        'version': '1.0.0',
        'status': 'running',
        'endpoints': {
            'health': '/api/health',
            'docs': '/api/docs'
        }
    })

@app.route('/api/health')
def health_check():
    """Health check endpoint - verifies API and database are working"""
    try:
        # Test database connection
        db.session.execute(text('SELECT 1'))
        db_status = 'connected'
    except Exception as e:
        db_status = f'error: {str(e)}'
    
    return jsonify({
        'status': 'healthy',
        'database': db_status,
        'message': 'Finance Tracker API is running'
    })

@app.route('/api/docs')
def api_docs():
    """API documentation endpoint"""
    return jsonify({
        'api': 'Personal Finance Tracker',
        'version': '1.0.0',
        'available_endpoints': [
            {
                'method': 'GET',
                'path': '/',
                'description': 'API information'
            },
            {
                'method': 'GET',
                'path': '/api/health',
                'description': 'Health check (API + Database)'
            },
            {
                'method': 'GET',
                'path': '/api/docs',
                'description': 'This documentation'
            }
        ],
        'coming_soon': [
            '/api/users',
            '/api/transactions',
            '/api/budgets',
            '/api/analytics'
        ]
    })

from sqlalchemy import text

@app.route('/api/test/database')
def test_database():
    """Test database by querying categories"""
    try:
        # Execute a simple query
        result = db.session.execute(text('SELECT COUNT(*) as count FROM categories'))
        category_count = result.fetchone()[0]
        
        # Query sample data - WRAP THIS IN text() TOO
        result = db.session.execute(text('''
            SELECT category_name, category_type 
            FROM categories 
            LIMIT 5
        '''))
        categories = [
            {'name': row[0], 'type': row[1]} 
            for row in result.fetchall()
        ]
        
        return jsonify({
            'status': 'success',
            'database': 'connected',
            'total_categories': category_count,
            'sample_categories': categories
        })
    
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 500
    
# ============================================================================
# ERROR HANDLERS
# ============================================================================

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({
        'error': 'Not Found',
        'message': 'The requested endpoint does not exist'
    }), 404

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return jsonify({
        'error': 'Internal Server Error',
        'message': 'Something went wrong on the server'
    }), 500

# ============================================================================
# RUN APPLICATION
# ============================================================================

if __name__ == '__main__':
    print("=" * 60)
    print("Personal Finance Tracker API")
    print("=" * 60)
    print(f"Flask Environment: {config.DEBUG and 'Development' or 'Production'}")
    print(f"Database: {config.DB_NAME} @ {config.DB_HOST}:{config.DB_PORT}")
    print(f"API running on: http://0.0.0.0:5000")
    print("=" * 60)
    
    # Run Flask development server
    app.run(
        host='0.0.0.0',  # Listen on all network interfaces
        port=5000,
        debug=config.DEBUG
    )