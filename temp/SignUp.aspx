<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net.Mail" %>

<!DOCTYPE html>

<script runat="server">

   


    protected void Button2_Click(object sender, EventArgs e)
    {
        MailMessage message = new MailMessage();

        message.From = new MailAddress("echun1234@gmail.com","이시헌",System.Text.Encoding.UTF8);
        message.To.Add(new MailAddress("dltlgjs99@naver.com"));
        message.IsBodyHtml = true;

        message.Subject = "회원 가입 환영 안내";
        message.Body = "야호";

        message.SubjectEncoding = System.Text.Encoding.UTF8;
        message.BodyEncoding = System.Text.Encoding.UTF8;

        SmtpClient client = new SmtpClient("smtp.gmail.com", 587);

        client.EnableSsl = true;
        client.UseDefaultCredentials = false;
        client.Credentials = new System.Net.NetworkCredential("echun1234@gmail.com", "!dksk1399");
        client.Send(message);
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
            아이디 : <asp:TextBox ID="TextBox1" runat="server" TextMode="SingleLine"></asp:TextBox><asp:Button ID="Button1" runat="server" Text="중복확인" /><br />
            비밀번호 : <asp:TextBox ID="TextBox2" runat="server" TextMode="Password"></asp:TextBox><br />
            비밀번호 확인 : <asp:TextBox ID="TextBox3" runat="server" TextMode="Password"></asp:TextBox><br />
            이메일 : <asp:TextBox ID="TextBox4" runat="server" TextMode="SingleLine" ></asp:TextBox><asp:Button ID="Button2" runat="server" Text="메일전송" OnClick="Button2_Click" />
            

        </div>
    </form>
</body>
</html>
