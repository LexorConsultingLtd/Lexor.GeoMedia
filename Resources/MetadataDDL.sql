/****** Object:  UserDefinedFunction [Binary2SqlGeography]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Binary2SqlGeography] (@Blob varbinary(max)) RETURNS geography AS BEGIN RETURN CAST(@Blob AS geography); END
GO
/****** Object:  UserDefinedFunction [Binary2SqlGeometry]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Binary2SqlGeometry] (@Blob varbinary(max)) RETURNS geometry AS BEGIN RETURN CAST(@Blob AS geometry); END
GO
/****** Object:  UserDefinedFunction [SqlGeography2Binary]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [SqlGeography2Binary] (@Blob geography) RETURNS varbinary(max) AS BEGIN RETURN CAST(@Blob AS varbinary(max)); END
GO
/****** Object:  UserDefinedFunction [SqlGeometry2Binary]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [SqlGeometry2Binary] (@Blob geometry) RETURNS varbinary(max) AS BEGIN RETURN CAST(@Blob AS varbinary(max)); END
GO
/****** Object:  Table [GIndexColumns]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GIndexColumns](
	[OBJECT_SCHEMA] [sysname] NOT NULL,
	[OBJECT_NAME] [sysname] NOT NULL,
	[INDEX_NAME] [nvarchar](64) NOT NULL,
	[COLUMN_NAME] [sysname] NOT NULL,
	[COLUMN_POSITION] [smallint] NOT NULL,
	[INDEX_TYPE] [char](1) NULL,
	[BASE_OBJECT_SCHEMA] [nvarchar](255) NULL,
	[BASE_OBJECT_NAME] [nvarchar](255) NULL,
	[BASE_COLUMN_NAME] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[OBJECT_SCHEMA] ASC,
	[OBJECT_NAME] ASC,
	[INDEX_NAME] ASC,
	[COLUMN_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [ModifiedTables]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [ModifiedTables]([ModifiedTableID], [TableName], KeyField1, KeyField2, KeyField3, KeyField4, KeyField5, KeyField6, KeyField7, KeyField8, KeyField9, KeyField10) AS
  SELECT o.id, o.name,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 1) collate DATABASE_DEFAULT,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 2) collate DATABASE_DEFAULT,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 3) collate DATABASE_DEFAULT,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 4) collate DATABASE_DEFAULT,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 5) collate DATABASE_DEFAULT,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 6) collate DATABASE_DEFAULT,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 7) collate DATABASE_DEFAULT,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 8) collate DATABASE_DEFAULT,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 9) collate DATABASE_DEFAULT,
	index_col(user_name(o.uid)+'.'+o.name, i.indid, 10) collate DATABASE_DEFAULT
  FROM dbo.sysobjects o  INNER JOIN dbo.sysindexes i ON i.id = o.id
  WHERE o.xtype='U' AND (i.status & 0x800) = 0x800 AND ObjectProperty(o.id, N'IsMSShipped') = 0

  Union  
  
  SELECT o.id, o.name,
	KeyField1 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=1),
	KeyField2 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=2),
	KeyField3 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=3),
	KeyField4 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=4),
	KeyField5 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=5),
	KeyField6 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=6),
	KeyField7 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=7),
	KeyField8 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=8),
	KeyField9 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=9),
	KeyField10 = (SELECT ic.COLUMN_NAME FROM [dbo].[GIndexColumns] ic WHERE ic.[OBJECT_NAME]=o.name AND ic.COLUMN_POSITION=10) 
  FROM (select id, name collate DATABASE_DEFAULT as name, xtype from dbo.sysobjects) o  
  WHERE o.xtype='V' AND EXISTS(SELECT * FROM [dbo].[GIndexColumns] ic WHERE ic.[INDEX_TYPE]='P' AND ic.[OBJECT_NAME]=o.name)GO
/****** Object:  Table [AttributeProperties]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AttributeProperties](
	[IndexID] [int] NOT NULL,
	[IsKeyField] [bit] NOT NULL,
	[IsFieldDisplayable] [bit] NOT NULL,
	[FieldType] [smallint] NULL,
	[FieldPrecision] [smallint] NULL,
	[FieldFormat] [nvarchar](255) NULL,
	[FieldDescription] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[IndexID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CouncilWards]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [FieldLookup]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FieldLookup](
	[IndexID] [int] IDENTITY(1,1) NOT NULL,
	[FeatureName] [sysname] NOT NULL,
	[FieldName] [sysname] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IndexID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [GAliasTable]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GAliasTable](
	[TableType] [sysname] NOT NULL,
	[TableName] [sysname] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TableType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [GCoordSystem]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GCoordSystem](
	[CSGUID] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[CSGUIDTYPE] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Description] [nvarchar](255) NULL,
	[BaseStorageType] [tinyint] NOT NULL,
	[Stor2CompMatrix1] [float] NULL,
	[Stor2CompMatrix2] [float] NULL,
	[Stor2CompMatrix3] [float] NULL,
	[Stor2CompMatrix4] [float] NULL,
	[Stor2CompMatrix5] [float] NULL,
	[Stor2CompMatrix6] [float] NULL,
	[Stor2CompMatrix7] [float] NULL,
	[Stor2CompMatrix8] [float] NULL,
	[Stor2CompMatrix9] [float] NULL,
	[Stor2CompMatrix10] [float] NULL,
	[Stor2CompMatrix11] [float] NULL,
	[Stor2CompMatrix12] [float] NULL,
	[Stor2CompMatrix13] [float] NULL,
	[Stor2CompMatrix14] [float] NULL,
	[Stor2CompMatrix15] [float] NULL,
	[Stor2CompMatrix16] [float] NULL,
	[HeightStorageType] [tinyint] NULL,
	[LonNormStorageOpt] [tinyint] NULL,
	[GeodeticDatum] [smallint] NULL,
	[Ellipsoid] [smallint] NULL,
	[EquatorialRadius] [float] NULL,
	[InverseFlattening] [float] NULL,
	[ProjAlgorithm] [smallint] NULL,
	[AzimuthAngle] [float] NULL,
	[FalseX] [float] NULL,
	[FalseY] [float] NULL,
	[Hemisphere] [tinyint] NULL,
	[LatOfOrigin] [float] NULL,
	[LatOfTrueScale] [float] NULL,
	[LonOfOrigin] [float] NULL,
	[RadOfStandCircle] [float] NULL,
	[ScaleReductFact] [float] NULL,
	[StandPar1] [float] NULL,
	[StandPar2] [float] NULL,
	[Zone] [smallint] NULL,
	[PathNumber] [smallint] NULL,
	[RowNumber] [smallint] NULL,
	[Satellite] [smallint] NULL,
	[XAzDefOpt] [tinyint] NULL,
	[GeomHeightOfOrig] [float] NULL,
	[GeomHeightOfPoint1] [float] NULL,
	[GeomHeightOfPoint2] [float] NULL,
	[LatOfPoint1] [float] NULL,
	[LatOfPoint2] [float] NULL,
	[LonOfPoint1] [float] NULL,
	[LonOfPoint2] [float] NULL,
	[ArgumentOfPerigee] [float] NULL,
	[EarthRotPeriod] [float] NULL,
	[FourierExpansionDegree] [tinyint] NULL,
	[NodesInSimpsonIntegration] [tinyint] NULL,
	[OrbEarthRotPeriodRatio] [float] NULL,
	[OrbEcc] [float] NULL,
	[OrbInclination] [float] NULL,
	[OrbOff] [float] NULL,
	[OrbPeriod] [float] NULL,
	[OrbSemimajAxis] [float] NULL,
	[OblMercDefMode] [tinyint] NULL,
	[LatOfMapCenter] [float] NULL,
	[OblLamConfConDefMode] [tinyint] NULL,
	[RotNorthPoleLat] [float] NULL,
	[RotNorthPoleLon] [float] NULL,
	[GaussianLat] [float] NULL,
	[SpherModel] [tinyint] NULL,
	[SpherRadius] [float] NULL,
	[LatOfBasisPointA] [float] NULL,
	[LatOfBasisPointB] [float] NULL,
	[LatOfBasisPointC] [float] NULL,
	[LonOfBasisPointA] [float] NULL,
	[LonOfBasisPointB] [float] NULL,
	[LonOfBasisPointC] [float] NULL,
	[ChamTriOriginDefMode] [tinyint] NULL,
	[AngOrientationProjPlaneDefMode] [tinyint] NULL,
	[AzOfUpwardTilt] [float] NULL,
	[FocalLength] [float] NULL,
	[HeightAboveEllipAtNadir] [float] NULL,
	[HeightOrigOfLocalHorizSys] [float] NULL,
	[LatOrigOfLocalHorizSys] [float] NULL,
	[LocationOfProjPlaneDefMode] [tinyint] NULL,
	[LonOrigOfLocalHorizSys] [float] NULL,
	[PerspCenterGeocX] [float] NULL,
	[PerspCenterGeocY] [float] NULL,
	[PerspCenterGeocZ] [float] NULL,
	[PerspCenterHeight] [float] NULL,
	[PerspCenterLat] [float] NULL,
	[PerspCenterLon] [float] NULL,
	[PerspCenterXEast] [float] NULL,
	[PerspCenterYNorth] [float] NULL,
	[PerspCenterZUp] [float] NULL,
	[RefCoordSysDefMode] [tinyint] NULL,
	[RotAboutXAxis] [float] NULL,
	[RotAboutYAxis] [float] NULL,
	[RotAboutZAxis] [float] NULL,
	[SwingAng] [float] NULL,
	[TiltAng] [float] NULL,
	[ExtendProjMatrix1] [float] NULL,
	[ExtendProjMatrix2] [float] NULL,
	[ExtendProjMatrix3] [float] NULL,
	[ExtendProjMatrix4] [float] NULL,
	[ExtendProjMatrix5] [float] NULL,
	[ExtendProjMatrix6] [float] NULL,
	[ExtendProjMatrix7] [float] NULL,
	[ExtendProjMatrix8] [float] NULL,
	[ExtendProjMatrix9] [float] NULL,
	[ExtendProjMatrix10] [float] NULL,
	[ExtendProjMatrix11] [float] NULL,
	[ExtendProjMatrix12] [float] NULL,
	[ExtendProjMatrix13] [float] NULL,
	[ExtendProjMatrix14] [float] NULL,
	[ExtendProjMatrix15] [float] NULL,
	[ExtendProjMatrix16] [float] NULL,
	[VerticalDatum] [smallint] NULL,
	[UndulationModel] [smallint] NULL,
	[AverageUndulation] [float] NULL,
	[NamedGeodeticDatum] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[CSGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [GeometryProperties]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GeometryProperties](
	[IndexID] [int] NOT NULL,
	[PrimaryGeometryFlag] [bit] NOT NULL,
	[GeometryType] [int] NULL,
	[GCoordSystemGUID] [uniqueidentifier] NULL,
	[FieldDescription] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[IndexID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [GFeatures]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GFeatures](
	[FeatureName] [sysname] NOT NULL,
	[GeometryType] [int] NULL,
	[PrimaryGeometryFieldName] [nvarchar](255) NULL,
	[FeatureDescription] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[FeatureName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [GFieldMapping]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GFieldMapping](
	[TABLE_NAME] [sysname] NOT NULL,
	[COLUMN_NAME] [sysname] NOT NULL,
	[DATA_TYPE] [int] NULL,
	[DATA_SUBTYPE] [int] NULL,
	[CSGUID] [uniqueidentifier] NULL,
	[AUTOINCREMENT] [bit] NULL,
	[NATIVE_GEOMETRY] [sysname] NULL,
	[NATIVE_SRID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TABLE_NAME] ASC,
	[COLUMN_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [GParameters]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GParameters](
	[GPARAMETER] [nvarchar](255) NOT NULL,
	[GVALUE] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[GPARAMETER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [GPickLists]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GPickLists](
	[FeatureName] [nvarchar](255) NOT NULL,
	[FieldName] [nvarchar](255) NOT NULL,
	[PickListTableName] [nvarchar](255) NULL,
	[ValueFieldName] [nvarchar](255) NULL,
	[DescriptionFieldName] [nvarchar](255) NULL,
	[FilterClause] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[FeatureName] ASC,
	[FieldName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [GQueue]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GQueue](
	[QueueName] [nvarchar](64) NULL,
	[TableName] [sysname] NOT NULL,
	[Qeditemdcsfieldname] [nvarchar](255) NULL,
	[Qedstsfieldname] [sysname] NOT NULL,
	[Qedcreator] [nvarchar](255) NULL,
	[Qednumgeomfieldnames] [int] NULL,
	[Qeduseformbrgeomfieldnames] [varbinary](1) NULL,
	[Qedaddgeomfieldnames] [varbinary](1) NULL,
	[Qednumstatuslist] [int] NULL,
	[Qedstatuslistnamevalue] [varbinary](1) NULL,
	[Qedsortfieldname] [nvarchar](255) NULL,
	[Qedsortascending] [int] NULL,
	[Readonlyfieldnames] [varbinary](1) NULL,
	[Nondisplayablefieldnames] [varbinary](1) NULL,
	[Nonlocatablefieldnames] [varbinary](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [GTileIndexes]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GTileIndexes](
	[TABLE_SCHEMA] [sysname] NOT NULL,
	[TABLE_NAME] [sysname] NOT NULL,
	[GEOMETRY_COLUMN_NAME] [sysname] NOT NULL,
	[TILE_COLUMN_NAME] [sysname] NOT NULL,
	[TILE_TABLE_SCHEMA] [nvarchar](255) NULL,
	[TILE_TABLE_NAME] [nvarchar](255) NULL,
	[FILTER_OPTIONS] [int] NULL,
	[X_TILES] [int] NULL,
	[Y_TILES] [int] NULL,
	[XLO] [float] NULL,
	[XHI] [float] NULL,
	[YLO] [float] NULL,
	[YHI] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[TABLE_SCHEMA] ASC,
	[TABLE_NAME] ASC,
	[GEOMETRY_COLUMN_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [ModificationLog]    Script Date: 10/15/2017 10:03:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ModificationLog](
	[ModificationNumber] [int] IDENTITY(1,1) NOT NULL,
	[Type] [tinyint] NULL,
	[ModifiedTableID] [int] NULL,
	[KeyValue1] [nvarchar](255) NULL,
	[KeyValue2] [nvarchar](255) NULL,
	[KeyValue3] [nvarchar](255) NULL,
	[KeyValue4] [nvarchar](255) NULL,
	[KeyValue5] [nvarchar](255) NULL,
	[KeyValue6] [nvarchar](255) NULL,
	[KeyValue7] [nvarchar](255) NULL,
	[KeyValue8] [nvarchar](255) NULL,
	[KeyValue9] [nvarchar](255) NULL,
	[KeyValue10] [nvarchar](255) NULL,
	[SESSIONID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ModificationNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'GADOFieldMapping', N'GFieldMapping')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'GCoordSystemTable', N'GCoordSystem')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'GIndexColumns', N'GIndexColumns')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'GModifications', N'ModificationLog')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'GModifiedTables', N'ModifiedTables')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'GParameters', N'GParameters')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'GQueue', N'GQueue')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'GTileIndexes', N'GTileIndexes')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'INGRAttributeProperties', N'AttributeProperties')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'INGRDictionaryProperties', N'GDictionaryProperties')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'INGRFeatures', N'GFeatures')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'INGRFieldLookup', N'FieldLookup')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'INGRGeometryProperties', N'GeometryProperties')
GO
INSERT [GAliasTable] ([TableType], [TableName]) VALUES (N'INGRPickLists', N'GPickLists')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'DefaultNativeGeometrySrid', N'0')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'TypeForBinaryStorage', N'varbinary(MAX)')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'TypeForDateTimeStorage', N'datetime')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'TypeForGeometryStorage', N'varbinary(MAX)')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'TypeForGUIDStorage', N'uniqueidentifier')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'TypeForMemoStorage', N'ntext')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'TypeForNativeGeometryStorage', N'geometry')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'TypeForTextStorage', N'nvarchar')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'XLowerBound', N'-2147483648')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'XUpperBound', N'2147483647')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'YLowerBound', N'-2147483648')
GO
INSERT [GParameters] ([GPARAMETER], [GVALUE]) VALUES (N'YUpperBound', N'2147483647')
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [idx_FieldLookup]    Script Date: 10/15/2017 10:03:40 PM ******/
CREATE NONCLUSTERED INDEX [idx_FieldLookup] ON [FieldLookup]
(
	[FeatureName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Idx_GPickLists]    Script Date: 10/15/2017 10:03:40 PM ******/
CREATE NONCLUSTERED INDEX [Idx_GPickLists] ON [GPickLists]
(
	[FeatureName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [GIndexColumns] ADD  DEFAULT ('dbo') FOR [OBJECT_SCHEMA]
GO
ALTER TABLE [GIndexColumns] ADD  DEFAULT ((1)) FOR [COLUMN_POSITION]
GO
ALTER TABLE [GIndexColumns] ADD  DEFAULT ('P') FOR [INDEX_TYPE]
GO
ALTER TABLE [ModificationLog] ADD  DEFAULT (@@spid) FOR [SESSIONID]
GO
ALTER TABLE [ModificationLog] ADD  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [GeometryProperties]  WITH CHECK ADD FOREIGN KEY([IndexID])
REFERENCES [FieldLookup] ([IndexID])
GO
ALTER TABLE [GeometryProperties]  WITH CHECK ADD CHECK  (([GeometryType]=(10) OR [GeometryType]=(5) OR [GeometryType]=(4) OR [GeometryType]=(3) OR [GeometryType]=(2) OR [GeometryType]=(1)))
GO
