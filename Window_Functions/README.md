# Emails Sent by Month & Prediction Fulfillment - SQL Tasks

This repository contains SQL scripts for analyzing email activity and revenue prediction fulfillment using **window functions**.

---

## Emails Sent by Month - SQL Task

This SQL script calculates the percentage of emails sent per account by month. It uses **window functions** to partition the data by month and compute the percentage of emails sent by each account relative to the total sent emails for that month.

### Description

In this task, we calculate the percentage of emails sent each month, with the result showing the percentage contribution of each account's emails to the total emails sent in that month. The query provides the following columns for each month:

- **sent_month**: The month when the emails were sent.
- **id_account**: The unique identifier of the account.
- **sent_msg_percent_from_this_month**: The percentage of emails sent by the account for that month, calculated relative to the total emails sent that month.
- **first_sent_date**: The date when the first email was sent by the account in that month.
- **last_sent_date**: The date when the last email was sent by the account in that month.

### Output Example

![Emails Sent Percentage](./email_activity_chart_output.png)

### SQL Query Breakdown

1. **Monthly Data Calculation**:
   - Extracts the month and year from the `sent_date` of the emails.
   - Joins `email_sent`, `account_session`, and `session` tables to gather data related to each account and their sent messages.

2. **Percentage Calculation**:
   - Uses `COUNT(DISTINCT id_message)` to calculate the total messages sent by each account.
   - Calculates the percentage of messages sent by the account using the window function `SUM(COUNT(DISTINCT id_message)) OVER (PARTITION BY sent_month)`.

3. **Result Formatting**:
   - Displays the month, account ID, the percentage of emails sent by the account in that month, and the first and last sent dates.

### SQL Code File

The SQL code for this task is located in the file [**Emails_Sent_By_Month.sql**](./Emails_Sent_By_Month.sql) 
This file contains the SQL query that performs the analysis.

---

## Prediction Fulfillment - SQL Task

This SQL script analyzes how well revenue predictions align with actual revenue over time. It calculates cumulative revenue and predicted revenue and computes the percentage of actual revenue compared to predicted revenue.

### Description

The query calculates how much of the predicted revenue was fulfilled by actual revenue on a daily basis. The result includes:

- **date**: The transaction date.
- **revenue_percentage**: The percentage of actual revenue compared to predicted revenue.

### Output Example

![Prediction Fulfillment](./prediction_fulfillment_chart.png)

### SQL Query Breakdown

1. **Revenue and Predictions Aggregation**:
   - Retrieves actual revenue from the `order` table.
   - Retrieves predicted revenue from the `revenue_predict` table.
   - Combines actual and predicted revenue data.

2. **Cumulative Revenue Calculation**:
   - Uses `SUM(revenue) OVER (ORDER BY date)` to compute cumulative actual revenue.
   - Uses `SUM(predict_revenue) OVER (ORDER BY date)` to compute cumulative predicted revenue.

3. **Fulfillment Percentage Calculation**:
   - Computes `(SUM(revenue) OVER (ORDER BY date) * 100.0 / SUM(predict_revenue) OVER (ORDER BY date))` to determine the fulfillment percentage.

### SQL Code File

The SQL code for this task is located in the file [**Prediction_Fulfillment.sql**](./Prediction_Fulfillment.sql) 
This file contains the SQL query that performs the analysis.
