using CellPhoneWebXml;
using System;
using System.Web.Services;

public partial class _Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string GetMobileCodeInfo(string code)
    {
        string result = new MobileCodeWS().getMobileCodeInfo(code, "");
        return result;
    }
}
