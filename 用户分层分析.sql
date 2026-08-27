-- 特征构建
CREATE TABLE customer_rfm1 AS
SELECT
  CustomerID,
  MAX(InvoiceDate) AS LastPurchaseDate,
  COUNT(DISTINCT Invoice) AS Frequency,
  ROUND(SUM(Amount),2) AS Monetary
FROM transactions_clean
GROUP BY CustomerID;


-- RFM评分
CREATE TABLE customer_rfm_score AS
SELECT
    CustomerID,
    Frequency,
    Monetary,
    -- R 打分（最近购买，越近越高分）
    CASE
        WHEN DATEDIFF('2011-12-10', LastPurchaseDate) <= 30 THEN 5
        WHEN DATEDIFF('2011-12-10', LastPurchaseDate) <= 60 THEN 4
        WHEN DATEDIFF('2011-12-10', LastPurchaseDate) <= 120 THEN 3
        WHEN DATEDIFF('2011-12-10', LastPurchaseDate) <= 180 THEN 2
        ELSE 1
    END AS R_Score,
    -- F 打分（购买次数）
    CASE
        WHEN Frequency >= 20 THEN 5
        WHEN Frequency >= 10 THEN 4
        WHEN Frequency >= 5 THEN 3
        WHEN Frequency >= 2 THEN 2
        ELSE 1
    END AS F_Score,
    -- M 打分（消费金额）
    CASE
        WHEN Monetary >= 5000 THEN 5
        WHEN Monetary >= 2000 THEN 4
        WHEN Monetary >= 500 THEN 3
        WHEN Monetary >= 100 THEN 2
        ELSE 1
    END AS M_Score
FROM customer_rfm;

-- 用户分层
CREATE TABLE customer_segment AS
SELECT
    CustomerID,
    R_Score,
    F_Score,
    M_Score,
    (R_Score + F_Score + M_Score) AS Total_Score,
    CASE
        WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN '高价值用户'
        WHEN R_Score >= 4 AND F_Score >= 3 THEN '发展用户'
        WHEN R_Score <= 2 AND (F_Score >= 3 OR M_Score >= 3) THEN '挽留用户'
        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN '流失风险用户'
        ELSE '一般用户'
    END AS User_Segment
FROM customer_rfm_score;