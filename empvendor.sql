/****** Script for SelectTopNRows command from SSMS  ******/ 
SELECT [accountnum], 
       t3.NAME, 
       t9.students, 
       [invoiceaccount], 
       [vendgroup], 
       [taxgroup], 
       [party], 
       [defaultdimension], 
       [dataareaid], 
       t2.[recversion], 
       t2.[partition], 
       t2.[recid], 
       [employeecode] 
FROM   [MITAX_live].[dbo].[vendtable] AS t2 
       LEFT JOIN dirpartytable AS t3 
              ON t2.party = t3.recid 
       LEFT JOIN (SELECT DISTINCT ST2.dimensionattributevalueset, 
                                  Substring( 
                                  (SELECT '-' + ST1.displayvalue AS 
                                          [text()] 
                                   FROM 
                                  dimensionattributevaluesetitem ST1 
                                             WHERE 
                                  ST1.dimensionattributevalueset = 
ST2.dimensionattributevalueset 
ORDER  BY ST1.dimensionattributevalueset 
FOR xml path ('')), 2, 1000) [Students] 
FROM   dimensionattributevaluesetitem ST2) AS t9 
ON t2.defaultdimension = t9.dimensionattributevalueset 
WHERE  [employeecode] <> '' 
--t2.ACCOUNTNUM like '%E-%' 