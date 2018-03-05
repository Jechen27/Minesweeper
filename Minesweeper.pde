import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 20;
int NUM_COLS = 20;
int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r=0;r<NUM_ROWS;r++)
    for (int c=0;c<NUM_COLS;c++)
    buttons[r][c] = new MSButton(r,c);
    while (bombs.size()<NUM_BOMBS)
    setBombs();
}
public void setBombs()
{
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (bombs.contains(buttons[r][c])==false)
    bombs.add(buttons[r][c]);
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int count =0;
    for (MSButton b : bombs)
    if (b.isMarked())
    count++;
    return count == NUM_BOMBS;
}
public void displayLosingMessage()
{
    String lose = "YOU LOSE!";
    for (int i=0;i<lose.length();i++)
    buttons[NUM_ROWS/2-1][NUM_COLS/2-lose.length()/2+i].setLabel(lose.substring(i,i+1));
}
public void displayWinningMessage()
{
    String win = "YOU WIN!";
    for (int i=0;i<win.length();i++)
    buttons[NUM_ROWS/2-1][NUM_COLS/2-win.length()/2+i].setLabel(win.substring(i,i+1));
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton==RIGHT)
        {
        marked = !marked;
        if(marked==false)
        clicked=false;
        }
        else if (bombs.contains(this))
        displayLosingMessage();
        else if (countBombs(r,c)>0)
        label = Integer.toString(countBombs(r,c));
        else
        for (int row=-1;row<=1;row++)
        for (int col=-1;col<=1;col++)
        if (isValid(row+r,col+c)&&buttons[row+r][col+c].clicked==false)
        buttons[row+r][col+c].mousePressed();
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        return (r<NUM_ROWS&&c<NUM_COLS)&&(r>=0&&c>=0);
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int r=-1;r<=1;r++)
        for (int c=-1;c<=1;c++)
        if (isValid(row+r,col+c))
        if (bombs.contains(buttons[row+r][col+c]))
        numBombs++;
        return numBombs;
    }
}