/****** Script for SelectTopNRows command from SSMS  ******/ 
SELECT t2.sponsorname, 
       t1.[empname], 
       t1.[employeecode], 
       t1.[dataareaid], 
       t2.[molid], 
       t4.totalsalary, 
       t5.locationname, 
       [spnosorcode], 
       [terminated], 
       t3.[accountnum]          AS bankAccount, 
       t3.branchid, 
       t6.person                AS EmployeeCodeforHRModulePerson, 
       t6.recid                 AS EmployeecodeforHCMEMPLOYMENTTable, 
       t12.identificationnumber AS MOLID, 
       t7.defaultdimension, 
       t9.students, 
       [contracttype], 
       t1.[locationcode], 
       t10.resumedateplanned, 
       t11.value                AS housingAllowance, 
       [employeegroup], 
       [employeeinsurencenumber], 
       [employeenameinlocallan], 
       [includeintopension], 
       [paymentmethod], 
       [paymentmethodap], 
       [pensioncode], 
       [calculateretro], 
       [terminationperiod], 
       [terminationreason], 
       t1.[validfrom], 
       t1.[validto], 
       t1.[modifieddatetime], 
       t1.[modifiedby], 
       t1.[createddatetime], 
       t1.[createdby], 
       t1.[recid], 
       t1.[recversion], 
       t1.[partition], 
       t13.gender, 
       [oldemployeecode] 
FROM   [MITAX_live].[dbo].[synpr_employeeinformations] AS t1 
       LEFT JOIN synpr_sponsor AS t2 
              ON t1.spnosorcode = t2.sponsorcode 
       LEFT JOIN synpr_bankaccount AS t3 
              ON t1.employeecode = t3.employeecode 
                 AND t3.recordstatus = 0 
       LEFT JOIN(SELECT employeecode, 
                        Sum(value) AS TotalSalary, 
                        validto, 
                        dataareaid 
                 FROM   synpr_regularearnings 
                 WHERE  validto = '2154-12-31 00:00:00.000' 
                 GROUP  BY employeecode, 
                           validto, 
                           dataareaid) AS t4 
              ON t1.employeecode = t4.employeecode 
                 AND t1.dataareaid = t4.dataareaid 
       LEFT JOIN synpr_locations AS t5 
              ON t1.locationcode = t5.locationcode 
       LEFT JOIN hcmworker AS t6 
              ON t1.employeecode = t6.personnelnumber 
       LEFT JOIN companyinfoview AS t8 
              ON t1.dataareaid = t8.dataarea 
       LEFT JOIN hcmemployment AS t7 
              ON t6.recid = t7.worker 
                 AND t8.recid = t7.legalentity 
                 AND t7.validto = '2154-12-31 23:59:59.000' 
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
ON t7.defaultdimension = t9.dimensionattributevalueset 
LEFT JOIN synpr_vacationsabsences AS t10 
ON t1.employeecode = t10.employeecode 
AND t10.resumedateactual = '1900-01-01 00:00:00.000' 
AND t10.resumedateplanned > '2017-12-31' 
LEFT JOIN synpr_regularearnings AS t11 
ON t1.employeecode = t11.employeecode 
AND t1.dataareaid = t11.dataareaid 
AND t11.payrollitemcode = '006' 
AND t11.validto = '2154-12-31 00:00:00.000' 
LEFT JOIN hcmpersonidentificationnumber AS t12 
ON t6.person = t12.person 
AND t12.identificationtype = '5637145327' 
LEFT JOIN dirpartytable AS t13 
ON t6.person = t13.recid 