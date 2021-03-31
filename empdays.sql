SELECT * 
FROM   (SELECT [employeecode], 
               t1.[timesheetcode], 
               Count(t3.description) AS timedescription, 
               t3.description, 
               t1.[dataareaid], 
               t2.timesheetstatus, 
               t2.forperiod 
        FROM   [MITAX_live].[dbo].[synpr_timesheetdetails] AS t1 
               LEFT JOIN synpr_timesheetheader AS t2 
                      ON t1.timesheetcode = t2.timesheetcode 
                         AND t1.dataareaid = t2.dataareaid 
               LEFT JOIN synpr_timetypes AS t3 
                      ON t1.timetype = t3.timetype 
        --please add details of period here for each month 
        WHERE  t2.forperiod = '201808' 
        GROUP  BY t2.forperiod, 
                  employeecode, 
                  t1.[dataareaid], 
                  t2.timesheetstatus, 
                  t1.[timesheetcode], 
                  t3.description) AS a 
       --the below area is used to convert t3.DESCRIPTION into Pivot Column based on type of leave if missing any type you have to add manually.
       PIVOT ( Sum(timedescription) 
             FOR description IN ([Present], 
                                 [Day Off], 
                                 [Unpaid leave], 
                                 [Annual Leave], 
                                 [Sick Leave Paid 100%], 
                                 [Sick Leave Half Pay\Half Day])) AS pvt 
ORDER  BY employeecode 