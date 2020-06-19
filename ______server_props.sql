
SELECT
	server_instance_name =		SERVERPROPERTY( 'ServerName')					-- both the Windows server and instance information associated with a specified instance of SQL Server
	, machine_name =			SERVERPROPERTY( 'MachineName')					-- Windows computer name
																					-- for a stand-alone instance, is the same as "ComputerNamePhysicalNetBIOS" property
																					-- for a clustered instance, returns the name of the virtual server, i.e. the name of the failover clustered instance
	, net_bios_name =			SERVERPROPERTY( 'ComputerNamePhysicalNetBIOS')	-- NetBIOS computer name
																					-- for a stand-alone instance, is the same as "MachineName" property
																					-- for a clustered instance, returns the name of the actual node
																						-- if the instance fails over to other nodes in the failover cluster, this value changes accordingly
	, instance_name =			SERVERPROPERTY( 'InstanceName')					-- name of the instance to which the user is connected; returns NULL if the instance name is the default instance
  ;
SELECT
	server_edition =			SERVERPROPERTY( 'Edition')						-- SQL Server instance edition
																					-- corresponds to "Stock Keeping Unit Name" property in the "Advanced" tab of the SQL Server service properties
	, engine_edition =			CASE SERVERPROPERTY( 'EngineEdition')			-- Database Engine edition:
									WHEN 3 THEN '"Enterprise"'						-- Evaluation, Developer, and both Enterprise editions
									WHEN 2 THEN '"Standard"'						-- Standard, Web, and Business Intelligence
									WHEN 4 THEN '"Express"'							-- Express, Express with Tools and Express with Advanced Services
									WHEN 5 THEN '"SQL Database"'					-- SQL Database (Azure)
									WHEN 5 THEN '"SQL DataWarehouse"'				-- SQL Data Warehouse (Azure)
									ELSE '"UNKNOWN"' END
	, server_collation =		SERVERPROPERTY( 'Collation')					-- default collation of the instance
	, win_locale =				SERVERPROPERTY( 'LCID')							-- Windows locale identifier of the default collation of the instance
  ;
SELECT
	version_name =				CASE 
									WHEN ( @@MICROSOFTVERSION & 0xFF000000) / 0x1000000 = 13	THEN '"SQL2016"'
									WHEN ( @@MICROSOFTVERSION & 0xFF000000) / 0x1000000 = 12	THEN '"SQL2014"'
									WHEN ( @@MICROSOFTVERSION & 0xFF000000) / 0x1000000 = 11	THEN '"SQL2012"'
									WHEN ( @@MICROSOFTVERSION & 0xFF000000) / 0x1000000 = 10 
										AND ( @@MICROSOFTVERSION & 0x00FF0000) / 0x10000 = 50	THEN '"SQL2008R2"'
									WHEN ( @@MICROSOFTVERSION & 0xFF000000) / 0x1000000 = 10 
										AND ( @@MICROSOFTVERSION & 0x00FF0000) / 0x10000 = 0	THEN '"SQL2008"'
																								ELSE LTRIM(RTRIM(STR( @@MICROSOFTVERSION, 20, 0)))
									END
	, build_level =				SERVERPROPERTY( 'ProductLevel')					-- level of the version of the instance of SQL Server; returns one of the following: 'RTM', 'SP<n>', 'CTP'
	, resourcedb_version =		SERVERPROPERTY( 'ResourceVersion')				-- the version of the [Resource] database
	, resourcedb_datetime =		CONVERT( varchar(23), SERVERPROPERTY( 'ResourceLastUpdateDateTime'), 126)	-- the date and time the [Resource] database was last updated
	, full_build_number =		SERVERPROPERTY( 'ProductVersion')				-- version of the SQL Server instance, as 'major.minor.build.revision'
	, major_version =			(@@MICROSOFTVERSION & 0xFF000000) / 0x1000000	-- "major" part of the "ProductVersion" property, i.e. the major version; same as "SERVERPROPERTY( 'ProductMajorVersion')" (since SQL2012)
	, minor_version =			(@@MICROSOFTVERSION & 0x00FF0000) / 0x10000		-- "minor" part of the "ProductVersion" property, i.e. the minor version; same as "SERVERPROPERTY( 'ProductMinorVersion')" (since SQL2012)
	, build_number =			(@@MICROSOFTVERSION & 0x0000FFFF)				-- "build" part of the "ProductVersion" property, i.e. the build number;  same as "SERVERPROPERTY( 'ProductBuild')" (since SQL2012)
	, update_level =			SERVERPROPERTY( 'ProductUpdateLevel')			-- update level of the current build; returns one of the following: CU<n> (i.e. Cumulative Update), NULL (i.e. N/A) (since SQL2012)
  ;
SELECT 
	server_time =				CONVERT( varchar(33), SYSDATETIMEOFFSET(), 126)
	, instance_startup_time =	CONVERT( varchar(23), (SELECT z.sqlserver_start_time FROM sys.dm_os_sys_info z), 126)
	, process_id =				SERVERPROPERTY( 'ProcessID')					-- process ID of the SQL Server service
  ;
       
       
-- SELECT @@VERSION;
-- SELECT @@SERVERNAME


---------------------------------------

/* CPU name */
/*
EXEC xp_instance_regread N'HKEY_LOCAL_MACHINE', N'HARDWARE\DESCRIPTION\System\CentralProcessor\0', N'ProcessorNameString';
*/

