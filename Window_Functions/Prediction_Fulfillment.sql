-- This SQL query calculates the revenue percentage prediction fulfillment over time.

SELECT 
    date,
    ROUND(revenue_percentage, 2) AS revenue_percentage
FROM (
    SELECT
        date,
        revenue,
        SUM(revenue) OVER (ORDER BY date) AS acc_revenue,
        predict_revenue,
        SUM(predict_revenue) OVER (ORDER BY date) AS acc_predict_revenue,
        CASE
            WHEN SUM(predict_revenue) OVER (ORDER BY date) = 0 THEN 0
            ELSE (SUM(revenue) OVER (ORDER BY date) * 100.0 / SUM(predict_revenue) OVER (ORDER BY date))
        END AS revenue_percentage
    FROM (
        -- Aggregating actual revenue and predicted revenue by date
        SELECT
            date,
            SUM(revenue) AS revenue,
            SUM(predict) AS predict_revenue
        FROM (
            -- Actual revenue from orders
            SELECT
                s.date,
                SUM(p.price) AS revenue,
                0 AS predict
            FROM `DA.order` o
            JOIN `DA.product` p
                ON o.item_id = p.item_id
            JOIN `DA.session` s
                ON o.ga_session_id = s.ga_session_id
            GROUP BY s.date

            UNION ALL

            -- Predicted revenue from the revenue_predict table
            SELECT
                rp.date,
                0 AS revenue,
                SUM(rp.predict) AS predict
            FROM `DA.revenue_predict` rp
            GROUP BY rp.date
        ) AS combined_data
        GROUP BY date
    ) AS aggregated_data
    ORDER BY date
);
