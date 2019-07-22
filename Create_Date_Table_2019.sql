Use tempdb
--
If Exists (
				Select * from SysObjects
				Where Id like OBJECT_ID('#D_Date')
			)
Drop Table #D_Date
--
DECLARE 
@dateDebut DATE = '20190101', 
@nbJours INT = 5;
SET DATEFIRST 1;
SET DATEFORMAT mdy;
SET LANGUAGE french;
DECLARE @dateFin DATE = DATEADD(Day, @nbJours, @dateDebut);
--
CREATE TABLE #D_Date
(
  -- Jour 
  [Date] DATE PRIMARY KEY, 
  [Jour] AS DATEPART(DAY, [Date]),
  [Libellé Jour] AS DATENAME(weekday, [Date]),
  -- Mois
  [Mois] AS DATEPART(MONTH, [Date]),
  [Jour 1 mois] AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [Date]), 0)),
  [Libellé mois] AS DATENAME(MONTH, [Date]),
  -- Année
  [Année]       AS DATEPART(YEAR, [Date]),
  [Jour 1 année]  AS CONVERT(DATE, DATEADD(YEAR,  DATEDIFF(YEAR, 0, [Date]), 0)),
  [Date Style 112]     AS CONVERT(CHAR(8), [Date], 112),
  [Date Style 111]     AS CONVERT(CHAR(10), [Date], 101), 
  [Date Style 103]     AS CONVERT(CHAR(10), [Date], 103),
  -- Mois Année
  [Mois Année]  AS 100*YEAR([date])+MONTH([Date])
);
--
INSERT #D_Date([Date]) 
SELECT jour
FROM
(
  SELECT jour = DATEADD(DAY, RN - 1, @dateDebut)
  FROM 
  (
    SELECT 
			TOP (DATEDIFF(DAY, @dateDebut, @dateFin)) 
			RN = ROW_NUMBER() OVER (ORDER BY SO.[object_id])
    FROM sys.all_objects As SO     
    ORDER BY SO.[object_id]
  ) AS tableJour
) AS tableJour2;
--
Select *
From #D_Date