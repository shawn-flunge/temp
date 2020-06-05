<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html>

<script runat="server">

    //엑셀파일 뭐불러 올건지
    string fileName;

    protected void Page_Load(object sender, EventArgs e)
    {
        fileName ="C:\\works/" +"toeic.xls";
        LoadExcel(fileName);

    }



    public DataTable LoadExcel(string fileName)
    {

        //OLEDB사용
        string provider = "Provider=Microsoft.Jet.OLEDB.4.0;";
        //엑셀데이터 위치
        string DataSource = "Data Source=" + fileName + ";" ;
        //속성 값, hdr == 헤더부터 데이터인지, IMEX == 읽기로만 사용해서 가져온 셀의 데이터를 스트링 값으로
        string ExtendsProperties = "Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1\"";

        string con = provider + DataSource + ExtendsProperties;


        OleDbConnection oleCon = new OleDbConnection(con);
        //첫번째 시트에서 가져오게
        OleDbCommand cmd = new OleDbCommand("Select * FROM [Sheet1$]", oleCon);
        oleCon.Open();

        //adapter사용
        OleDbDataAdapter adapter = new OleDbDataAdapter();

        adapter.SelectCommand = cmd;

        DataSet dsData = new DataSet();

        adapter.Fill(dsData);

        DataTable dataTable = new DataTable();
        //테이블에 커맨드 실행한걸 로드함
        dataTable.Load(cmd.ExecuteReader());
        //str = dataTable.Rows[0][0].ToString();

        //엑셀 데이터가 로드된 데이터 테이블 반환
        return dataTable;
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
