-- Code below this line was used in the presenation --
SELECT question, COUNT(DISTINCT user_id) AS 'response_count'
FROM survey
Group by 1;

SELECT question, COUNT(response) as skip_response_count
FROM survey
WHERE response LIKE "I'm not sure. Let's skip it."
OR response LIKE "Not Sure. Let's Skip It"
GROUP BY 1;
  
SELECT question, COUNT(response) as no_preference_response_count
FROM survey
WHERE response LIKE "No Preference"
GROUP BY 1;

WITH funnel AS (
SELECT q.user_id, 
h.user_id IS NOT NULL AS is_home_try_on, h.number_of_pairs,
p.user_id IS NOT NULL AS is_purchase
FROM quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON h.user_id = p.user_id)

SELECT number_of_pairs, 
SUM(is_home_try_on) AS num_try_on, SUM(is_purchase) AS num_purchase, 
ROUND(100.0 * (SUM(is_purchase)) / (SUM(is_home_try_on)), 2) AS ratio_from_try_on_to_purchase
FROM funnel
GROUP BY 1;

WITH funnel AS (
SELECT q.user_id, 
h.user_id IS NOT NULL AS is_home_try_on, h.number_of_pairs,
p.user_id IS NOT NULL AS is_purchase
FROM quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON h.user_id = p.user_id)

SELECT COUNT(*) as num_browse, 
ROUND(100.0 * (SUM(is_home_try_on)) / (COUNT(*)), 2) AS ratio_from_browse_to_try_on,
SUM(is_home_try_on) AS num_try_on, SUM(is_purchase) AS num_purchase, 
ROUND(100.0 * (SUM(is_purchase)) / (SUM(is_home_try_on)), 2) AS ratio_from_try_on_to_purchase
FROM funnel; 
                                    
-- Code below this line was NOT used in the presentation --
WITH style_responses AS (
SELECT DISTINCT style, COUNT(*) AS num_responses
FROM quiz
GROUP BY 1 )
SELECT SUM(num_responses) AS style_responses
FROM style_responses
WHERE style != "I'm not sure. Let's skip it.";
                                    
WITH shape_responses AS (
SELECT DISTINCT shape, COUNT(*) AS num_responses
FROM quiz
GROUP BY 1 )
SELECT SUM(num_responses) AS shape_responses
FROM shape_responses
WHERE shape != "No Preference";

SELECT DISTINCT fit, COUNT(*) AS num_responses
FROM quiz
GROUP BY 1;
                                    
WITH purchase_types AS (
SELECT DISTINCT model_name, COUNT(*) AS num_purchases
FROM purchase 
GROUP BY 1  )
SELECT model_name, MAX(num_purchases) AS number_of_times_purchased
FROM purchase_types;
-- The code above, NOT used in the presenation, was an attempt to take a more in depth look at survey responses. --
                                    
-- The code below is the funnel used for Home Try-On Funnel --
SELECT q.user_id, 
h.user_id IS NOT NULL AS is_home_try_on, h.number_of_pairs,
p.user_id IS NOT NULL AS is_purchase
FROM quiz AS q
LEFT JOIN home_try_on AS h
ON q.user_id = h.user_id
LEFT JOIN purchase AS p
ON h.user_id = p.user_id;