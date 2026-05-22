# 📊 Análisis de Retención de Clientes en Telecomunicaciones (Churn Analysis)

[![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)](https://www.python.org/)
[![SQL](https://img.shields.io/badge/SQL-PostgreSQL-blue.svg)](https://www.postgresql.org/)
[![Power BI](https://img.shields.io/badge/Dashboard-Power%20BI-orange.svg)](https://powerbi.microsoft.com/)

Este proyecto presenta un ecosistema analítico integral (End-to-End) diseñado para identificar las causas raíz de la deserción de clientes (*Churn*), utilizando un enfoque metodológico que combina ingeniería de datos, validación estadística y storytelling visual.

## 📁 Estructura del Repositorio

* **`/notebooks`**: Ingesta, limpieza profunda, *Feature Engineering* (creación de métricas como ARPU) y validación de hipótesis (*T-Test*) en Python.
* **`/sql`**: Definición de estructura (DDL), consultas avanzadas con *Window Functions* y creación de la capa semántica mediante vistas en PostgreSQL.
* **`/dashboard`**: Archivo fuente `.pbix` de Power BI y capturas de pantalla de los reportes ejecutivos.

---

## 📈 Visualización de Resultados y Hallazgos Clave

### 1. Dashboard Ejecutivo Central
Se diseñó un panel de control interactivo optimizado para monitorear la **Tasa de Abandono (fijada en 26.54%)** y el volumen de ingresos en riesgo (*Revenue at Risk*). La interfaz respeta una estricta jerarquía visual y consistencia cromática (Rojo/Ladrillo para alertas de Churn y Azul Marino para clientes retenidos).

![Dashboard Principal](dashboard_capturas/general.png)

### 2. Comportamiento Temporal e Insight Maestro
Al sustituir y analizar los datos mediante un gráfico de líneas dinámico, se descubrió un patrón crítico: **el riesgo de fuga se concentra drásticamente en los primeros meses de antigüedad del cliente** (alcanzando picos de más del 60% en el mes 1), estabilizándose a partir del segundo año.

![Análisis de Tendencias](dashboard_capturas/insight_dispersion.png)

---

## 💡 Conclusiones Técnicas y Estadísticas

1. **Validación de Hipótesis**: Mediante una prueba *T-Test* independiente en Python, se rechazó la hipótesis nula, confirmando estadísticamente ($p < 0.05$) que los clientes que abandonan la compañía enfrentan cargos mensuales significativamente más altos.
2. **Optimización de Consultas**: En PostgreSQL se implementaron funciones de ventana (`RANK() OVER(...)`) para segmentar e identificar el top de clientes de alto costo por tipo de contrato, permitiendo una acción comercial.
3. **Capa de Abstracción**: Se construyó una vista SQL (`v_reporte_churn_bi`) que actúa como capa semántica limpia para Power BI, eliminando la necesidad de transformaciones pesadas dentro del archivo `.pbix`.

---

## 👔 Conclusiones y Recomendaciones de Negocio

Tras cruzar los hallazgos de las herramientas, se definieron tres estrategias prioritarias para el equipo de *Customer Success*:

1. **Plan de Retención Prioritario para Contratos Mensuales:**
   * **Hallazgo:** Los clientes con contratos mes a mes (*Month-to-month*) representan el mayor volumen absoluto de deserción.
   * **Estrategia:** Se podria implementar una campaña automatizada de migración a planes anuales ofreciendo un incentivo del 15% de descuento durante el primer trimestre. Retener un cliente activo es drásticamente más económico que el costo de adquisición (CAC) de uno nuevo.

2. **Auditoría Técnica al Servicio de Fibra Óptica:**
   * **Hallazgo:** Los usuarios con tecnología de Fibra Óptica muestran tasas de abandono anormalmente altas durante sus primeros 6 meses de vida comercial.
   * **Estrategia:** Coordinar con el área de operaciones una auditoría de calidad en los procesos de instalación inicial. Se recomienda activar un protocolo de post-venta obligatorio (*Check-in* de satisfacción) a los 30 días de la contratación.

3. **Empaquetamiento Estratégico de Soporte Técnico:**
   * **Hallazgo:** Los clientes que carecen del servicio de soporte técnico contratado (*Tech Support*) tienen una probabilidad casi 3 veces mayor de abandonar la compañía ante la primera incidencia.
   * **Estrategia:** Subsidiar o incluir el soporte técnico básico de forma nativa dentro de los paquetes de internet premium para elevar las barreras de salida del cliente.

---

## 📥 Cómo interactuar con el proyecto

1. Para consultar los scripts de base de datos, navega a la carpeta `/sql`.
2. Para revisar las pruebas estadísticas o replicar la limpieza, abre el archivo Jupyter en `/notebooks`.
3. Si dispones de Power BI Desktop instalado en tu equipo, puedes **[descargar el archivo .pbix interactivo aquí](Dashboard_Churn.pbix)**.
