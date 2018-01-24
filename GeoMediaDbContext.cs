using Lexor.Data.SqlServerSpatial;
using Lexor.Data.SqlServerSpatial.Settings;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.Extensions.Options;
using System.Reflection;

namespace Lexor.GeoMedia
{
    public class GeoMediaDbContext : SqlServerSpatialDbContext
    {
        protected GeoMediaDbContext(DbContextOptions options, IOptions<SqlServerSpatialSettings> settings)
            : base(options, settings) { }

        protected override void PerformAdditionalSpatialColumnProcessing(ModelBuilder modelBuilder, IEntityType entityType, PropertyInfo property, SqlServerSpatialEntityMetadata metadata)
        {
            base.PerformAdditionalSpatialColumnProcessing(modelBuilder, entityType, property, metadata);

            // Add requried GeoMedia version of geometry as a shadow field. This will be stored in the database but invisible to the model.
            // This will be the "primary" geometry field, and the previous field will be the "native" geometry field.
            modelBuilder
                .Entity(entityType.Name)
                .Property<byte[]>(GeoMediaMetadata.GetGeoMediaSpatialColumnName(property.Name))
                .HasColumnType("varbinary(max)")
                .IsRequired(false);
        }
    }
}
