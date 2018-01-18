using Lexor.Data.SqlServerSpatial;
using Lexor.GeoMedia.Settings;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Utilities;

namespace Lexor.GeoMedia
{
    public class GeoMediaMetadata
    {
        private GeoMediaSettings Settings { get; }

        public GeoMediaMetadata(IOptions<GeoMediaSettings> settings)
        {
            Settings = settings.Value;
        }

        public async Task UpdateAsync(SqlServerSpatialDbContext context)
        {
            await EnsureMetadataTablesCreated(context);

            const int GeometryColumnType = 32;

            var CoordinateSystemSubquery = $"(select csguid from GCoordSystem where name = '{Settings.CoordinateSystemName}')";
            var SpatialReferenceId = Settings.SpatialReferenceId;

            var sql = new StringBuilder();
            var entities = SqlServerSpatialColumn.GetSpatialColumns(context.Model);
            foreach (var (entity, column, geometryType) in entities)
            {
                var tableName = entity.SqlServer().TableName;
                var columnName = column.Name;
                var geometryTypeValue = GetGeoMediaDataSubType(geometryType);

                // Remove any existing metadata
                sql.AppendLine($"delete from GFeatures where FeatureName = '{tableName}'");
                sql.AppendLine($"delete from GFieldMapping where TABLE_NAME = '{tableName}'");

                // Insert metadata
                var geoMediaSpatialColumnName = GetGeoMediaSpatialColumnName(columnName);
                sql.AppendLine($"insert into GFeatures values ('{tableName}', {geometryTypeValue}, '{geoMediaSpatialColumnName}', '')");
                sql.AppendLine($"insert into GFieldMapping values('{tableName}', '{geoMediaSpatialColumnName}', {GeometryColumnType}, {geometryTypeValue}, {CoordinateSystemSubquery}, null, '{columnName}', {SpatialReferenceId})");

                sql.AppendLine();
            }

            var sqlText = sql.ToString();
            await context.Database.ExecuteSqlCommandAsync(sqlText);
        }

        private object GetGeoMediaDataSubType(GeometryType geometryType)
        {
            switch (geometryType)
            {
                case GeometryType.None:
                    return null;
                case GeometryType.Point:
                    return 10;
                case GeometryType.Line:
                    return 1;
                case GeometryType.Area:
                    return 2;
                case GeometryType.Compound:
                    return 3;
                default:
                    throw new ArgumentOutOfRangeException($"Parameter {nameof(geometryType)} has an unknown value {geometryType}");
            }
        }

        public static string GetGeoMediaSpatialColumnName(string geometryColumnName) => $"{geometryColumnName}_GM";

        #region Metadata

        private async Task EnsureMetadataTablesCreated(SqlServerSpatialDbContext context)
        {
            // Check if metadata objects already exist
            using (var cmd = context.Database.GetDbConnection().CreateCommand())
            {
                cmd.CommandText = "select count(*) from sys.tables where name = 'GFeatures' and type = 'U'";
                await context.Database.OpenConnectionAsync();
                try
                {
                    var metadataExists = 1 == (int)(await cmd.ExecuteScalarAsync());
                    if (metadataExists) return;
                }
                finally
                {
                    context.Database.CloseConnection();
                }
            }

            // Create metadata objects starting with the GeoMedia metadata script (created by SSMS)
            var type = this.GetType();
            string ddl = await Resources.ReadResourceAsync($"{type.Namespace}.Resources.MetadataDDL.sql", type.Assembly);
            var cmds = ddl
                .Split(new[] { "GO\r\n", "GO\n" }, StringSplitOptions.None)
                .Where(cmd => !cmd.StartsWith("USE ") && !string.IsNullOrWhiteSpace(cmd))
                .ToList();
            AppendCoordinateSystemData(cmds);

            // Executre each command in sequence
            foreach (var cmd in cmds)
            {
                try
                {
                    await context.Database.ExecuteSqlCommandAsync(cmd);
                }
                catch (Exception ex)
                {
                    throw new InvalidOperationException($"Error executing GeoMedia metadata DDL cmd: {cmd}", ex);
                }
            }
        }

        #region Coordinate System Data

        private void AppendCoordinateSystemData(List<string> cmds)
        {
            // Append commands to create the default coordinate system
            var coordSystemGuid = Guid.NewGuid().ToString().ToUpper();
            cmds.Add($@"
INSERT [dbo].[GCoordSystem] (
    [CSGUID], [CSGUIDTYPE], [Name], [Description], [BaseStorageType], [Stor2CompMatrix1], [Stor2CompMatrix2], [Stor2CompMatrix3], [Stor2CompMatrix4], 
    [Stor2CompMatrix5], [Stor2CompMatrix6], [Stor2CompMatrix7], [Stor2CompMatrix8], [Stor2CompMatrix9], [Stor2CompMatrix10], [Stor2CompMatrix11], 
    [Stor2CompMatrix12], [Stor2CompMatrix13], [Stor2CompMatrix14], [Stor2CompMatrix15], [Stor2CompMatrix16], [HeightStorageType], [LonNormStorageOpt], 
    [GeodeticDatum], [Ellipsoid], [EquatorialRadius], [InverseFlattening], [ProjAlgorithm], [AzimuthAngle], [FalseX], [FalseY], [Hemisphere], 
    [LatOfOrigin], [LatOfTrueScale], [LonOfOrigin], [RadOfStandCircle], [ScaleReductFact], [StandPar1], [StandPar2], [Zone], [PathNumber], 
    [RowNumber], [Satellite], [XAzDefOpt], [GeomHeightOfOrig], [GeomHeightOfPoint1], [GeomHeightOfPoint2], [LatOfPoint1], [LatOfPoint2], [LonOfPoint1], 
    [LonOfPoint2], [ArgumentOfPerigee], [EarthRotPeriod], [FourierExpansionDegree], [NodesInSimpsonIntegration], [OrbEarthRotPeriodRatio], [OrbEcc], 
    [OrbInclination], [OrbOff], [OrbPeriod], [OrbSemimajAxis], [OblMercDefMode], [LatOfMapCenter], [OblLamConfConDefMode], [RotNorthPoleLat], 
    [RotNorthPoleLon], [GaussianLat], [SpherModel], [SpherRadius], [LatOfBasisPointA], [LatOfBasisPointB], [LatOfBasisPointC], [LonOfBasisPointA], 
    [LonOfBasisPointB], [LonOfBasisPointC], [ChamTriOriginDefMode], [AngOrientationProjPlaneDefMode], [AzOfUpwardTilt], [FocalLength], 
    [HeightAboveEllipAtNadir], [HeightOrigOfLocalHorizSys], [LatOrigOfLocalHorizSys], [LocationOfProjPlaneDefMode], [LonOrigOfLocalHorizSys], 
    [PerspCenterGeocX], [PerspCenterGeocY], [PerspCenterGeocZ], [PerspCenterHeight], [PerspCenterLat], [PerspCenterLon], [PerspCenterXEast], 
    [PerspCenterYNorth], [PerspCenterZUp], [RefCoordSysDefMode], [RotAboutXAxis], [RotAboutYAxis], [RotAboutZAxis], [SwingAng], [TiltAng], 
    [ExtendProjMatrix1], [ExtendProjMatrix2], [ExtendProjMatrix3], [ExtendProjMatrix4], [ExtendProjMatrix5], [ExtendProjMatrix6], [ExtendProjMatrix7], 
    [ExtendProjMatrix8], [ExtendProjMatrix9], [ExtendProjMatrix10], [ExtendProjMatrix11], [ExtendProjMatrix12], [ExtendProjMatrix13], 
    [ExtendProjMatrix14], [ExtendProjMatrix15], [ExtendProjMatrix16], [VerticalDatum], [UndulationModel], [AverageUndulation], [NamedGeodeticDatum]) 
VALUES (
    N'{coordSystemGuid}', 2, N'{Settings.CoordinateSystemName}', N'Default', 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, NULL, 10, 1, 
    6378137, 298.2572221010002, 8, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 101, NULL, NULL, NULL)
");
            cmds.Add($"insert [GParameters] values('DefaultCoordinateSystem', '{{{{{coordSystemGuid}}}}}')"); // Need to double-escape (once for database, once for ExecuteSqlCommand)
        }

        #endregion

        #endregion
    }
}