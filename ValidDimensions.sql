
with dbcd as  (SELECT [DIMENSIONHIERARCHY]
      ,[LEVELS]

	 ,t4.DISPLAYVALUE
	,t6.NAME
	,t7.NAME as DimensionName
	 ,t4.DIMENSIONATTRIBUTEVALUE
	 ,t4.DIMENSIONATTRIBUTEVALUEGROUP
	   ,t5.DIMENSIONATTRIBUTE
	 ,t4.ORDINAL
	  ,t2.NAME as dimensiontype --account+retail
	  ,t2.STRUCTURETYPE
      ,[HASH]
      ,t1.[RECVERSION]
	
      ,t1.[PARTITION]
      ,t1.[RECID]
  FROM [MITAX_live].[dbo].[DIMENSIONATTRIBUTEVALUEGROUP]

  as t1 left join [DIMENSIONHIERARCHY] as t2 on t1.DIMENSIONHIERARCHY = t2.RECID

left join DIMENSIONATTRIBUTELEVELVALUE as t4 on t1.RECID = t4.DIMENSIONATTRIBUTEVALUEGROUP

left join DimensionAttributeValue as t5 on t4.DimensionAttributeValue  = t5.RecId 

left join DIMENSIONATTRIBUTE as t6 on t5.DIMENSIONATTRIBUTE = t6.RECID

left join DIRPARTYTABLE as t7 on t5.EntityInstance = t7.RECID

 where STRUCTURETYPE = 6  and ORDINAL <> 1) ,

  b as ( Select distinct ST2.DIMENSIONATTRIBUTEVALUEGROUP, 
    substring(
        (
            Select '-'+ST1.DISPLAYVALUE  AS [text()]
            From dbcd ST1
            Where ST1.DIMENSIONATTRIBUTEVALUEGROUP = ST2.DIMENSIONATTRIBUTEVALUEGROUP
            ORDER BY ST1.ORDINAL ASC
            For XML PATH ('')
        ), 2, 1000) [Dimension]
	,   substring(
       (
          Select '-'+ST1.name  AS [text()]
          From dbcd ST1
          Where ST1.DIMENSIONATTRIBUTEVALUEGROUP= ST2.DIMENSIONATTRIBUTEVALUEGROUP
            ORDER BY ST1.ORDINAL ASC
          For XML PATH ('')
     ), 2, 1000) [Type]
	 ,substring(
       (
          Select '_'+ST1.DimensionName  AS [text()]
          From dbcd ST1
          Where ST1.DIMENSIONATTRIBUTEVALUEGROUP= ST2.DIMENSIONATTRIBUTEVALUEGROUP
            ORDER BY ST1.ORDINAL ASC
          For XML PATH ('')
     ), 2, 1000) [DimensionNM]
From dbcd ST2 )

select DISTINCT Type,Dimension,DimensionNM from b where Type = 'Department-CostCenter'
  







            
