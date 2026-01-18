-- Crear bd
CREATE DATABASE IF NOT EXISTS personal_finance_tracker;
USE personal_finance_tracker;

-- Tabla: users
-- Informacion usuarios
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);

-- Tabla: categorias
-- Categorias para transacciones
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NULL, -- NULL para categorias del sistema, user_id para categorias custom
    category_name VARCHAR(50) NOT NULL,
    category_type ENUM('income', 'expense') NOT NULL,
    icon VARCHAR(50) DEFAULT 'default',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_type (user_id, category_type)
);

-- Tabla: cuentas
-- Cuentas bancarias y otros tipos de cuentas
CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_type ENUM('checking', 'savings', 'credit_card', 'cash', 'investment') NOT NULL,
    balance DECIMAL(15, 0) DEFAULT 0.00, -- pesos chilenos 15 digitos sin decimales
    currency VARCHAR(3) DEFAULT 'CLP',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_active (user_id, is_active)
);

-- Tabla: transacciones
-- Todas las transacciones de ingresos y egresos
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    account_id INT NOT NULL,
    category_id INT NOT NULL,
    transaction_type ENUM('income', 'expense') NOT NULL,
    amount DECIMAL(15, 0) NOT NULL, -- pesos chilenos 15 digitos sin decimales
    description VARCHAR(255),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT,
    INDEX idx_user_date (user_id, transaction_date),
    INDEX idx_account (account_id),
    INDEX idx_category (category_id)
);

-- Tabla: budgets
-- Budget mensual por categoria
CREATE TABLE budgets (
    budget_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(15, 0) NOT NULL, -- pesos chilenos 15 digitos sin decimales
    month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
    year INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE,
    UNIQUE KEY unique_budget (user_id, category_id, month, year),
    INDEX idx_user_period (user_id, year, month)
);

-- Tabla: alertas budget
-- trackea si el usuario exede el presupuesto
CREATE TABLE budget_alerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    budget_id INT NOT NULL,
    threshold_percentage INT NOT NULL,
    is_triggered BOOLEAN DEFAULT FALSE,
    triggered_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (budget_id) REFERENCES budgets(budget_id) ON DELETE CASCADE,
    INDEX idx_budget_status (budget_id, is_triggered)
);

-- Tabla: transacciones recurrentes
-- Creacion de transacciones recurrentes AUTOMATICAS
CREATE TABLE recurring_transactions (
    recurring_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    account_id INT NOT NULL,
    category_id INT NOT NULL,
    transaction_type ENUM('income', 'expense') NOT NULL,
    amount DECIMAL(15, 0) NOT NULL, -- pesos chilenos 15 digitos sin decimales
    description VARCHAR(255),
    frequency ENUM('daily', 'weekly', 'monthly', 'yearly') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    next_occurrence DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT,
    INDEX idx_user_active (user_id, is_active),
    INDEX idx_next_occurrence (next_occurrence)
);

-- Insertar categorias defecto
INSERT INTO categories (user_id, category_name, category_type, icon) VALUES
-- Categorias de ingreso (system-wide, user_id = NULL)
(NULL, 'Salario', 'income', 'money'), -- Usuario global, nombre categoria, tipo categoria, icono -> lo  saca del frontend
(NULL, 'Freelance', 'income', 'laptop'),
(NULL, 'Inversiones', 'income', 'chart'),
(NULL, 'Otros Ingresos', 'income', 'plus'),

-- Categorias de gasto (system-wide, user_id = NULL)
(NULL, 'Alimentación', 'expense', 'food'),
(NULL, 'Transporte', 'expense', 'car'),
(NULL, 'Vivienda', 'expense', 'home'),
(NULL, 'Servicios', 'expense', 'bill'),
(NULL, 'Entretenimiento', 'expense', 'game'),
(NULL, 'Salud', 'expense', 'health'),
(NULL, 'Educación', 'expense', 'book'),
(NULL, 'Ropa', 'expense', 'shirt'),
(NULL, 'Suscripciones', 'expense', 'subscription'),
(NULL, 'Otros Gastos', 'expense', 'dots');

-- Vistas para reportes

-- Vista: Resumen de gastos mensuales por categoria
CREATE VIEW v_monthly_spending AS
SELECT 
    t.user_id,
    YEAR(t.transaction_date) AS year,
    MONTH(t.transaction_date) AS month,
    c.category_name,
    SUM(t.amount) AS total_amount,
    COUNT(*) AS transaction_count
FROM transactions t
JOIN categories c ON t.category_id = c.category_id
WHERE t.transaction_type = 'expense'
GROUP BY t.user_id, YEAR(t.transaction_date), MONTH(t.transaction_date), c.category_name;

-- Vista: Presupuesto vs Gasto real
CREATE VIEW v_budget_vs_actual AS
SELECT 
    b.user_id,
    b.year,
    b.month,
    c.category_name,
    b.amount AS budget_amount,
    COALESCE(SUM(t.amount), 0) AS actual_amount,
    b.amount - COALESCE(SUM(t.amount), 0) AS difference,
    CASE 
        WHEN b.amount > 0 THEN (COALESCE(SUM(t.amount), 0) / b.amount) * 100
        ELSE 0
    END AS percentage_used
FROM budgets b
JOIN categories c ON b.category_id = c.category_id
LEFT JOIN transactions t ON 
    b.user_id = t.user_id 
    AND b.category_id = t.category_id
    AND YEAR(t.transaction_date) = b.year
    AND MONTH(t.transaction_date) = b.month
    AND t.transaction_type = 'expense'
GROUP BY b.budget_id, b.user_id, b.year, b.month, c.category_name, b.amount;

-- vista_ resumen de cuenta
CREATE VIEW v_account_summary AS
SELECT 
    a.user_id,
    a.account_name,
    a.account_type,
    a.balance AS current_balance,
    COALESCE(SUM(CASE WHEN t.transaction_type = 'income' THEN t.amount ELSE 0 END), 0) AS total_income,
    COALESCE(SUM(CASE WHEN t.transaction_type = 'expense' THEN t.amount ELSE 0 END), 0) AS total_expenses,
    COUNT(t.transaction_id) AS transaction_count
FROM accounts a
LEFT JOIN transactions t ON a.account_id = t.account_id
WHERE a.is_active = TRUE
GROUP BY a.account_id, a.user_id, a.account_name, a.account_type, a.balance;