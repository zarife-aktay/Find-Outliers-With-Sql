CREATE TABLE #ClickLog(
    [ClickCount]  float
)
GO
INSERT INTO #ClickLog ([ClickCount])
VALUES (60),(20),(40),(30),(200) 
GO

WITH 
Median AS
( 
	SELECT DISTINCT PERCENTILE_CONT(0.5)WITHIN GROUP(ORDER BY ClickCount)
	OVER() AS Median
	FROM #ClickLog 
),
Deviation AS
( 
	SELECT ABS(ClickCount-Median) AS Deviation
	FROM #ClickLog 
	JOIN Median on 1=1 
),
MAD AS
(
	SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Deviation) OVER() AS MAD
	FROM Deviation
) 
SELECT ABS(ClickCount-MAD)/MAD AS Ratio, ClickCount
FROM MAD 
JOIN #ClickLog On 1=1
 
DROP TABLE #ClickLog;