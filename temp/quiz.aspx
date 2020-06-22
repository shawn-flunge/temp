<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    static class typeOfquiz
    {
        public const int numOfEngToeic = 1480;
        public const int numOfEngBasic = 3000;

        public const string EngToeic = "english_toeic.xls";
        public const string EngBasic = "english_basic.xls";

    }


    //퀴즈 구조체
    public struct quiz
    {
        public string word { get; set; }
        public string meaning { get; set; }
    }

    //라벨과 라디오버튼리스트 컨트롤하기 쉽게
    Label[] labels;
    RadioButtonList[] radioList;

    //엑셀파일 뭐불러 올건지
    string fileName;

    //퀴즈를 담을 리스트
    public List<quiz> quizzes;

    //오늘 외울 단어의 인덱스
    int[] arrCorrect;
    //퀴즈에 사용될 오답의 인덱스
    int[] arrWrong;
    //오답이 담길 문자열 배열
    string[] incorrect;
    //가져온 파일을 담은 데이터테이블
    DataTable dataTable;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            //각종 컨트롤 및 변수 초기화
            Init();

            //퀴즈를 라벨과 라디오버튼에 배치하는 작업
            for (int i = 0; i < 10; i++)
            {
                labels[i].Text = quizzes[i].word.ToString();

                radioList[i].Items.Add(quizzes[i].meaning.ToString());
                for(int j = 0; j < 4; j++)
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
    }

    //컨트롤 및 변수 초기화
    public void Init()
    {
        labels = new Label[] { Label1, Label2, Label3, Label4, Label5, Label6, Label7, Label8, Label9, Label10 };
        radioList = new RadioButtonList[] { RadioButtonList1, RadioButtonList2, RadioButtonList3, RadioButtonList4, RadioButtonList5, RadioButtonList6, RadioButtonList7, RadioButtonList8, RadioButtonList9, RadioButtonList10 };


        dataTable = new DataTable();
        quizzes = new List<quiz>();

        //파일 설정, 메인 페이지에서 버튼으로 정의한 세션을 가지고
        fileName = "C:\\works/" + typeOfquiz.EngToeic;
        arrCorrect = MakeRandomNum(typeOfquiz.numOfEngToeic, 10);
        arrWrong = MakeRandomNum(typeOfquiz.numOfEngToeic, 40);

        //switch (Session["type"].ToString())
        //{
        //    case "engBasic":
        //        fileName = "C:\\works/" + typeOfquiz.EngBasic;

        //        arrCorrect = MakeRandomNum(typeOfquiz.numOfEngBasic, 10);
        //        arrWrong = MakeRandomNum(typeOfquiz.numOfEngBasic, 40);
        //        break;
        //    case "engToeic":
        //        fileName = "C:\\works/" + typeOfquiz.EngToeic;
        //        arrCorrect = MakeRandomNum(typeOfquiz.numOfEngToeic, 10);
        //        arrWrong = MakeRandomNum(typeOfquiz.numOfEngToeic, 40);
        //        break;
        //    default:
        //        fileName = "C:\\works/" + typeOfquiz.EngBasic;
        //        arrCorrect = MakeRandomNum(typeOfquiz.numOfEngBasic, 10);
        //        arrWrong = MakeRandomNum(typeOfquiz.numOfEngBasic, 40);
        //        break;

        //}
        


        incorrect = new string[arrWrong.Length];

        dataTable = LoadExcel(fileName);

        //단어 리스트에 정답인덱스에 해당하는 단어를 엑셀파일에서 가져옴
        for (int i = 0; i < arrCorrect.Length; i++)
        {
            quizzes.Add(new quiz() { word = dataTable.Rows[arrCorrect[i]][1].ToString(), meaning = dataTable.Rows[arrCorrect[i]][2].ToString() });

        }

        //오답40개를 오답 배열에 담음
        for(int i = 0; i < arrWrong.Length; i++)
        {
            incorrect[i] = dataTable.Rows[arrWrong[i]][2].ToString();
        }

    }

    protected void Wizard1_ActiveStepChanged(object sender, EventArgs e)
    {

        List<quiz> wrong = new List<quiz>();

        //endStep이면 점수보여주고 틀린 문제 저장
        if (Wizard1.ActiveStep == endStep)
        {
            labels = new Label[] { Label1, Label2, Label3, Label4, Label5, Label6, Label7, Label8, Label9, Label10 };
            radioList = new RadioButtonList[] { RadioButtonList1, RadioButtonList2, RadioButtonList3, RadioButtonList4, RadioButtonList5, RadioButtonList6, RadioButtonList7, RadioButtonList8, RadioButtonList9, RadioButtonList10 };

            int Crt=0;    //정답 카운트
            int inCrt=0;  //오답 카운트

            List<quiz> goToDB = new List<quiz>();

            //답을 검사
            for (int i = 0; i < 10; i++)
            {
                for (int j = 0; j < 4; j++)
                {

                    if (radioList[i].SelectedValue == "x" && radioList[i].Items[j].Value == "o")
                    {
                        goToDB.Add(new quiz() { word = labels[i].Text, meaning = radioList[i].Items[j].Text });
                        inCrt++;

                    }
                }
            }

            Crt = 10 - inCrt;

            Response.Write("crt : " + Crt + ". inCrt : " + inCrt);

            for (int i = 0; i < goToDB.Count; i++)
            {
                Response.Write(goToDB[i].word + ",");
            }




        }


    }


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


    protected void Wizard1_FinishButtonClick(object sender, WizardNavigationEventArgs e)
    {
        labels = new Label[] { Label1, Label2, Label3, Label4, Label5, Label6, Label7, Label8, Label9, Label10 };
        radioList = new RadioButtonList[] { RadioButtonList1, RadioButtonList2, RadioButtonList3, RadioButtonList4, RadioButtonList5, RadioButtonList6, RadioButtonList7, RadioButtonList8, RadioButtonList9, RadioButtonList10 };

        int Crt=0;    //정답 카운트
        int inCrt=0;  //오답 카운트

        List<quiz> inCrrts = new List<quiz>();

        //답을 검사
        for (int i = 0; i < 10; i++)
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
        Crt = 10 - inCrt;

        lblScore.Text = Crt * 10 + "점입니다.";

        //로그인을 안했으면 틀린걸 디비에 저장하지 않아야 하기 때문
        if (Session["id"] != null)
            storeInCrr(inCrrts);

        Session["type"] = null;
    }

    //틀린문제를 db에 저장
    public void storeInCrr(List<quiz> inCrr)
    {
        SqlConnection con = new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=flunge; pwd=dksk1399");
        con.Open();

        //select
        SqlCommand cmd;
        //update, insert
        SqlCommand cmd2;
        SqlDataReader rd;

        //틀린단어가 이미 디비에 저장되어 있는지
        string sql = "select * from MyDB.dbo.reminder where word=@word";
        for(int i=0; i < inCrr.Count; i++)
        {

            cmd = new SqlCommand(sql, con);

            //단어를 이용하여 검색
            cmd.Parameters.AddWithValue("@word", inCrr[i].word);
            rd = cmd.ExecuteReader();

            //이미 있으면 update로 가중치만 +1 해줌, 없으면 insert
            if (rd.Read())
            {
                string sqlUpdate = "update MyDB.dbo.reminder set importance=importance+1 where word=@word";
                cmd2 = new SqlCommand(sqlUpdate, con);
                cmd2.Parameters.AddWithValue("@word", inCrr[i].word);

                rd.Close();
                cmd2.ExecuteNonQuery();
            }
            else
            {
                string sqlInsert = "insert into MyDB.dbo.reminder(word,meaning,id,importance,type)" +
                "values(@word,@meaning,@id,@importance,@type)";

                cmd2 = new SqlCommand(sqlInsert, con);
                cmd2.Parameters.AddWithValue("@word", inCrr[i].word);
                cmd2.Parameters.AddWithValue("@meaning",inCrr[i].meaning);
                cmd2.Parameters.AddWithValue("@id", Session["id"].ToString());
                cmd2.Parameters.AddWithValue("@importance", 0);
                cmd2.Parameters.AddWithValue("@type", Session["type"].ToString());

                rd.Close();
                cmd2.ExecuteNonQuery();
            }
            
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
        <div >
            
       
            <asp:Label ID="Label14" runat="server" Text="Label"></asp:Label>


            <asp:Wizard ID="Wizard1" runat="server" OnActiveStepChanged="Wizard1_ActiveStepChanged"  ActiveStepIndex="0" OnFinishButtonClick="Wizard1_FinishButtonClick"
                Width="100%"                      
                BackColor="Yellow"
                >
                
                <WizardSteps>

                    <asp:WizardStep ID="startStep" runat="server" StepType="Start" Title="시작하기">
                        
                    </asp:WizardStep>

                    <asp:WizardStep ID="question1" runat="server" Title="Step 1"  >

                        <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList1" runat="server" >
                        </asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="question2" runat="server" Title="Step 2">
                        <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList2" runat="server" >
                        </asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="question3"  runat="server" Title="Step 3">
                        <asp:Label ID="Label3" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList3" runat="server" >
                        </asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="question4"  runat="server" Title="Step 4">
                        <asp:Label ID="Label4" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList4" runat="server" >
                        </asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="question5"  runat="server" Title="Step 5">
                        <asp:Label ID="Label5" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList5" runat="server" >
                        </asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="question6"  runat="server" Title="Step 6">
                        <asp:Label ID="Label6" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList6" runat="server" >
                        </asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="question7"  runat="server" Title="Step 7">
                        <asp:Label ID="Label7" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList7" runat="server" >
                        </asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="question8"  runat="server" Title="Step 8">
                        <asp:Label ID="Label8" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList8" runat="server" >
                        </asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="question9"  runat="server" Title="Step 9">
                        <asp:Label ID="Label9" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList9" runat="server" Height="30px" >
                        </asp:RadioButtonList>
                    </asp:WizardStep>

                    <asp:WizardStep ID="question10"  runat="server"  Title="Step 10">
                        <asp:Label ID="Label10" runat="server" Text="Label"></asp:Label>
                        <asp:RadioButtonList ID="RadioButtonList10" runat="server" >
                        </asp:RadioButtonList>
                        
                    </asp:WizardStep>



                    <asp:WizardStep ID="endStep"  runat="server" StepType="Finish" Title="finis">
                        <asp:Label ID="Label11" runat="server" Text="Label"></asp:Label>
                        <asp:TextBox ID="TextBox1" runat="server" TextMode="MultiLine"></asp:TextBox>

                    </asp:WizardStep>

                    <asp:WizardStep ID="WizardStep1"  runat="server" StepType="Complete" Title="complete">
                        <asp:Label ID="lblScore" runat="server" Text="asdfasdfasdfasfdsafa"></asp:Label>
                        
                    </asp:WizardStep>
                </WizardSteps>
            </asp:Wizard>


        </div>
    </form>
</body>
</html>
