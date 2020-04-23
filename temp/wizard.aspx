<%@ Page Language="C#" AutoEventWireup="true" CodeFile="wizard.aspx.cs" Inherits="final_wizard" %>

<!DOCTYPE html>

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
                    <asp:WizardStep ID="WizardStep1" runat="server" Title="Step 1" StepType="Start">

                        <asp:RadioButtonList ID="RadioButtonList1" runat="server" >


                            <asp:ListItem>temp</asp:ListItem>
                            <asp:ListItem>temp2</asp:ListItem>
                            <asp:ListItem>temp3</asp:ListItem>
                            <asp:ListItem>temp4</asp:ListItem>


                        </asp:RadioButtonList>

                    </asp:WizardStep>
                    <asp:WizardStep ID="WizardStep2" runat="server" Title="Step 2">

                    </asp:WizardStep>
                    <asp:WizardStep ID="WizardStep3"  runat="server" Title="Step 3">

                    </asp:WizardStep>
                    <asp:WizardStep ID="WizardStep4"  runat="server" Title="Step 4">

                    </asp:WizardStep>
                    <asp:WizardStep ID="WizardStep5"  runat="server" Title="Step 5">

                    </asp:WizardStep>
                    <asp:WizardStep ID="WizardStep6"  runat="server" Title="Step 6">

                    </asp:WizardStep>
                    <asp:WizardStep ID="WizardStep7"  runat="server" Title="Step 7">

                    </asp:WizardStep>
                    <asp:WizardStep ID="WizardStep8"  runat="server" Title="Step 8">

                    </asp:WizardStep>
                    <asp:WizardStep ID="WizardStep9"  runat="server" Title="Step 9">

                    </asp:WizardStep>
                    <asp:WizardStep ID="WizardStep10"  runat="server" StepType="Finish" Title="Step 10">

                    </asp:WizardStep>
                </WizardSteps>
            </asp:Wizard>



        </div>
    </form>
</body>
</html>
