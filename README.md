# Comprehensive-SQL-Data-Cleaning-for-Layoffs-Records


This project focuses on cleaning a dataset containing company layoffs data using SQL. The data was sourced from a table named `layoffs`, and various steps were taken to remove duplicates, standardize data formats, and clean up inconsistencies to ensure the data's accuracy and usability.

## Project Overview

- **Data Source**: Layoffs table
- **Objective**: Clean and preprocess the layoffs data to eliminate duplicates, correct inconsistencies, and prepare it for further analysis.

## Key Steps

1. **Creating Duplicate Table**: Created a duplicate table (`layoffs_dup`) to work on without altering the original data.
2. **Removing Duplicates**:
   - Generated row numbers to identify duplicate entries based on key columns.
   - Used a temporary table (`remove_dup_layoffs`) to store and delete duplicate rows safely.
3. **Data Cleaning**:
   - Trimmed extra spaces from text fields like `company` and `country`.
   - Standardized column values (e.g., industry names).
   - Converted `date` column from text to date format.
   - Updated null values in `industry` based on matching records.
   - Removed rows with null values in critical columns like `total_laid_off` and `percentage_laid_off`.
4. **Data Transformation**:
   - Altered data types for columns for consistency.
   - Grouped and aggregated data by industry and date for further analysis.
   - Implemented rolling totals and rankings to identify top-performing companies by layoffs.

## Key Features

- **Data Preservation**: Work was done on a duplicate table to maintain data integrity.
- **Comprehensive Deduplication**: Identification and removal of duplicates using row numbers and temporary tables.
- **Standardization**: Consistent formatting of company, industry, and country names.
- **Data Type Correction**: Ensured dates and numeric fields were in appropriate formats.
- **Insights**: Aggregated data to highlight key trends, such as total layoffs by industry and top companies by year.

## How to Use

1. **Initial Setup**: Ensure the `layoffs` table is present in your database.
2. **Run Cleaning Queries**: Execute the SQL scripts in the provided order to clean and preprocess the data.
3. **Analyze Cleaned Data**: Use the cleaned `remove_dup_layoffs` table for further analysis or visualization.

## Future Enhancements

- Automate cleaning processes using stored procedures.
- Expand analysis to include additional metrics and predictive modeling.
