using Lexor.GeoMedia.Settings;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Lexor.GeoMedia.Extensions
{
    // ReSharper disable once InconsistentNaming
    public static class IServiceCollectionExtensions
    {
        public static void RegisterGeoMediaServices(this IServiceCollection services, IConfiguration configuration, string geoMediaSettingsSectionName)
        {
            services.AddSingleton<GeoMediaMetadata, GeoMediaMetadata>();
            services.Configure<GeoMediaSettings>(configuration.GetSection(geoMediaSettingsSectionName));
        }
    }
}
