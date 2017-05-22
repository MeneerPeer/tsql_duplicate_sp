/*
This SP returns all duplicate rows (1 line for each duplicate) for any given table.

to use the SP:
exec [database].[dbo].[sp_duplicates] 
    @table = '[database].[schema].[table]'  

*/
create proc dbo.sp_duplicates @table nvarchar(50) as

declare @query nvarchar(max)
declare @groupby nvarchar(max)

set @groupby =  stuff((select ',' + [name]
				FROM sys.columns
				WHERE object_id = OBJECT_ID(@table)
				FOR xml path('')), 1, 1, '')

set @query = 'select *, count(*)
				from '+@table+'
				group by '+@groupby+'
				having count(*) > 1'

exec (@query)

