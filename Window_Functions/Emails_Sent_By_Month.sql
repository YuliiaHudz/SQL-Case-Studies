WITH monthly_data AS (
    -- Extracting email sent data by month
    SELECT
        DATE(
            EXTRACT(YEAR FROM DATE_ADD(s.date, INTERVAL es.sent_date DAY)),
            EXTRACT(MONTH FROM DATE_ADD(s.date, INTERVAL es.sent_date DAY)), 1
        ) AS sent_month,  -- Creates the sent_month by combining year and month
        es.id_account AS id_account,  -- Account ID from email_sent table
        es.id_message,  -- Unique identifier for each message
        DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS sent_date  -- Calculating the actual sent date for the email
    FROM `DA.email_sent` es  -- From the email_sent table
    JOIN `DA.account_session` acs  -- Joining to account_session table to get the account details
        ON es.id_account = acs.account_id
    JOIN `DA.session` s  -- Joining to session table to get the session dates
        ON acs.ga_session_id = s.ga_session_id
),

account_percentage AS (
    -- Calculating the percentage of messages sent per account for each month
    SELECT 
        sent_month,  -- The month of the email sent
        id_account,  -- The account identifier
        (COUNT(DISTINCT id_message) * 100 / SUM(COUNT(DISTINCT id_message)) OVER (PARTITION BY sent_month)) AS sent_msg_percent_from_this_month,  -- Calculating the percentage
        MIN(sent_date) AS first_sent_date,  -- The first sent date for this account in the month
        MAX(sent_date) AS last_sent_date  -- The last sent date for this account in the month
    FROM monthly_data
    GROUP BY sent_month, id_account  -- Grouping by sent month and account
)

-- Final result: Returns the data with the percentage of messages sent by each account in each month
SELECT 
    sent_month,
    id_account,
    sent_msg_percent_from_this_month,
    first_sent_date,
    last_sent_date
FROM account_percentage
ORDER BY sent_month, id_account;  -- Ordering by sent month and account
