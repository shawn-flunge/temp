<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            아이디 : <asp:TextBox ID="TextBox1" runat="server" TextMode="SingleLine"></asp:TextBox><asp:Button ID="Button1" runat="server" Text="중복확인" /><br />
            비밀번호 : <asp:TextBox ID="TextBox2" runat="server" TextMode="Password"></asp:TextBox><br />
            비밀번호 확인 : <asp:TextBox ID="TextBox3" runat="server" TextMode="Password"></asp:TextBox><br />
            이메일 : <asp:TextBox ID="TextBox4" runat="server" TextMode="SingleLine" ></asp:TextBox>
            

        </div>
    </form>
</body>
</html>
