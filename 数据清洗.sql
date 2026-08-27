-- 创建清洗后的分析表
CREATE TABLE transactions_clean AS
SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    STR_TO_DATE(InvoiceDate, '%Y-%m-%d %H:%i:%s') AS InvoiceDate,
    Price,
    ROUND(Quantity * Price, 2) AS Amount,
    `Customer ID` AS CustomerID,
    Country
FROM online_retail_ii
WHERE `Customer ID` IS NOT NULL        -- 剔除缺失客户（无法画像）
  AND Quantity > 0                      -- 剔除退货 / 负数量
  AND Price > 0                         -- 剔除异常价格
  AND StockCode REGEXP '^[0-9]+$'       -- 保留数字商品编码
  AND LENGTH(Description) > 5           -- 剔除异常 / 过短描述
  AND STR_TO_DATE(InvoiceDate, '%Y-%m-%d %H:%i:%s') IS NOT NULL
  AND YEAR(STR_TO_DATE(InvoiceDate, '%Y-%m-%d %H:%i:%s')) >= 2000; -- 剔除异常年份
