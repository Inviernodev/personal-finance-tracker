-- Create a test user
INSERT INTO users (username, email, password_hash) VALUES
('pablo_test', 'pablo.test@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5aqgX6C3qCF6i');
-- Password is: "password123" (hashed)
-- user_id will be 1

-- Create user's accounts
INSERT INTO accounts (user_id, account_name, account_type, balance, currency) VALUES
(1, 'Cuenta Corriente Banco Chile', 'checking', 850000.00, 'CLP'),
(1, 'Cuenta de Ahorro', 'savings', 1200000.00, 'CLP'),
(1, 'Tarjeta de Crédito', 'credit_card', -150000.00, 'CLP'),
(1, 'Efectivo', 'cash', 50000.00, 'CLP');

-- Create custom user categories (in addition to default ones)
INSERT INTO categories (user_id, category_name, category_type, icon) VALUES
(1, 'Proyectos Freelance', 'income', 'code'),
(1, 'Café', 'expense', 'coffee');

-- Create January 2026 transactions (Income)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date) VALUES
-- Salary (beginning of month)
(1, 1, 1, 'income', 650000.00, 'Salario Enero 2026', '2026-01-01'),

-- Freelance income
(1, 1, 16, 'income', 150000.00, 'Desarrollo sitio web cliente', '2026-01-08'),
(1, 1, 16, 'income', 200000.00, 'Proyecto Python automatización', '2026-01-20');

-- Create January 2026 transactions (Expenses)
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date) VALUES
-- Housing
(1, 1, 7, 'expense', 250000.00, 'Arriendo departamento', '2026-01-05'),

-- Utilities
(1, 1, 8, 'expense', 35000.00, 'Luz (CGE)', '2026-01-10'),
(1, 1, 8, 'expense', 25000.00, 'Agua', '2026-01-10'),
(1, 1, 8, 'expense', 18000.00, 'Gas', '2026-01-12'),
(1, 1, 8, 'expense', 32000.00, 'Internet fibra óptica', '2026-01-15'),

-- Food
(1, 2, 5, 'expense', 65000.00, 'Supermercado Jumbo', '2026-01-03'),
(1, 4, 5, 'expense', 8500.00, 'Almuerzo restaurant', '2026-01-06'),
(1, 2, 5, 'expense', 45000.00, 'Supermercado Líder', '2026-01-10'),
(1, 4, 5, 'expense', 12000.00, 'Delivery Rappi', '2026-01-12'),
(1, 2, 5, 'expense', 38000.00, 'Feria verduras y frutas', '2026-01-14'),
(1, 4, 17, 'expense', 4500.00, 'Café Starbucks', '2026-01-07'),
(1, 4, 17, 'expense', 3800.00, 'Café local', '2026-01-11'),
(1, 4, 17, 'expense', 5200.00, 'Café + pastelería', '2026-01-15'),

-- Transportation
(1, 4, 6, 'expense', 15000.00, 'Carga Bip! Metro', '2026-01-02'),
(1, 4, 6, 'expense', 12500.00, 'Uber centro - casa', '2026-01-09'),
(1, 4, 6, 'expense', 18000.00, 'Taxi aeropuerto', '2026-01-13'),
(1, 4, 6, 'expense', 8500.00, 'Bencinera (emergencia)', '2026-01-14'),

-- Entertainment
(1, 3, 9, 'expense', 15000.00, 'Cine Hoyts 2 entradas', '2026-01-04'),
(1, 3, 9, 'expense', 35000.00, 'Bar amigos', '2026-01-11'),
(1, 3, 9, 'expense', 22000.00, 'Concierto local', '2026-01-13'),

-- Subscriptions
(1, 3, 13, 'expense', 8990.00, 'Netflix Premium', '2026-01-01'),
(1, 3, 13, 'expense', 5990.00, 'Spotify Premium', '2026-01-01'),
(1, 3, 13, 'expense', 12990.00, 'Amazon Prime', '2026-01-05'),
(1, 3, 13, 'expense', 7500.00, 'ChatGPT Plus', '2026-01-08'),

-- Health
(1, 2, 10, 'expense', 45000.00, 'Farmacia medicamentos', '2026-01-07'),
(1, 2, 10, 'expense', 28000.00, 'Consulta médica', '2026-01-12'),

-- Education
(1, 2, 11, 'expense', 89000.00, 'Curso online Udemy - Docker', '2026-01-03'),
(1, 2, 11, 'expense', 25000.00, 'Libros técnicos Amazon', '2026-01-09'),

-- Clothing
(1, 3, 12, 'expense', 45000.00, 'Zapatillas', '2026-01-06'),
(1, 3, 12, 'expense', 32000.00, 'Poleras (2)', '2026-01-14'),

-- Other expenses
(1, 4, 14, 'expense', 15000.00, 'Regalo cumpleaños amigo', '2026-01-11'),
(1, 4, 14, 'expense', 8500.00, 'Varios misceláneos', '2026-01-15');

-- Add some December 2025 transactions for trend comparison
INSERT INTO transactions (user_id, account_id, category_id, transaction_type, amount, description, transaction_date) VALUES
-- December income
(1, 1, 1, 'income', 650000.00, 'Salario Diciembre 2025', '2025-12-01'),
(1, 1, 2, 'income', 100000.00, 'Freelance diciembre', '2025-12-15'),

-- December expenses (less than January for trend visualization)
(1, 1, 7, 'expense', 250000.00, 'Arriendo', '2025-12-05'),
(1, 2, 5, 'expense', 95000.00, 'Supermercado', '2025-12-08'),
(1, 4, 6, 'expense', 28000.00, 'Transporte', '2025-12-10'),
(1, 3, 9, 'expense', 65000.00, 'Entretenimiento (fiestas)', '2025-12-20'),
(1, 2, 10, 'expense', 35000.00, 'Salud', '2025-12-12'),
(1, 3, 13, 'expense', 27970.00, 'Suscripciones', '2025-12-01');

-- Create budgets for January 2026
INSERT INTO budgets (user_id, category_id, amount, month, year) VALUES
(1, 5, 150000.00, 1, 2026),   -- Alimentación: 150k budget
(1, 6, 80000.00, 1, 2026),    -- Transporte: 80k budget
(1, 7, 250000.00, 1, 2026),   -- Vivienda: 250k budget
(1, 8, 120000.00, 1, 2026),   -- Servicios: 120k budget
(1, 9, 50000.00, 1, 2026),    -- Entretenimiento: 50k budget
(1, 10, 50000.00, 1, 2026),   -- Salud: 50k budget
(1, 11, 100000.00, 1, 2026),  -- Educación: 100k budget
(1, 12, 80000.00, 1, 2026),   -- Ropa: 80k budget
(1, 13, 40000.00, 1, 2026);   -- Suscripciones: 40k budget

-- Create budget alerts (some already triggered)
INSERT INTO budget_alerts (budget_id, threshold_percentage, is_triggered, triggered_at) VALUES
(1, 80, true, '2026-01-14 10:30:00'),    -- Food budget at 80%
(1, 100, false, NULL),                    -- Food budget not at 100% yet
(5, 80, true, '2026-01-13 15:45:00'),    -- Entertainment at 80%
(5, 100, true, '2026-01-13 18:20:00'),   -- Entertainment exceeded!
(9, 80, true, '2026-01-05 09:15:00'),    -- Subscriptions at 80%
(9, 100, false, NULL);

-- Create recurring transactions (automatic monthly expenses)
INSERT INTO recurring_transactions 
(user_id, account_id, category_id, transaction_type, amount, description, frequency, start_date, next_occurrence, is_active) 
VALUES
(1, 1, 7, 'expense', 250000.00, 'Arriendo mensual', 'monthly', '2026-01-05', '2026-02-05', true),
(1, 3, 13, 'expense', 8990.00, 'Netflix Premium', 'monthly', '2026-01-01', '2026-02-01', true),
(1, 3, 13, 'expense', 5990.00, 'Spotify Premium', 'monthly', '2026-01-01', '2026-02-01', true),
(1, 1, 1, 'income', 650000.00, 'Salario mensual', 'monthly', '2026-01-01', '2026-02-01', true);

-- Update account balances to reflect all transactions
-- Checking account: 850000 initial + 1000000 income - transactions
UPDATE accounts SET balance = 850000.00 WHERE account_id = 1;

-- Savings account: mainly for transfers
UPDATE accounts SET balance = 1200000.00 WHERE account_id = 2;

-- Credit card: negative balance
UPDATE accounts SET balance = -150000.00 WHERE account_id = 3;

-- Cash: small amount
UPDATE accounts SET balance = 50000.00 WHERE account_id = 4;

-- Verify the data
-- Check transaction count
SELECT 
    'Total Transactions' as metric,
    COUNT(*) as value 
FROM transactions 
WHERE user_id = 1;

-- Check January 2026 summary
SELECT 
    transaction_type,
    COUNT(*) as transaction_count,
    SUM(amount) as total_amount
FROM transactions
WHERE user_id = 1 
    AND YEAR(transaction_date) = 2026 
    AND MONTH(transaction_date) = 1
GROUP BY transaction_type;

-- Check spending by category (January 2026)
SELECT 
    c.category_name,
    COUNT(t.transaction_id) as transactions,
    SUM(t.amount) as total_spent
FROM transactions t
JOIN categories c ON t.category_id = c.category_id
WHERE t.user_id = 1 
    AND t.transaction_type = 'expense'
    AND YEAR(t.transaction_date) = 2026 
    AND MONTH(t.transaction_date) = 1
GROUP BY c.category_name
ORDER BY total_spent DESC;