
class Bingo
{
  Bingo()
  {
    m_checkList = new boolean [76];
    m_extList   = new ArrayList<Integer>(75);
  }

  int AddNewNumber()
  {
    int ri = -1;
    while (true)
    {
      float rf = random(0, 75);
      ri = int(rf);

      if ( m_checkList[ri] )
      {
        ri = -1;
        continue;
      }

      m_checkList[ri] = true;
      m_extList.add(ri);
      break;
    }

    return ri;
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

  boolean[]          m_checkList;
  ArrayList<Integer> m_extList;
};


class MainView
{
  MainView(Bingo bingo, PFont f)
  {
    m_bingo = bingo;
    m_font  = f;
    m_mode  = 1;
    
    m_width  = width;
    m_height = height;
    m_xpos   = m_width  / 2;
    m_ypos   = (m_height / 2) - 130;
  }
  
  void DrawNumber(Integer number)
  {
    textFont(m_font);
    textAlign(CENTER, CENTER);
    textSize(m_height / 1.5);
    String str = number.toString();
    
    fill(255);
    text(str, m_xpos, m_ypos);
  }

  void Draw()
  {
    if( m_mode == 0 )
    {
      return;
    }
    
    if( m_mode == 1 )
    {
      DrawNumber(int(random(0, 75)));
    }
    
    if( m_mode == 2 )
    {
      DrawNumber(bingo.GetCurrentNumber());
    }
  }
  
  void SetMode(int mode)
  {
    if( mode < 0 ) return;    
    if( mode > 2 ) return;
    
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
    
    m_texSize = 80;
  }

  void DrawNumber(Integer number, int i, int size)
  {
    textFont(m_font);
    textAlign(CENTER, CENTER);
    textSize(m_texSize);
    String str = number.toString();
    fill(255);
    
    int offset = 80;
    
    if( size > (m_width / 100) )
    {
      offset -= ((size - (m_width / 100)) * 100);
    }
    
    text(str, (offset + i * 100), m_height - 100);
  }
  
  void Draw()
  {
    for(int i = 0; i < m_bingo.GetCount(); i++){
      DrawNumber(m_bingo.GetNumber(i), i, m_bingo.GetCount());
    }
  }  
  
  int m_width;
  int m_height;
  
  int m_texSize;
  PFont m_font;
  Bingo m_bingo;
};



///////////////////////////////////////////////////////////////////////////////////

Bingo    bingo;
MainView mview;
ListView lview;

void setup()
{
  size(displayWidth, displayHeight); 
  //size(800, 600); 
  background(0);
  frameRate(60);
  
  PFont f = createFont("Impact", 120);

  bingo = new Bingo();

  mview = new MainView(bingo, f);
  lview = new ListView(bingo, f);
}

void keyPressed()
{
  if( key == ENTER )
  {
    int mode = mview.GetMode();
    if( mode != 1 )
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

