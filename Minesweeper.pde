import de.bezier.guido.*;

public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_MINES = 20;

//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    mines = new ArrayList<MSButton>();
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
            buttons[i][j] = new MSButton(i, j);
        }
    }
    setMines();
}
public void setMines()
{
    while (mines.size() < NUM_MINES) {
        int row = (int)(Math.random() * NUM_ROWS);
        int col = (int)(Math.random() * NUM_COLS);
        if (!mines.contains(buttons[row][col])) {
            mines.add(buttons[row][col]);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon()true) {
        displayWinningMessage();
    }
}
public boolean isWon()
{
    for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
            if (!buttons[i][j].isClicked() && !mines.contains(buttons[i][j]))
                return false;
        }
    }
    return true;
}
public void displayLosingMessage()
{
    for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
            if (!buttons[i][j].isClicked() && mines.contains(buttons[i][j])) {
                buttons[i][j].marked = false;
                buttons[i][j].clicked = true;
            }
        }
    }
    String[] msg = {"L", "o", "s", "e", "r"};
    for (int i = 0; i < msg.length; i++) {
        buttons[0][i].setLabel(msg[i]);
    }
}
public void displayWinningMessage()
{
    String[] msg = {"W", "i", "n", "n", "e", "r"};
    for (int i = 0; i < msg.length; i++) {
        buttons[0][i].setLabel(msg[i]);
    }
}
public class MSButton {
    private int r, c;
    private float x, y, width, height;
    private boolean clicked, marked;
    private String label;

    public MSButton(int rr, int cc) {
        width = 400 / NUM_COLS;
        height = 400 / NUM_ROWS;
        r = rr;
        c = cc;
        x = c * width;
        y = r * height;
        label = "";
        marked = clicked = false;
        Interactive.add(this);
    }

    public boolean isMarked() { return marked; }
    public boolean isClicked() { return clicked; }

    public void mousePressed() {
        if (mouseButton == RIGHT) {
            marked = !marked;
            return;
        }
        if (mouseButton == LEFT && !marked) {
            clicked = true;
            if (mines.contains(this)) {
                displayLosingMessage();
            } else if (countMines(r, c) > 0) {
                label = "" + countMines(r, c);
            } else {
                // flood fill - reveal all 8 neighbors
                int[][] dirs = {{0,-1},{0,1},{-1,0},{1,0},{-1,-1},{1,1},{-1,1},{1,-1}};
                for (int[] d : dirs)
                    if (isValid(r + d[0], c + d[1]) && !buttons[r + d[0]][c + d[1]].isClicked())
                        buttons[r + d[0]][c + d[1]].mousePressed();
            }
        }
    }

    public void draw() {
        if (marked)
            fill(0);
        else if (clicked && mines.contains(this))
            fill(255, 0, 0);
        else if (clicked)
            fill(200);
        else
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(label, x + width / 2, y + height / 2);
    }

    public void setLabel(String newLabel) { label = newLabel; }

    public boolean isValid(int r, int c) {
        return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
    }

    public int countMines(int row, int col) {
        int numMines = 0;
        int[][] dirs = {{1,0},{-1,0},{0,-1},{0,1},{-1,-1},{1,-1},{1,1},{-1,1}};
        for (int[] d : dirs)
            if (isValid(row + d[0], col + d[1]) && mines.contains(buttons[row + d[0]][col + d[1]]))
                numMines++;
        return numMines;
    }
}
