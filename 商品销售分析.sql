-- 商品销售排名，用于识别高需求商品
CREATE TABLE product_sales_rank AS
SELECT
    StockCode,
    SUM(Quantity) AS TotalQuantity,
    ROUND(SUM(Amount), 2) AS TotalRevenue,
    COUNT(DISTINCT Invoice) AS OrderCount
FROM transactions_clean
GROUP BY StockCode
ORDER BY TotalRevenue DESC;