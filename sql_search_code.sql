declare @keyword nvarchar(max) = 'ExitDate' -- keyword to search for
declare @onlyCustomScripts bit = 0 -- set to 1 to limit search in DialogScript to custom scripts

set @keyword = replace(replace(@keyword, '\', '_'), '.', '_') -- replace '\' and '.' with single char wildcard to match ConfigParms by fullpath and by type safe notation

-- table scripts
select 'DialogTable' as ObjectType, 'OnDiscardedScript' as ObjectAttribute, TableName as ObjectName, UID_DialogTable as ObjectUID from DialogTable where OnDiscardedScript like '%'+@keyword+'%'
union
select 'DialogTable' as ObjectType, 'OnDiscardingScript' as ObjectAttribute, TableName as ObjectName, UID_DialogTable as ObjectUID from DialogTable where OnDiscardedScript like '%'+@keyword+'%'
union
select 'DialogTable' as ObjectType, 'OnLoadedScript' as ObjectAttribute, TableName as ObjectName, UID_DialogTable as ObjectUID from  DialogTable where OnLoadedScript like '%'+@keyword+'%'
union
select 'DialogTable' as ObjectType, 'OnSavedScript' as ObjectAttribute, TableName as ObjectName, UID_DialogTable as ObjectUID from DialogTable where OnSavedScript like '%'+@keyword+'%'
union
select 'DialogTable' as ObjectType, 'OnSavingScript' as ObjectAttribute, TableName as ObjectName, UID_DialogTable as ObjectUID from DialogTable where OnSavingScript like '%'+@keyword+'%'

-- column scripts
union
select 'DialogColumn' as ObjectType, 'FormatScript' as ObjectAttribute, dt.TableName+'.'+dc.ColumnName as ObjectName, dc.UID_DialogColumn as ObjectUID from DialogColumn dc join DialogTable dt on dc.UID_DialogTable = dt.UID_DialogTable where dt.TableName = 'DialogColumn' and FormatScript like '%'+@keyword+'%'
union
select 'DialogColumn' as ObjectType, 'Template' as ObjectAttribute, dt.TableName+'.'+dc.ColumnName as ObjectName, dc.UID_DialogColumn as ObjectUID from DialogColumn dc join DialogTable dt on dc.UID_DialogTable = dt.UID_DialogTable where dt.TableName = 'DialogColumn' and Template like '%'+@keyword+'%'

-- processes
union
select 'JobChain' as ObjectType, 'GenCondition' as ObjectAttribute, Name as ObjectName, UID_JobChain as ObjectUID from JobChain where GenCondition like '%'+@keyword+'%'
union
select 'JobChain' as ObjectType, 'PreCode' as ObjectAttribute, Name as ObjectName, UID_JobChain as ObjectUID from JobChain where PreCode like '%'+@keyword+'%'

-- process steps
union
select 'Job' as ObjectType, 'GenCondition' as ObjectAttribute, jc.Name+'.'+j.Name as ObjectName, j.UID_Job as ObjectUID from JobChain jc join Job j on jc.UID_JobChain = j.UID_JobChain where j.GenCondition like '%'+@keyword+'%'
union
select 'Job' as ObjectType, 'PreCode' as ObjectAttribute, jc.Name+'.'+j.Name as ObjectName, j.UID_Job as ObjectUID from JobChain jc join Job j on jc.UID_JobChain = j.UID_JobChain where j.PreCode like '%'+@keyword+'%'
union
select 'Job' as ObjectType, 'ServerDetectScript' as ObjectAttribute, jc.Name+'.'+j.Name as ObjectName, j.UID_Job as ObjectUID from JobChain jc join Job j on jc.UID_JobChain = j.UID_JobChain where j.ServerDetectScript like '%'+@keyword+'%'

-- process step parameters
union
select 'JobRunParameter' as ObjectType, 'ValueTemplate' as ObjectAttribute, jc.Name+'.'+j.Name+'.'+jrp.Name as ObjectName, UID_JobParameter as ObjectUID from JobChain jc join Job j on jc.UID_JobChain = j.UID_JobChain join JobRunParameter jrp on j.UID_Job = jrp.UID_Job where ValueTemplate like '%'+@keyword+'%'

-- custom scripts
union
select 'DialogScript' as ObjectType, 'Scriptcode' as ObjectAttribute, ScriptName as ObjectName, UID_DialogScript as ObjectUID from DialogScript where ScriptCode like '%'+@keyword+'%' and (dbo.QBM_FCVGUIDToModuleOwner(UID_DialogScript) = 'CCC' or @onlyCustomScripts=0)

-- dynamic groups
union
select 'DynamicGroup' as ObjectType, 'WhereClause' as ObjectAttribute, DisplayName as ObjectName, UID_DynamicGroup as ObjectUID from DynamicGroup where WhereClause like '%'+@keyword+'%'
union
select 'DynamicGroup' as ObjectType, 'WhereClauseAddOn' as ObjectAttribute, DisplayName as ObjectName, UID_DynamicGroup as ObjectUID from DynamicGroup where WhereClauseAddOn like '%'+@keyword+'%'

-- process automation
union
select 'JobAutoStart' as ObjectType, 'WhereClause' as ObjectAttribute, Name as ObjectName, UID_JobAutoStart as ObjectUID from JobAutoStart where WhereClause like '%'+@keyword+'%'

-- decision methods
union
select 'PWODecisionRuleRulerDetect' as ObjectType, 'SQLQuery' as ObjectAttribute, pdr.DecisionRule+'.'+pdrrd.Ident_RulerDetect as ObjectName, UID_PWODecisionRuleRulerDetect as ObjectUID from PWODecisionRuleRulerDetect pdrrd join PWODecisionRule pdr on pdrrd.UID_PWODecisionRule = pdr.UID_PWODecisionRule where pdrrd.SQLQuery like '%'+@keyword+'%'

-- tasks
union
select 'DialogMethod' as ObjectType, 'MethodScript' as ObjectAttribute, MethodName as ObjectName, UID_DialogMethod as ObjectUID from DialogMethod where MethodScript like '%'+@keyword+'%'

-- Events
union
select 'QBMEvent' as ObjectType, 'EventName' as ObjectAttribute, DisplayName as ObjectName, UID_QBMEvent as ObjectUID from QBMEvent where EventName like '%'+@keyword+'%'