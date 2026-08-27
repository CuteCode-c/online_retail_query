# 电商用户分层与商品运营分析（Online Retail Analysis）

> 基于百万级电商交易数据，完成「数据清洗 → RFM 用户价值分层 → 商品运营分析 → Power BI 可视化」全链路分析，为精细化用户运营、库存备货与渠道投放提供数据决策支撑。

## 项目简介

传统电商运营普遍面临**营销投放粗放、库存匹配不合理、用户价值不清、资源利用率低**四大痛点。本项目基于百万级电商交易数据集，通过系统性数据清洗与规整，搭建交易明细、用户 RFM 分层、商品销量统计三张核心数据表；设计 1-5 分标准化 RFM 打分规则，将全量用户划分为五层级价值体系；并通过 SQL 多维度聚合定位平台核心爆款商品，最终依托 Power BI 搭建可视化看板，让业务侧「看得懂、用得上」。

## 核心分析框架

```
百万级交易数据 → 数据清洗与规整（MySQL） → 三张核心数据表
    ├── 交易明细表（字段规范、异常剔除）
    ├── 用户 RFM 分层表（R / F / M 三维打分）
    └── 商品销量统计表（聚合 + 排序）

用户维度：RFM 分层 → 五层级用户价值体系 → 差异化运营人群识别
商品维度：SQL 聚合 → Top 爆款商品定位 → 备货与选品建议
可视化：Power BI 看板 → 核心指标一览
```

## 关键分析结论

| 结论 | 数据支撑 |
| --- | --- |
| 高价值用户高度集中 | 约 15% 高价值核心用户贡献全店约 65% 销售额 |
| 爆款商品拉动效应显著 | Top10 核心爆款商品贡献平台近 40% 订单量 |
| 分层体系可迁移 | RFM 分层与活动效果评估方法论可迁移至游戏玩家分层（大 R / 小 R / 非付费）等场景 |

## 技术栈

- **数据库**：MySQL + Navicat（数据清洗、多表关联、聚合统计）
- **分析模型**：RFM 用户价值分层（1-5 分标准化打分，五层级划分）
- **SQL 分析脚本**：`数据清洗.sql` / `用户分层分析.sql` / `商品销售分析.sql`（生成三张核心数据表）
- **可视化**：Power BI（交互式数据看板）、Excel（数据透视与交叉验证）
- **数据规模**：百万级交易记录

## 仓库结构

```
online_retail_query/
├── 数据清洗.sql              # 数据清洗脚本：从原始表生成 transactions_clean 交易明细表
├── 用户分层分析.sql          # RFM 用户分层脚本：生成 customer_segment 分层结果表
├── 商品销售分析.sql          # 商品销量分析脚本：生成 product_sales_rank 商品排行表
├── transactions_clean.xlsx   # 清洗后全量交易明细（已导出，约 27MB）
├── customer_segment.csv      # 用户 RFM 分层结果表（已导出）
├── product_sales_rank.csv    # 商品销量统计排行表（已导出）
├── online_retail.pbix        # Power BI 可视化看板
└── online_retail_II.csv/     # 原始交易明细数据（约 94MB，分析输入源）
```

### 数据表说明

- **customer_segment.csv**：`CustomerID, R_Score, F_Score, M_Score, Total_Score, User_Segment`，其中 `User_Segment` 分为高价值用户 / 发展用户 / 一般用户 / 挽留用户 / 流失风险用户五层级。
- **product_sales_rank.csv**：`StockCode, TotalQuantity, TotalRevenue, OrderCount`，按销量与销售额双重维度定位核心爆款商品。

📌 **数据说明**：仓库内已导出的 3 份核心分析结果数据为 2 个 CSV + 1 个 XLSX——`customer_segment.csv`、`product_sales_rank.csv`、`transactions_clean.xlsx`；原始交易明细 `online_retail_II.csv`（约 94MB）作为分析输入源一并提供。另有 2 份上游原始数据源文件未导出至本仓库，复现完整流程请于本地准备原始 Online Retail II 数据集并导入 `online_retail_ii` 表后再运行 SQL 脚本。

## SQL 分析脚本

仓库提供 3 个 MySQL 分析脚本，分别对应三张核心数据表的生成逻辑，建议按以下顺序执行：

| 脚本 | 作用 | 产出的核心表 |
| --- | --- | --- |
| `数据清洗.sql` | 从原始交易表 `online_retail_ii` 中剔除缺失客户、退货 / 负数量、异常价格与编码，规范字段并计算出 `Amount`，生成清洗后的交易明细表 | `transactions_clean` |
| `用户分层分析.sql` | 基于 `transactions_clean` 构建 RFM 特征并按 1-5 分打分，划分五层级用户价值体系 | `customer_segment` |
| `商品销售分析.sql` | 按 `StockCode` 聚合销量、销售额与订单数，定位核心爆款商品 | `product_sales_rank` |

> 运行前请先在 MySQL 中创建原始表 `online_retail_ii` 并导入 `online_retail_II.csv` 原始数据；脚本依赖 MySQL 8.0+（使用 `STR_TO_DATE`、`REGEXP`、`DATEDIFF` 等函数）。

## 快速上手

1. （可选）在 MySQL 中创建 `online_retail_ii` 表并导入 `online_retail_II.csv` 原始数据；
2. 按顺序执行 `数据清洗.sql` → `用户分层分析.sql` / `商品销售分析.sql`，复现三张核心数据表；
3. 使用 Power BI Desktop 打开 `online_retail.pbix`，直接浏览用户分层与商品运营看板；
4. 使用 Excel / Python（pandas）读取 `customer_segment.csv`、`product_sales_rank.csv` 查看分层与排行明细；
5. 如需全量数据，可基于 `transactions_clean.xlsx` 复跑 SQL 分析流程。

## 业务价值

- **精细化用户运营**：识别高价值核心用户，指导差异化营销与会员运营，降低营销损耗；
- **商品备货与选品**：基于爆款商品榜单为库存备货、活动主推提供量化依据；
- **效率沉淀**：沉淀标准化可复用 SQL 分析模板与 Power BI 看板，替代人工统计，提升日常运营分析效率。

## 后续优化方向

- 引入 RFM 时间窗口滑窗，提升分层时效性；
- 结合商品品类与用户画像交叉分析，输出「人货匹配」推荐策略；
- 将 Power BI 看板接入自动化数据管道，实现日级自动刷新。
