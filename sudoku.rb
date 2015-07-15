

@test = 0
def bruteForce(cnt, table)
    #while(table[cnt] && table[cnt]!="" && cnt!=81) #lets try to not have a recursive depth of 81
    # cnt =cnt+1
    #end
  if(cnt == 81)
    return true
  end
  @test+=1
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
def randomRemove(table)
  time1 = Time.now.to_i
  remove = Array(81);
  for i in 0..80
    remove[i] = i
  end
  remove = remove.shuffle
  puts remove.inspect
  for i in 0..80

      val = remove.pop
    tmp = table[val]
    table[val] = ''
    @numberSolutions = 0
    countSolutions(0,table)
    if @numberSolutions > 1
      table[val] = tmp
    end
    puts "#{i} #{@numberSolutions}"

      if time = Time.now.to_i - time1 > 200
        return
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
      return true;
    end
	if(cnt == 81)
		@numberSolutions= @numberSolutions +1
		return
	end
	for val in 1..9
		if legal(cnt, val, table) == true
			table[cnt] = val;
			sols = countSolutions(cnt+1, table);
		end
	end
	table[cnt] = ''; 
	return;
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
  row = ele % 9;
  col = (ele / 9).floor;
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
@table = Array.new(81)
bruteForce(0, @table)
puts(@table.inspect);
randomRemove(@table)
test = @table.inspect
puts test.gsub('"','\'');
puts @numberSolutions