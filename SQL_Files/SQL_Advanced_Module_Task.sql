-- SQL Query for Analyzing User Account Creation and Email Activity

WITH account_data AS (
    -- Counting the number of created accounts by country
    SELECT
        s.date,
        sp.country,
        a.send_interval,
        a.is_verified,
        a.is_unsubscribed,
        COUNT(DISTINCT a.id) AS account_cnt,
        0 AS sent_msg,
        0 AS open_msg,
        0 AS visit_msg
    FROM `DA.account` a
    JOIN `DA.account_session` acs ON a.id = acs.account_id
    JOIN `DA.session` s ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp ON acs.ga_session_id = sp.ga_session_id
    GROUP BY s.date, sp.country, a.send_interval, a.is_verified, a.is_unsubscribed
),


email_data AS (
    -- Counting the number of sent, opened, and visited emails by country
    SELECT
        s.date,
        sp.country,
        0 AS send_interval,
        0 AS is_verified,
        0 AS is_unsubscribed,
        0 AS account_cnt,
        COUNT(DISTINCT es.id_message) AS sent_msg,
        COUNT(DISTINCT eo.id_message) AS open_msg,
        COUNT(DISTINCT ev.id_message) AS visit_msg
    FROM `DA.email_sent` es
    LEFT JOIN `DA.email_open` eo ON es.id_message = eo.id_message
    LEFT JOIN `DA.email_visit` ev ON es.id_message = ev.id_message
    JOIN `DA.account_session` acs ON es.id_account = acs.account_id
    JOIN `DA.session` s ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp ON acs.ga_session_id = sp.ga_session_id
    GROUP BY s.date, sp.country
),


combined_data AS (
    -- Combining account data and email metrics
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        account_cnt,
        sent_msg,
        open_msg,
        visit_msg
    FROM account_data


    UNION ALL


    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        account_cnt,
        sent_msg,
        open_msg,
        visit_msg
    FROM email_data
),


ranked_data AS (
    -- Calculating the total number of accounts and sent emails with ranking
    SELECT
        country,
        date,
        send_interval,
        is_verified,
        is_unsubscribed,
        SUM(account_cnt) AS total_country_account_cnt,
        SUM(sent_msg) AS total_country_sent_cnt,          
        SUM(sent_msg) AS sent_msg,        
        SUM(open_msg) AS total_open_msg,
        SUM(visit_msg) AS total_visit_msg,
        RANK() OVER (PARTITION BY date ORDER BY SUM(account_cnt) DESC) AS rank_total_country_account_cnt,
        RANK() OVER (PARTITION BY date ORDER BY SUM(sent_msg) DESC) AS rank_total_country_sent_cnt
    FROM combined_data
    GROUP BY country, date, send_interval, is_verified, is_unsubscribed
)


-- Final query with filtering by ranks
SELECT
    date,                                                  
    country,                                              
    send_interval,                                      
    is_verified,                                          
    is_unsubscribed,                                      
    total_country_account_cnt AS account_cnt,            
    total_country_sent_cnt,                              
    sent_msg AS sent_msg,                                
    total_open_msg AS open_msg,                          
    total_visit_msg AS visit_msg,                        
    rank_total_country_account_cnt,                      
    rank_total_country_sent_cnt                          
FROM ranked_data
WHERE rank_total_country_account_cnt <= 10
   OR rank_total_country_sent_cnt <= 10;
