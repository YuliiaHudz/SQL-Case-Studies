# SQL Advanced Module Task

## Project Overview

This project involves writing a SQL query to analyze user account creation and email activity. The key metrics analyzed include:

- Number of accounts created
- Emails sent, opened, and clicked

The analysis is grouped by several dimensions such as:

- Date
- Country
- Send Interval
- Verification Status
- Subscription Status

Additionally, the project ranks countries based on the number of accounts created and emails sent. A **Looker Studio** visualization has also been created to display these metrics and trends, focusing on the top countries and email activity dynamics over time.

## Task Breakdown

### 1. **SQL Query**

The SQL query processes the data in several steps:

- **Account Data Extraction**: It counts the number of accounts created by country, considering their verification status and whether the account is unsubscribed.
- **Email Data Extraction**: It counts the number of emails sent, opened, and clicked by country.
- **Data Combination**: The query then combines the account data and email metrics to provide a holistic view.
- **Ranking**: Countries are ranked based on the number of accounts created and emails sent.

### SQL Code File

The SQL code for this task is located in the file [**SQL_Advanced_Module_Task.sql**](./SQL_Advanced_Module_Task.sql) 
This file contains the SQL query that performs the analysis.

### 2. **Looker Studio Visualization**

A **Looker Studio** report was created to visualize the metrics generated by the SQL query. The report focuses on:

- **Top Countries**: Displays the countries with the highest number of accounts created and the highest number of emails sent.
- **Email Activity Dynamics**: Shows how email activity (sent, opened, and clicked) changes over time.

A screenshot of the Looker Studio visualization is included for reference.

### Screenshot of Looker Studio Visualization

![Email Activity Chart](./email_activity_charts.png)

The screenshot illustrates the trends in email activity and highlights top-performing countries based on the metrics.

## Files Included

- **SQL_Advanced_Module_Task.sql**: The SQL query that analyzes user account creation and email activity.
- **email_activity_charts.png**: Screenshot of the Looker Studio visualization showing email activity trends and top countries.

## How to Use This Project

1. **SQL Query**: Run the SQL query in your database to analyze the user account creation and email activity. Be sure to adapt the table names and column names based on your database schema.

2. **Looker Studio Visualization**: Use the results of the SQL query to create visualizations in Looker Studio. The provided screenshot shows how to visualize the data, focusing on email activity over time and top-performing countries.

3. **Customization**: Feel free to modify the SQL query and Looker Studio report to add more filters, metrics, or different visualizations as needed for your analysis.

## Conclusion

This project demonstrates how to use SQL to analyze user account creation and email activity. The insights gathered can be used to improve email marketing strategies, monitor user engagement, and evaluate the performance of different countries. The Looker Studio visualization complements the SQL analysis, providing an interactive and insightful way to explore the data over time.
