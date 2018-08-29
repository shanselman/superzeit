using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace superzeit
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }
        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                // .ConfigureAppConfiguration((builderContext, config) =>
                // {
                //     IHostingEnvironment env = builderContext.HostingEnvironment;
                //     config.Sources.Clear(); //Don't use the default AddJsonFile
                //     config.AddJsonFile("appsettings.json", optional: false, reloadOnChange: false)
                //         .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true, reloadOnChange: false); 
                //         //changed to reloadOnChange to false to better support Alpine and constrained environments that don't like a lot of File Watchers
                //         // avoids errors like:
                //         // The configured user limit (128) on the number of inotify instances has been reached
                // })
                .UseStartup<Startup>();
    }
}
