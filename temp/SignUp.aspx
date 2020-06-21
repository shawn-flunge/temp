<%@ Page Language="C#" %>
<%@ Import Namespace="System.Net.Mail" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    string verificationCode;

    public void CreateRandomNum()
    {
        Random random = new Random();
        int[] a = new int[4];

        for(int i=0; i<4; i++)
        {
            a[i]  = (int)(random.NextDouble()*10);
            verificationCode += a[i];
        }
    }

    protected void btnSendMail_Click(object sender, EventArgs e)
    {
        MailMessage message = new MailMessage();

        //누가보내고 누구한테 보내는지
        message.From = new MailAddress("echun1234@gmail.com","이시헌",System.Text.Encoding.UTF8);
        message.To.Add(new MailAddress(email.Text));
        message.IsBodyHtml = true;

        //인증 번호 생성하고 보낼 내용 기술
        CreateRandomNum();
        message.Subject = "Toword 인증번호";
        message.Body = "인증번호는 "+verificationCode +"입니다.";

        //인코딩 설정
        message.SubjectEncoding = System.Text.Encoding.UTF8;
        message.BodyEncoding = System.Text.Encoding.UTF8;

        //smtp설정 gmail이용
        SmtpClient client = new SmtpClient("smtp.gmail.com", 587);

        //기타 설정, 실제 gmail을 이용하여보냄, 구글계정에서 개인설정 필요함
        client.EnableSsl = true;
        client.UseDefaultCredentials = false;
        client.Credentials = new System.Net.NetworkCredential("echun1234@gmail.com", "비밀번호");
        client.Send(message);


        confirmMail.Visible = true;
    }

    public void CheckForSubmit()
    {

        if(pwd==pwdck && confirmMail.Text == verificationCode)
        {
            SqlConnection con = new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=flunge; pwd=dksk1399");

            string sql = "insert into user values(@userid, @password, @email)";
            SqlCommand cmd = new SqlCommand(sql, con);

            cmd.Parameters.AddWithValue("@userid", userID.Text);
            cmd.Parameters.AddWithValue("@password", pwd.Text);
            cmd.Parameters.AddWithValue("@name", email.Text);

            con.Open();
            cmd.ExecuteNonQuery();

            con.Close();
        }


    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        CheckForSubmit();
    }
</script>
<script lang="javascript" type="text/javascript">

    function ConfirmID() {
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
            아이디 : <asp:TextBox ID="userID" runat="server" TextMode="SingleLine"></asp:TextBox><asp:Button ID="Button1" runat="server" Text="중복확인" OnClientClick="return ConfirmID()" /><br />

            비밀번호 : <asp:TextBox ID="pwd" runat="server" TextMode="Password"></asp:TextBox>
             <asp:RequiredFieldValidator ID="RequireFieldValidation1" runat="server" ErrorMessage="<font color='red'>비밀번호를 입력하세요</font>" 
                        ControlToValidate="pwd" Display="Dynamic"></asp:RequiredFieldValidator>  <br />
            비밀번호 확인 : <asp:TextBox ID="pwdck" runat="server" TextMode="Password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="<font color='green'>비밀번호확인을 입력하세요</font>" 
                        ControlToValidate="pwdck" Display="Dynamic"></asp:RequiredFieldValidator>  <br />
            <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="비밀번호가 일치하지 않습니다" ControlToValidate="pwd" ControlToCompare="pwdck" Display="Dynamic"></asp:CompareValidator>

            이메일 : <asp:TextBox ID="email" runat="server" TextMode="SingleLine" placeholder="abcd@toword.com"></asp:TextBox><asp:Button ID="btnSendMail" runat="server" Text="메일전송" OnClick="btnSendMail_Click" /><br />
            <asp:TextBox ID="confirmMail" runat="server" Visible="false" placeholder="인증번호를 입력하세요. "></asp:TextBox>
            
            <asp:Button ID="Button2" runat="server" Text="Button" OnClick="Button2_Click" />

        </div>
    </form>
</body>
</html>
