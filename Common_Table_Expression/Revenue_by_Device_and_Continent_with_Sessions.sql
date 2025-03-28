-- CTE to calculate revenue by continent, including breakdown by device type
WITH revenue AS (
  SELECT
      sp.continent,
      SUM(p.price) AS Revenue,
      SUM(CASE WHEN sp.device = 'mobile' THEN p.price ELSE 0 END) AS Revenue_from_Mobile,
      SUM(CASE WHEN sp.device = 'desktop' THEN p.price ELSE 0 END) AS Revenue_from_Desktop
  FROM `DA.order` o
  JOIN `DA.product` p ON o.item_id = p.item_id
  JOIN `DA.session_params` sp ON o.ga_session_id = sp.ga_session_id
  GROUP BY sp.continent
),

-- CTE to count accounts per continent and the number of verified accounts
account_cnt AS (
  SELECT
      sp.continent,
      COUNT(DISTINCT a.id) AS Account_Count,
      SUM(CASE WHEN a.is_verified = 1 THEN 1 ELSE 0 END) AS Verified_Account
  FROM `DA.session_params` sp
  JOIN `DA.account_session` acs ON sp.ga_session_id = acs.ga_session_id
  JOIN `DA.account` a ON acs.account_id = a.id
  GROUP BY sp.continent
),

-- CTE to count the number of sessions per continent
session_count AS (
  SELECT
      sp.continent,
      COUNT(DISTINCT sp.ga_session_id) AS Session_Count
  FROM `DA.session_params` sp
  GROUP BY sp.continent
)

-- Final query to combine revenue, account counts, and session counts
SELECT
    r.continent,
    r.Revenue,
    r.Revenue_from_Mobile,
    r.Revenue_from_Desktop,
    (r.Revenue / SUM(r.Revenue) OVER()) * 100 AS Revenue_Percentage_From_Total,
    a.Account_Count,
    a.Verified_Account,
    s.Session_Count
FROM revenue r
JOIN account_cnt a ON r.continent = a.continent
JOIN session_count s ON r.continent = s.continent;
