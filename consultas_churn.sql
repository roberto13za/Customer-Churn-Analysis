-- ==============================================================================
-- PROJECT: DATABASE OPTIMIZATION & CHURN REPORTING
-- PROYECTO: OPTIMIZACIÓN DE BASE DE DATOS Y REPORTING DE CHURN
-- SERVICE / SERVICIO: Telecomunicaciones (PostgreSQL)
-- PROTOCOL / PROTOCOLO: Refactoring & Best Practices / Refactorización y Buenas Prácticas
-- ==============================================================================

-- ==============================================================================
-- 1. DATA DEFINITION LANGUAGE (DDL) / DEFINICIÓN DE LA ESTRUCTURA DE DATOS (DDL)
-- ==============================================================================
-- EN: snake_case applied to all columns to standardize the repository.
-- ES: Se aplica snake_case a todas las columnas para estandarizar el repositorio.


CREATE TABLE clientes_churn (
    customer_id VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(20),
    senior_citizen INT,
    partner VARCHAR(10),
    dependents VARCHAR(10),
    tenure INT,
    phone_service VARCHAR(10),
    multiple_lines VARCHAR(30),
    internet_service VARCHAR(30),
    online_security VARCHAR(30),
    online_backup VARCHAR(30),
    device_protection VARCHAR(30),
    tech_support VARCHAR(30),
    streaming_tv VARCHAR(30),
    streaming_movies VARCHAR(30),
    contract_type VARCHAR(30), -- Renamed to prevent reserved word conflicts / Renombrado para evitar conflicto con palabra reservada 'Contract'
    paperless_billing VARCHAR(10),
    payment_method VARCHAR(50),
    monthly_charges FLOAT,
    total_charges FLOAT,
    churn INT,
    arpu FLOAT,
    high_risk INT
);

-- ==============================================================================
-- 2. DATA INGESTION / INGESTA DE DATOS
-- ==============================================================================
-- EN: Ingesting processed data from the cleaned CSV dataset.
-- ES: Ingesta de datos desde el dataset procesado CSV.

COPY clientes_churn  
FROM 'C:\Users\Public\Churn_Cleaned.csv'  
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- ==============================================================================
-- 3. BUSINESS INTELLIGENCE QUERIES (DML) / QUERIES DE INTELIGENCIA DE NEGOCIO (DML)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- QUERY 1: REVENUE DISTRIBUTION ANALYSIS BY CONTRACT TYPE
-- CONSULTA 1: ANÁLISIS DE DISTRIBUCIÓN DE INGRESOS POR TIPO DE CONTRATO
--
-- Business Problem (EN): Evaluate which contracts generate the highest monthly cash 
-- flow and calculate the average revenue per user (ARPU) for each contract type.
-- Problema de negocio (ES): Evaluar qué contratos generan el mayor flujo de caja mensual
-- y calcular el valor promedio por usuario (ARPU) en cada modalidad contractual.
-- ------------------------------------------------------------------------------
WITH contract_summary_cte AS (
    SELECT  
        c.contract_type AS contract_type, 
        COUNT(*) AS total_customers, 
        ROUND(SUM(c.monthly_charges)::numeric, 2) AS total_monthly_revenue
    FROM clientes_churn AS c
    GROUP BY c.contract_type
)
SELECT 
    rc.contract_type,
    rc.total_customers,
    rc.total_monthly_revenue,
    ROUND((rc.total_monthly_revenue / rc.total_customers)::numeric, 2) AS avg_per_contract
FROM contract_summary_cte AS rc;


-- ------------------------------------------------------------------------------
-- QUERY 2: HIGHEST BILLING RANKING BY CONTRACTUAL SEGMENT
-- CONSULTA 2: RANKING DE FACTURACIÓN MÁS ALTA POR SEGMENTO CONTRACTUAL
--
-- Business Problem (EN): Identify and rank the top paying customers within each 
-- contract type to prioritize high-value (VIP) retention and loyalty campaigns.
-- Problema de negocio (ES): Identificar y rankear a los clientes que pagan las tarifas
-- más altas en cada tipo de contrato para priorizar campañas de fidelización VIP.
-- ------------------------------------------------------------------------------
SELECT 
    c.customer_id AS customer_id, 
    c.contract_type AS contract_type, 
    c.monthly_charges AS monthly_charges,
    RANK() OVER (
        PARTITION BY c.contract_type 
        ORDER BY c.monthly_charges DESC
    ) AS cost_rank
FROM clientes_churn AS c
LIMIT 10;


-- ------------------------------------------------------------------------------
-- QUERY 3: TECH SUPPORT IMPACT ON CUSTOMER CHURN RATE
-- CONSULTA 3: IMPACTO DEL SOPORTE TÉCNICO EN LA TASA DE DESERCIÓN
--
-- Business Problem (EN): Measure the direct impact of technical support services 
-- on customer retention to justify resource allocation and budget investment in support.
-- Problema de negocio (ES): Medir el impacto directo que tiene el servicio de soporte 
-- técnico en la retención del cliente para justificar inversiones en el área de soporte.
-- ------------------------------------------------------------------------------
SELECT 
    c.tech_support AS tech_support,
    COUNT(*) AS total_customers,
    SUM(c.churn) AS total_churn,
    ROUND(
        (SUM(c.churn)::float / COUNT(*)::float * 100)::numeric, 2
    ) AS churn_rate
FROM clientes_churn AS c
GROUP BY c.tech_support
ORDER BY churn_rate DESC;


-- ------------------------------------------------------------------------------
-- QUERY 4: SEMANTIC LAYER / POWER BI DATABASE VIEW
-- CONSULTA 4: CAPA DE SEMÁNTICA / VISTA PARA POWER BI
--
-- Business Problem (EN): Create a clean and standardized abstraction layer that 
-- categorizes customer status and their monetary ticket tier for dashboard consumption.
-- Problema de negocio (ES): Crear una capa de abstracción limpia y estandarizada que 
-- categorice el estado del cliente y su nivel de ticket monetario para consumo del dashboard.
-- ------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_reporte_churn_bi AS
SELECT 
    c.customer_id AS customer_id,
    c.gender AS gender,
    c.tenure AS tenure,
    c.contract_type AS contract_type,
    c.internet_service AS internet_service,
    c.tech_support AS tech_support,
    c.monthly_charges AS monthly_charges,
    c.total_charges AS total_charges,
    c.arpu,
    c.high_risk AS high_risk,
    CASE 
        WHEN c.churn = 1 THEN 'Churn' 
        ELSE 'Loyal' 
    END AS customer_status,
    CASE 
        WHEN c.monthly_charges > 70 THEN 'High Ticket' 
        ELSE 'Low Ticket' 
    END AS price_segment
FROM clientes_churn AS c;
