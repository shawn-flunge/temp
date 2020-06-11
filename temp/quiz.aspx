<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<!DOCTYPE html>

<script runat="server">

    static class typeOfquiz
    {
        public const int numOfToeic = 1495;
        public const int numOfEngBasic = 3000;
        public const int numOfGerBasic = 3134;

        public const string Toeic = "toeic.xls";
        public const string EngBasic = "english_basic.xls";
        public const string GerBasic = "german_basic.xls";
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
            Init();

            //퀴즈를 라벨과 라디오버튼에 배치하는 작업
            for (int i = 0; i < 10; i++)
            {
                labels[i].Text = quizzes[i].word.ToString();
                radioList[i].Items.Add(quizzes[i].meaning.ToString());
                for(int j = 0; j < 4; j++)
                {
                    if (i == 0 && j == 0)
                        radioList[i].Items.Add(incorrect[new Random().Next(0, 39)]);
                    else
                        radioList[i].Items.Add(incorrect[i*4+j]);
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

                Response.Write(quizzes[i].word+"\t" + quizzes[i]+"\n");
            }
        }




    }



    public void Init()
    {
        labels = new Label[] { Label1, Label2, Label3, Label4, Label5, Label6, Label7, Label8, Label9, Label10 };
        radioList = new RadioButtonList[] { RadioButtonList1, RadioButtonList2, RadioButtonList3, RadioButtonList4, RadioButtonList5, RadioButtonList6, RadioButtonList7, RadioButtonList8, RadioButtonList9, RadioButtonList10 };


        dataTable = new DataTable();
        quizzes = new List<quiz>();

        //파일 설정
        fileName = "C:\\works/" + typeOfquiz.Toeic;


        arrCorrect =MakeRandomNum(typeOfquiz.numOfToeic,10);

        arrWrong = MakeRandomNum(typeOfquiz.numOfToeic,40);


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

        if (Wizard1.ActiveStep == endStep)
        {

            for (int i = 0; i < 10; i++)
            {
                //if (!quizzes[i].meaning.ToString().Contains(radioList[i].SelectedValue.ToString()))
                //{
                //    wrong.Add(quizzes[i]);

                //}
                TextBox1.Text += labels[i].Text + "\n";
                
            }

        }

    }


    protected void Wizard1_FinishButtonClick(object sender, WizardNavigationEventArgs e)
    {



        //for (int i = 0; i < 10; i++)
        //{
        //    //if (!quizzes[i].word.ToString().Equals(radioList[i].SelectedValue.ToString()))
        //    //{
        //    //    //wrong.Add(quizzes[i]);

        //    //}
        //    Label12.Text += quizzes[i].word.ToString() + "\t ,\t " + quizzes[i].meaning.ToString() + "\t ,\t " + radioList[i].SelectedValue + "\n";
        //}

        Response.Write(quizzes[0].word);

    }

    public void abc()
    {

        //Label12.Text = quizzes.Count.ToString();
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

        oleCon.Close();

        //엑셀 데이터가 로드된 데이터 테이블 반환
        return dataTable;
    }

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








</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div >
            
            <asp:Button ID="Button1" runat="server" Text="Button"/>

            <asp:Wizard ID="Wizard1" runat="server" OnFinishButtonClick="Wizard1_FinishButtonClick" OnActiveStepChanged="Wizard1_ActiveStepChanged" C ActiveStepIndex="8">
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



                    <asp:WizardStep ID="endStep"  runat="server" StepType="Step" Title="finis">
                        <asp:Label ID="Label11" runat="server" Text="Label"></asp:Label>
                        <asp:TextBox ID="TextBox1" runat="server" TextMode="MultiLine"></asp:TextBox>

                    </asp:WizardStep>

                    <asp:WizardStep ID="WizardStep1"  runat="server" StepType="Complete" Title="complete">
                        <asp:Label ID="Label12" runat="server" Text=""></asp:Label>

                    </asp:WizardStep>
                </WizardSteps>
            </asp:Wizard>


        </div>
    </form>
</body>
</html>
