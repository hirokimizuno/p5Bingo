static final boolean DEBUG = true;

class Bingo
{
  Bingo(String filename)
  {
    m_max       = 75;
    m_checkList = new boolean [m_max];
    for (int i = 0; i < m_max; i++) {
      m_checkList[i] = false;
    }
    m_extList   = new ArrayList<Integer>(m_max);

    // Restore from Backup File
    if ( !DEBUG )
    {
      Load(filename);
      m_output = createWriter(filename);
      for (int i = 0; i < m_extList.size(); i++) {
        m_output.println(m_extList.get(i));
      }
      m_output.flush();
    }
  }

  void Load(String filename)
  {
    String[] lines = loadStrings(filename);

    if (lines == null ) {
      return;
    }

    for (int i = 0; i < lines.length; i++) {
      int number = parseInt(lines[i].replaceAll("[^0-9]", ""));
      if (number > 0 && number <= m_max) {
        m_extList.add(number);
        m_checkList[number-1] = true;
      }
    }
  }

  int AddNewNumber()
  {
    if (m_extList.size() >= m_max)
    {
      return -1;
    }

    int newNumber = -1;
    while (true)
    {
      newNumber = int(random(1, m_max) + 0.5);

      if ( m_checkList[newNumber-1] )
      {
        newNumber = -1;
        continue;
      }

      m_checkList[newNumber-1] = true;
      m_extList.add(newNumber);
      break;
    }

    // Write to Backup File
    if ( !DEBUG )
    {
      m_output.println(newNumber);
      m_output.flush();
    }

    return newNumber;
  }

  int GetCurrentNumber()
  {
    return m_extList.get(m_extList.size()-1);
  }

  int GetCount()
  {
    return m_extList.size();
  }

  int GetNumber(int i)
  {
    return m_extList.get(i);
  }

  int                m_max;
  boolean[]          m_checkList;
  ArrayList<Integer> m_extList;

  PrintWriter        m_output;
};


class MainView
{
  MainView(Bingo bingo, PFont f)
  {
    m_bingo = bingo;
    m_font  = f;
    m_mode  = 1;

    m_width  = width;
    m_height = height - int((height * 0.1));
    m_xpos   = int((m_width  * 0.5));
    m_ypos   = int((m_height * 0.5));
  }

  void DrawNumber(Integer number)
  {
    textFont(m_font);
    textAlign(CENTER, CENTER);
    textSize(m_height);
    String str = number.toString();

    fill(255);
    text(str, m_xpos, m_ypos);
  }

  void Draw()
  {
    if ( m_mode == 0 )
    {
      return;
    }

    if ( m_mode == 1 )
    {
      DrawNumber(int(random(0, 75)));
    }

    if ( m_mode == 2 )
    {
      DrawNumber(bingo.GetCurrentNumber());
    }
  }

  void SetMode(int mode)
  {
    if ( mode < 0 ) return;    
    if ( mode > 2 ) return;

    m_mode = mode;
  }

  int GetMode()
  {
    return m_mode;
  }

  int m_mode;

  int m_width;
  int m_height;
  int m_xpos;
  int m_ypos;

  PFont m_font;
  Bingo m_bingo;
};

class ListView
{
  ListView(Bingo bingo, PFont f)
  {
    m_font  = f;
    m_bingo = bingo;

    m_width  = width;
    m_height = height;

    m_textSize    = int(m_height * 0.1);
    m_numberWidth = int(m_textSize * 1.5);
  }

  void DrawNumber(Integer number, int i, int size)
  {
    textFont(m_font);
    textAlign(CENTER, CENTER);
    textSize(m_textSize);
    String str = number.toString();
    fill(255);
    
    int offset = int(m_numberWidth * 0.5);
    if( size * m_numberWidth > m_width )
    {
      offset = (m_width + int(m_numberWidth * 0.5)) - (size * m_numberWidth);
    }

    text(str, (offset + i * (m_numberWidth)), (m_height - (m_textSize * 0.6)));
  }

  void Draw()
  {
    stroke(255);
    line(0, (m_height - int(m_textSize * 1.2)), m_width, (m_height - int(m_textSize * 1.2)));
    
    for (int i = 0; i < m_bingo.GetCount(); i++) {
      DrawNumber(m_bingo.GetNumber(i), i, m_bingo.GetCount());
    }
  }  

  int m_width;
  int m_height;

  int m_textSize;
  int m_numberWidth;

  PFont m_font;
  Bingo m_bingo;
};



///////////////////////////////////////////////////////////////////////////////////

Bingo    bingo;
MainView mview;
ListView lview;

void setup()
{
  //size(displayWidth, displayHeight); 
  size(800, 600);
  background(0);
  frameRate(60);

  PFont f = createFont("Helvetica-Bold", 120);

  bingo = new Bingo("data.log");

  mview = new MainView(bingo, f);
  lview = new ListView(bingo, f);
}

void keyPressed()
{
  if ( key == ENTER )
  {
    int mode = mview.GetMode();
    if ( mode != 1 )
    {
      mview.SetMode(1);
      return;
    }
    else
    {
      bingo.AddNewNumber();
      mview.SetMode(2);
      return;
    }
  }
}

void draw()
{
  background(0);

  mview.Draw();
  lview.Draw();
}

