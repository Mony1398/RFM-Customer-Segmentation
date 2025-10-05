USE `project 1 RFM`;
SET @endday = '2022-09-01';
CREATE TEMPORARY TABLE `RFM_BASE` AS 
	WITH RFM_VALUES AS (				-- Tính Recency, Frequency, Monetary 													
		SELECT CustomerID, LocationID, BranchCode,
			DATEDIFF( @endday, MAX( new_Purchase_Date ) ) AS Recency,
			COUNT( DISTINCT DATE( new_Purchase_Date ) ) / ( DATEDIFF( @endday , new_Created_date ) / 365 ) AS Frequency,
			SUM( gmv ) / ( DATEDIFF( @endday , new_Created_date ) / 365 ) AS Monetary
		FROM 
			customer_transaction ct JOIN customer_registered cr ON ct.CustomerID = cr.ID 
		WHERE 
			GMV IS NOT NULL AND GMV > 0 
		AND 
			new_Purchase_Date IS NOT NULL AND new_Purchase_Date < @endday
		AND
			New_Created_date IS NOT NULL AND New_Created_date < @endday
		GROUP BY CustomerID
	),
	RFM_SORTED AS (
		SELECT *,
			ROW_NUMBER () OVER (ORDER BY recency) AS R_sorted,
			ROW_NUMBER () OVER (ORDER BY frequency) AS F_sorted,
			ROW_NUMBER () OVER (ORDER BY monetary) AS M_sorted
		FROM RFM_VALUES
	),
	TOTALROWS AS (
		SELECT *, COUNT(*) OVER () AS total_rows
		FROM RFM_SORTED
	)
SELECT *,   							-- xác định vị trí Q1-3	
	total_rows * 0.25 AS Q1,
	total_rows * 0.50 AS Q2,
	total_rows * 0.75 AS Q3
FROM TOTALROWS;
-- Xác định giá trị Q1-3
CREATE TEMPORARY TABLE Q_VALUES AS 
	SELECT  
		MAX(CASE WHEN R_sorted <= Q1 THEN Recency END) AS Q1R,
        MAX(CASE WHEN R_sorted <= Q2 THEN Recency END) AS Q2R,
        MAX(CASE WHEN R_sorted <= Q3 THEN Recency END) AS Q3R,
        MAX(CASE WHEN F_sorted <= Q1 THEN frequency END) AS Q1F,
        MAX(CASE WHEN F_sorted <= Q2 THEN frequency END) AS Q2F,
        MAX(CASE WHEN F_sorted <= Q3 THEN frequency END) AS Q3F,
        MAX(CASE WHEN M_sorted <= Q1 THEN monetary END) AS Q1M,
        MAX(CASE WHEN M_sorted <= Q2 THEN monetary END) AS Q2M,
        MAX(CASE WHEN M_sorted <= Q3 THEN monetary END) AS Q3M
	FROM RFM_BASE;
			COUNT( DISTINCT DATE( new_Purchase_Date ) ) / ( DATEDIFF( @endday , new_Created_date ) / 365 ) AS Frequency,
-- tạo bảng tổng hợp các giá trị Q của R-F-M
WITH T AS (
    SELECT s.*, v.line
    FROM Q_VALUES AS s
    JOIN (
        SELECT 1 AS line
        UNION ALL
        SELECT 2
        UNION ALL
        SELECT 3
    	) AS v
    ON 1=1
)
SELECT
    CASE line WHEN 1 THEN 'R' WHEN 2 THEN 'F' ELSE 'M' END AS Type,
    CASE line WHEN 1 THEN Q1R WHEN 2 THEN Q1F ELSE Q1M END AS Q1,
    CASE line WHEN 1 THEN Q2R WHEN 2 THEN Q2F ELSE Q2M END AS Q2,
    CASE line WHEN 1 THEN Q3R WHEN 2 THEN Q3F ELSE Q3M END AS Q3
FROM T;
-- Chấm điểm RFM và phân nhóm khách hàng
WITH RFM_SCORE AS (
	SELECT customerID, LocationID, BranchCode, recency, frequency, monetary,
		CASE 
			WHEN recency < Q1R THEN '4' 
			WHEN recency >= Q1R AND recency < Q2R THEN '3'
			WHEN recency >= Q2R AND recency < Q3R THEN '2'
			ELSE '1'
		END AS R_score,
		CASE 
			WHEN frequency < Q1F THEN '1' 
			WHEN frequency >= Q1F AND frequency < Q2F THEN '2'
			WHEN frequency >= Q2F AND frequency < Q3F THEN '3'
			ELSE '4'
		END AS F_score,
		CASE 
			WHEN monetary < Q1M THEN '1' 
			WHEN monetary >= Q1M AND monetary < Q2M THEN '2'
			WHEN monetary >= Q2M AND monetary < Q3M THEN '3'
			ELSE '4'
		END AS M_score
	FROM RFM_BASE,Q_VALUES 
	GROUP BY customerId
),
RFM_SEGMENT AS (
	SELECT *, 
		CONCAT(R_score,F_score,M_score) AS RFM_group 
	FROM RFM_SCORE
)
SELECT *, 
	CASE 
		WHEN RFM_GROUP IN ('111','112','113','114','211','212','213','214') THEN 'KH DA ROI BO'
		WHEN RFM_GROUP IN ('121','122','123','124','221','222','223','224') THEN 'KH VANG LAI'
		WHEN RFM_GROUP IN ('131','132','133','134','141','142','143','144','233','234','243','244','231','232','241','242') THEN 'KH SAP ROI BO'
		WHEN RFM_GROUP IN ('311','312','321','322','411','412','421','422') THEN 'KH MOI'
		WHEN RFM_GROUP IN ('313','314','323','324','413','414','423','424') THEN 'KH TIEM NANG'
		WHEN RFM_GROUP IN ('331','332','333','341','342','431','432','433','441','442') THEN 'KH TRUNG THANH'
		WHEN RFM_GROUP IN ('334','343','344','434','443','444') THEN 'KH VIP'
	END AS BANNER
FROM RFM_SEGMENT;

DROP TEMPORARY TABLE `Q_VALUES`;
DROP TEMPORARY TABLE `RFM_BASE`;


