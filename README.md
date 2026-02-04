# Data Warehouse SQL project

This project replicates a comprehensive data warehousing solution using Medallion architecture (Bronze/Silver/Gold) to support analytics & reporting.

## Project Overview 

![Project Architecture](docs/project%20architecture.png)

1. **Bronze Layer**: stores raw data as-is from the 2 source systems namely CRM & ERP. 
2. **Silver Layer**: involves data cleaning, data normalization process
3. **Gold Layer**: Prepare business-ready data using star schema data modeling 

![Data model](docs/data%20model.png)
## Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.