class SudokusController < ApplicationController
  # GET /sudokus
  # GET /sudokus.json
  def index
    @sudokus = Sudoku.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sudokus }
    end
  end

  # GET /sudokus/1
  # GET /sudokus/1.json
  def show
    @sudoku = Sudoku.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sudoku }
    end
  end

  # GET /sudokus/new
  # GET /sudokus/new.json
  def new
    @sudoku = Sudoku.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sudoku }
    end
  end

  # GET /sudokus/1/edit
  def edit
    @sudoku = Sudoku.find(params[:id])
  end

  # POST /sudokus
  # POST /sudokus.json
  def create

    @sudoku = Sudoku.new(params[:sudoku])

    respond_to do |format|
      if @sudoku.save
        createNewSudoku()
        format.html { redirect_to @sudoku, notice: 'Sudoku was successfully created.'}
        format.json { render json: @sudoku, status: :created, location: @sudoku }
      else
        format.html { render action: "new"}
        format.json { render json: @sudoku.errors, status: :unprocessable_entity }
      end
    end
  end

  def createNewSudoku()
    @table = Array.new(81)
    bruteForce(0, @table)
    removed = randomRemove(@table)
    if removed > 30
      diff = "Easy"
    elsif removed > 25
      diff = "Medium"
    else
      diff = "Hard"
    end
    test = @table.inspect
    test = test.gsub('"','\'')
    @sudoku.update_attributes(:puzzle => test)
    @sudoku.update_attributes(:difficulty => diff)
  end
  def randomRemove(table)
    time1 = Time.now.to_i
    remove = Array(81);
    for i in 0..80
      remove[i] = i
    end
    remove = remove.shuffle
    removed = 0;
    for i in 0..80
      val = remove.pop
      tmp = table[val]
      table[val] = nil
      @numberSolutions = 0
      countSolutions(0,table)
      if @numberSolutions > 1
        table[val] = tmp
      else
        removed = removed + 1
      end
      if (Time.now.to_i - time1) > 4
        return 81-removed
      end
    end
    #Pseduocode
    #Randomly remove one non empty element
    #create stack 0-80 and shuffle. Pop off top to remove.
    #Count number of solutions. If < 1 then put element back on and pick the next
  end
  @numberSolutions = 0
  def countSolutions(cnt, table)
    while(table[cnt] && table[cnt]!="" && cnt!=81) #lets try to not have a recursive depth of 81
      cnt =cnt+1
    end
    if(@numberSolutions > 1)
      return;
    end
    if(cnt == 81)
      @numberSolutions= @numberSolutions +1
      return
    end
    for val in 1..9
      if legal(cnt, val, table) == true
        table[cnt] = val;
        countSolutions(cnt+1, table);
      end
    end
    table[cnt] = '';
    return;
  end
  def bruteForce(cnt, table)
    #while(table[cnt] && table[cnt]!="" && cnt!=81) #lets try to not have a recursive depth of 81
    #  cnt =cnt+1
   # end
    if(cnt == 81)
      return true
    end
    a = [1,2,3,4,5,6,7,8,9]
    a = a.shuffle
    a.each do |val|#alter, instead of 1-9, do 1-9 randomly
      if legal(cnt, val, table) == true
        table[cnt] = val
        if bruteForce(cnt+1, table) == true
          return true
        end
      end
    end
    table[cnt] = ''
    return false

  end
  def legal(ele, val, table)
    r = getRow(ele, table)
    c = getCol(ele, table)
    b = getBox(ele, table)
    for bc in 0..8
      if r[bc] == val || c[bc] == val || b[bc] == val
        return false
      end
    end
    return true

  end
  def getRow(ele, table)
    r = Array(9)
    row = ele % 9
    for i in 0..8
      r[i] = table[row]
      row+=9
    end
    return r
  end
  def getCol(ele, table)
    r = Array(9)
    col = (ele / 9).floor * 9
    for i in 0..8
      r[i] = table[col]
      col = col + 1
    end
    return r
  end
  def getBox(ele, table)
    r = Array(9)
    row = ele % 9
    col = (ele / 9).floor
    start = ele - (col %3)*9 - row%3;
    for i in 0..8
      r[i] = table[start]
      if(start % 3 == 2)
          start -= 3
          start += 9
      end
      start = start+1
    end

    return r
  end
  # PUT /sudokus/1
  # PUT /sudokus/1.json
  def update
    @sudoku = Sudoku.find(params[:id])

    respond_to do |format|
      if @sudoku.update_attributes(params[:sudoku])
        format.html { redirect_to @sudoku, notice: 'Sudoku was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sudoku.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sudokus/1
  # DELETE /sudokus/1.json
  def destroy
    @sudoku = Sudoku.find(params[:id])
    @sudoku.destroy

    respond_to do |format|
      format.html { redirect_to sudokus_url }
      format.json { head :no_content }
    end
  end
end
