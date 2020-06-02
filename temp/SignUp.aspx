<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net.Mail" %>

<!DOCTYPE html>

<script runat="server">

    string verificationCode;

    public string CreateRandomNum()
    {
        Random random = new Random();
        int[] a = new int[4];

        for(int i=0; i<4; i++)
        {
            a[i]  = (int)(random.NextDouble()*10);
        }
        for(int i=0; i<4; i++)
        {
            verificationCode += a[i];
        }


        return verificationCode;
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        MailMessage message = new MailMessage();

        message.From = new MailAddress("echun1234@gmail.com","이시헌",System.Text.Encoding.UTF8);
        message.To.Add(new MailAddress("dltlgjs99@naver.com"));
        message.IsBodyHtml = true;

        CreateRandomNum();
        message.Subject = "Toword";
        message.Body = verificationCode;

        message.SubjectEncoding = System.Text.Encoding.UTF8;
        message.BodyEncoding = System.Text.Encoding.UTF8;

        SmtpClient client = new SmtpClient("smtp.gmail.com", 587);

        client.EnableSsl = true;
        client.UseDefaultCredentials = false;
        client.Credentials = new System.Net.NetworkCredential("echun1234@gmail.com", "!dksk1399");
        client.Send(message);
        Button2.Text = verificationCode;
    }


</script>
<script lang="javascript" type="text/javascript">

    function openCk() {
        window.name = "ckForm";
        window.open("wizard.aspx", "check", "width=500, height=300");
    }


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="userInfo" runat="server">
        <div>
            아이디 : <asp:TextBox ID="TextBox1" runat="server" TextMode="SingleLine"></asp:TextBox><input type="button" value="중복확인" onclick="openCk()" /><br />

            비밀번호 : <asp:TextBox ID="pwd" runat="server" TextMode="Password"></asp:TextBox>
             <asp:RequiredFieldValidator ID="RequireFieldValidation1" runat="server" ErrorMessage="<font color='red'>비밀번호를 입력하세요</font>" 
                        ControlToValidate="pwd" Display="Dynamic"></asp:RequiredFieldValidator>  <br />
            비밀번호 확인 : <asp:TextBox ID="pwdck" runat="server" TextMode="Password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="<font color='green'>비밀번호확인을 입력하세요</font>" 
                        ControlToValidate="pwdck" Display="Dynamic"></asp:RequiredFieldValidator>  <br />
            <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="비밀번호가 일치하지 않습니다" ControlToValidate="pwd" ControlToCompare="pwdck" Display="Dynamic"></asp:CompareValidator>

            이메일 : <asp:TextBox ID="TextBox4" runat="server" TextMode="SingleLine" ></asp:TextBox><asp:Button ID="Button2" runat="server" Text="메일전송" OnClick="Button2_Click" />
            

        </div>
    </form>
</body>
</html>
