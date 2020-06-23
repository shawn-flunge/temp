<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        if(!Page.IsPostBack)
        {

            int j = 5;

            for(int i = 0; i < j; i++)
            {
                Wizard1.WizardSteps.Add(new WizardStep());
            }


        }

    }


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>

            <asp:Wizard ID="Wizard1" runat="server">
                <WizardSteps>
                    <asp:WizardStep ID="WizardStep1" runat="server" Title="Step 1"></asp:WizardStep>
                    <asp:WizardStep ID="WizardStep2" runat="server" Title="Step 2"></asp:WizardStep>
                </WizardSteps>
            </asp:Wizard>

        </div>
    </form>
</body>
</html>
