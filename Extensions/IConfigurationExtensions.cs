using Lexor.GeoMedia.Settings;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Lexor.GeoMedia.Extensions
{
    // ReSharper disable once InconsistentNaming
    public static class IConfigurationExtensions
    {
        public static void RegisterGeoMediaServices(this IConfiguration configuration, IServiceCollection services, string geoMediaSettingsSectionName)
        {
            services.AddSingleton<GeoMediaMetadata, GeoMediaMetadata>();
            services.Configure<GeoMediaSettings>(configuration.GetSection(geoMediaSettingsSectionName));
        }
    }
}
