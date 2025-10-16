-- Sentiment Analysis Queries for Hive Tables
-- Run these queries using Spark SQL or Hive CLI

-- 1. Overall sentiment distribution
SELECT 
    CASE 
        WHEN compound >= 0.05 THEN 'positive'
        WHEN compound <= -0.05 THEN 'negative'
        ELSE 'neutral'
    END AS sentiment_category,
    COUNT(*) AS tweet_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM curated_tweets
GROUP BY 
    CASE 
        WHEN compound >= 0.05 THEN 'positive'
        WHEN compound <= -0.05 THEN 'negative'
        ELSE 'neutral'
    END;

-- 2. Average sentiment scores by date
SELECT 
    TO_DATE(created_at) AS date,
    COUNT(*) AS tweet_count,
    ROUND(AVG(compound), 4) AS avg_compound,
    ROUND(AVG(pos), 4) AS avg_positive,
    ROUND(AVG(neg), 4) AS avg_negative,
    ROUND(AVG(neu), 4) AS avg_neutral
FROM curated_tweets
GROUP BY TO_DATE(created_at)
ORDER BY date DESC;

-- 3. Top positive tweets
SELECT 
    text,
    compound,
    pos,
    created_at
FROM curated_tweets
WHERE compound > 0
ORDER BY compound DESC
LIMIT 20;

-- 4. Top negative tweets
SELECT 
    text,
    compound,
    neg,
    created_at
FROM curated_tweets
WHERE compound < 0
ORDER BY compound ASC
LIMIT 20;

-- 5. Sentiment trends over time (hourly aggregation)
SELECT 
    DATE_FORMAT(created_at, 'yyyy-MM-dd HH:00:00') AS hour,
    COUNT(*) AS tweet_volume,
    ROUND(AVG(compound), 4) AS avg_sentiment,
    SUM(CASE WHEN compound >= 0.05 THEN 1 ELSE 0 END) AS positive_count,
    SUM(CASE WHEN compound <= -0.05 THEN 1 ELSE 0 END) AS negative_count,
    SUM(CASE WHEN compound > -0.05 AND compound < 0.05 THEN 1 ELSE 0 END) AS neutral_count
FROM curated_tweets
GROUP BY DATE_FORMAT(created_at, 'yyyy-MM-dd HH:00:00')
ORDER BY hour DESC;

