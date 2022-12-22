using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Syncfusion.EJ2.Spreadsheet;

namespace DocumenteditorWeb.Controllers
{
    [Route("api/Spreadsheet")]
    public class SpreadsheetController : Controller
    {

        [HttpPost]
        [Route("open")]
        public IActionResult Open(IFormCollection openRequest)
        {
            OpenRequest open = new OpenRequest
            {
                File = openRequest.Files[0]
            };
            return Content(Workbook.Open(open));
        }


        [HttpPost]
        [Route("save")]
        public IActionResult Save(SaveSettings saveSettings)
        {
            return Workbook.Save(saveSettings);
        }
    }
}