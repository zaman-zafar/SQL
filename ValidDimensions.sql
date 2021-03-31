WITH dbcd 
     AS (SELECT [dimensionhierarchy], 
                [levels], 
                t4.displayvalue, 
                t6.NAME, 
                t7.NAME AS DimensionName, 
                t4.dimensionattributevalue, 
                t4.dimensionattributevaluegroup, 
                t5.dimensionattribute, 
                t4.ordinal, 
                t2.NAME AS dimensiontype --account+retail 
                , 
                t2.structuretype, 
                [hash], 
                t1.[recversion], 
                t1.[partition], 
                t1.[recid] 
         FROM   [MITAX_live].[dbo].[dimensionattributevaluegroup] AS t1 
                LEFT JOIN [dimensionhierarchy] AS t2 
                       ON t1.dimensionhierarchy = t2.recid 
                LEFT JOIN dimensionattributelevelvalue AS t4 
                       ON t1.recid = t4.dimensionattributevaluegroup 
                LEFT JOIN dimensionattributevalue AS t5 
                       ON t4.dimensionattributevalue = t5.recid 
                LEFT JOIN dimensionattribute AS t6 
                       ON t5.dimensionattribute = t6.recid 
                LEFT JOIN dirpartytable AS t7 
                       ON t5.entityinstance = t7.recid 
         WHERE  structuretype = 6 
                AND ordinal <> 1), 
     b 
     AS (SELECT DISTINCT ST2.dimensionattributevaluegroup, 
                         Substring((SELECT '-' + ST1.displayvalue AS [text()] 
                                    FROM   dbcd ST1 
                                    WHERE  ST1.dimensionattributevaluegroup = 
                                           ST2.dimensionattributevaluegroup 
                                    ORDER  BY ST1.ordinal ASC 
                                    FOR xml path ('')), 2, 1000) [Dimension], 
                         Substring((SELECT '-' + ST1.NAME AS [text()] 
                                    FROM   dbcd ST1 
                                    WHERE  ST1.dimensionattributevaluegroup = 
                                           ST2.dimensionattributevaluegroup 
                                    ORDER  BY ST1.ordinal ASC 
                                    FOR xml path ('')), 2, 1000) [Type], 
                         Substring((SELECT '_' + ST1.dimensionname AS [text()] 
                                    FROM   dbcd ST1 
                                    WHERE  ST1.dimensionattributevaluegroup = 
                                           ST2.dimensionattributevaluegroup 
                                    ORDER  BY ST1.ordinal ASC 
                                    FOR xml path ('')), 2, 1000) [DimensionNM] 
         FROM   dbcd ST2) 
SELECT DISTINCT type, 
                dimension, 
                dimensionnm 
FROM   b 
WHERE  type = 'Department-CostCenter' 