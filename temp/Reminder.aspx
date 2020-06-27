<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html>

<script runat="server">

    //퀴즈 구조체
    public struct quiz
    {
        public string word { get; set; }
        public string meaning { get; set; }
    }

    static class typeOfquiz
    {
        public const int numOfEngToeic = 1480;
        public const int numOfEngBasic = 3000;

        public const string EngToeic = "english_toeic.xls";
        public const string EngBasic = "english_basic.xls";

    }

    //db에서 가져올 퀴즈
    List<quiz> quizzes;
    //오답이 담길 문자열 배열
    string[] incorrect;
    //엑셀파일 뭐불러 올건지
    string fileName;
    //퀴즈에 사용될 오답의 인덱스
    int[] arrWrong;
    //가져온 파일을 담은 데이터테이블
    DataTable dataTable;

    Label[] labels;
    RadioButtonList[] radioList;

    protected void Page_Load(object sender, EventArgs e)
    {
        //로그인안하면 못하게
        if(Session["id"]==null)
        {
            Wizard1.Visible = false;
            Label6.Text = "로그인을 하세요";
        }
        else
        {
            if(!Page.IsPostBack)
            {

                quizzes = setQuiz();

                //저장된 문제가 있어야하니까
                if (quizzes != null)
                {
                    int q = quizzes.Count;

                    labels = new Label[] { Label1, Label2, Label3, Label4, Label5 };
                    radioList = new RadioButtonList[] { RadioButtonList1, RadioButtonList2, RadioButtonList3, RadioButtonList4, RadioButtonList5 };



                    //세션이용해서 파일 설정
                    switch (Session["type"].ToString())
                    {
                        case "engBasic":
                            fileName = "C:\\works/" + typeOfquiz.EngBasic;
                            arrWrong = MakeRandomNum(typeOfquiz.numOfEngBasic, 20);
                            break;
                        case "engToeic":
                            fileName = "C:\\works/" + typeOfquiz.EngToeic;
                            arrWrong = MakeRandomNum(typeOfquiz.numOfEngToeic, 20);
                            break;
                        default:
                            fileName = "C:\\works/" + typeOfquiz.EngBasic;
                            arrWrong = MakeRandomNum(typeOfquiz.numOfEngBasic, 20);
                            break;
                    }

                    incorrect = new string[arrWrong.Length];
                    dataTable = LoadExcel(fileName);

                    //오답20개를 오답 배열에 담음
                    for (int i = 0; i < arrWrong.Length; i++)
                    {
                        incorrect[i] = dataTable.Rows[arrWrong[i]][2].ToString();
                    }

                    //quiz.aspx에서와 같은 방식
                    for (int i = 0; i < 5; i++)
                    {
                        labels[i].Text = quizzes[i].word;
                        radioList[i].Items.Add(quizzes[i].meaning);

                        for (int j = 0; j < 4; j++)
                        {
                            if (j == 0)
                            {
                                radioList[i].Items[0].Value = "o";
                                radioList[i].Items[0].Text = quizzes[i].meaning.ToString();
                            }
                            else //j=1,2,3
                            {
                                radioList[i].Items.Add(incorrect[i * 4 + j]);
                                radioList[i].Items[j].Value = "x";
                                radioList[i].Items[j].Text = incorrect[i * 4 + j];
                            }

                        }

                        //리스트아이템의 순서를 바꾸는 작업
                        //임시리스트를 생성후 기존리스트 값을 옮김
                        List<ListItem> list = new List<ListItem>();
                        foreach (ListItem listItem in radioList[i].Items)
                            list.Add(listItem);

                        //오름차순으로 정렬할 리스트를 만들어서 임시리스트의 값을 복사 후 원래 리스트값을 클리어
                        List<ListItem> sortedList = list.OrderBy(b => b.Text).ToList();
                        radioList[i].Items.Clear();

                        //정렬된 리스트를 복사
                        foreach (ListItem sortedListItem in sortedList)
                            radioList[i].Items.Add(sortedListItem);

                    }
                }
                else
                {
                    Wizard1.Visible = false;
                }
            }



        }



    }

    //db에서 가져온 문제들을 세팅하기 위해
    public List<quiz> setQuiz()
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDBConnectionString"].ConnectionString);
        //importance행을 기준으로 내림차순 정렬하고 가장 위에 있는 5개 검색, 총 개수가 5개보다 적어도 문제 없음
        string sql = "select top 5 word, meaning from reminder where id=@id order by importance desc";

        SqlCommand cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@id", Session["id"].ToString());
        con.Open();

        SqlDataReader rd = cmd.ExecuteReader();

        List<quiz> quizzes = new List<quiz>();
        
        if (rd == null) { return null; }


        while (rd.Read())
        {
            quizzes.Add(new quiz() { word = rd["word"].ToString(), meaning = rd["meaning"].ToString() });
        }

        rd.Close();
        con.Close();

        return quizzes;
    }

    //엑셀 파일에서 임의의 인덱스값을 가져오기위해 
    public int[] MakeRandomNum(int numOfNeeds, int scaleOfArr)
    {
        int[] arr = new int[scaleOfArr];

        Random random = new Random();

        for(int i=0; i < scaleOfArr; i++)
        {
            arr[i]=random.Next(1, numOfNeeds);
        }
        return arr;
    }




    //protected void Wizard1_ActiveStepChanged(object sender, EventArgs e)
    //{
    //    List<quiz> wrong = new List<quiz>();

    //    //endStep이면 점수보여주고 틀린 문제 저장
    //    if (Wizard1.ActiveStep == WizardStep7)
    //    {
    //        labels = new Label[] { Label1, Label2, Label3, Label4, Label5};
    //        radioList = new RadioButtonList[] { RadioButtonList1, RadioButtonList2, RadioButtonList3, RadioButtonList4, RadioButtonList5 };

    //        int Crt=0;    //정답 카운트
    //        int inCrt=0;  //오답 카운트

    //        List<quiz> goToDB = new List<quiz>();

    //        //답을 검사
    //        for (int i = 0; i < 5; i++)
    //        {
    //            for (int j = 0; j < 4; j++)
    //            {

    //                if (radioList[i].SelectedValue == "x" && radioList[i].Items[j].Value == "o")
    //                {
    //                    goToDB.Add(new quiz() { word = labels[i].Text, meaning = radioList[i].Items[j].Text });
    //                    inCrt++;

    //                }
    //            }
    //        }

    //        Crt = 5 - inCrt;

    //        Response.Write("crt : " + Crt + ". inCrt : " + inCrt);

    //        for (int i = 0; i < goToDB.Count; i++)
    //        {
    //            Response.Write(goToDB[i].word + ",");
    //        }




    //    }

    //}


    //엑셀 가져오는 메소드
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

        oleCon.Close();

        //엑셀 데이터가 로드된 데이터 테이블 반환
        return dataTable;
    }



    protected void Wizard1_FinishButtonClick(object sender, WizardNavigationEventArgs e)
    {
        labels = new Label[] { Label1, Label2, Label3, Label4, Label5};
        radioList = new RadioButtonList[] { RadioButtonList1, RadioButtonList2, RadioButtonList3, RadioButtonList4, RadioButtonList5 };

        int Crt=0;    //정답 카운트
        int inCrt=0;  //오답 카운트

        List<quiz> inCrrts = new List<quiz>();

        //답을 검사
        for (int i = 0; i < 5; i++)
        {
            for (int j = 0; j < 4; j++)
            {

                if (radioList[i].SelectedValue == "x" && radioList[i].Items[j].Value == "o")
                {
                    inCrrts.Add(new quiz() { word = labels[i].Text, meaning = radioList[i].Items[j].Text });
                    inCrt++;

                }
            }
        }
        Crt = 5 - inCrt;

        lblScore.Text = Crt * 20 + "점입니다.";

        updateInCrr(inCrrts);
    }


    //틀린문제를 db에 저장
    public void updateInCrr(List<quiz> inCrr)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDBConnectionString"].ConnectionString);
        con.Open();

        SqlCommand cmd;

        //틀린단어가 이미 디비에 저장되어 있는지
        string sql = "update reminder set importance=importance+1 where word=@word";

        for(int i=0; i < inCrr.Count; i++)
        {

            cmd = new SqlCommand(sql, con);

            //단어를 이용하여 검색
            cmd.Parameters.AddWithValue("@word", inCrr[i].word);
            cmd.ExecuteNonQuery();

        }

        con.Close();
    }


</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div runat="server" >
            <asp:Label ID="Label6" runat="server" Text=""></asp:Label>
            <asp:Wizard ID="Wizard1" runat="server"  ActiveStepIndex="0" OnFinishButtonClick="Wizard1_FinishButtonClick"
                Width="100%"                      
                >
                <WizardSteps>
                    <asp:WizardStep ID="WizardStep1" runat="server" Title="시작하기" StepType="Start">

                    </asp:WizardStep>
                    
                    <asp:WizardStep ID="WizardStep2" runat="server" Title="Step 1">
                        <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList1" runat="server"></asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="WizardStep3" runat="server" Title="Step 2">
                        <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList2" runat="server"></asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="WizardStep4" runat="server" Title="Step 3">
                        <asp:Label ID="Label3" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList3" runat="server"></asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="WizardStep5" runat="server" Title="Step 4">
                        <asp:Label ID="Label4" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList4" runat="server"></asp:RadioButtonList>
                    </asp:WizardStep>

                     <asp:WizardStep ID="WizardStep6" runat="server" Title="Step 5">
                         <asp:Label ID="Label5" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList5" runat="server"></asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="WizardStep7" runat="server" Title="finish" StepType="Finish">
                        
                    </asp:WizardStep>

                    <asp:WizardStep ID="WizardStep8" runat="server" Title="complete" StepType="Complete">
                        <asp:Label ID="lblScore" runat="server" Text=""></asp:Label>
                    </asp:WizardStep>

                </WizardSteps>
            </asp:Wizard>

        </div>
    </form>
</body>
</html>
