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
/* 
    hey everyone... 

    so this is readonly

        you should be able to open any file

        now look at the termianl

        CHECK THIS OUT - go to http://localhost:5000 your YOUR MACHINE
    */

    public class Program
    {
        //now go hit http://localhost:5000 on yoru own machine 
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }
        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((builderContext, config) =>
                {
                    IHostingEnvironment env = builderContext.HostingEnvironment;
                    config.Sources.Clear(); //Don't use the default AddJsonFile
                    config.AddJsonFile("config/appsettings.json", optional: false, reloadOnChange: true)
                        .AddJsonFile($"config/appsettings.{env.EnvironmentName}.json", optional: true, reloadOnChange: true); 
                        //changed to reloadOnChange to false to better support Alpine and constrained environments that don't like a lot of File Watchers
                        // avoids errors like:
                        // The configured user limit (128) on the number of inotify instances has been reached
                })
                .UseStartup<Startup>();
    }
}
