var table;
function init(){
	loadSample();
}
function loadSample(){
	var sample = [<%= @sudoku.puzzle %>];
	var i =0;
	$$("table#sudoku input").each(function (ele){
		if(sample[i]){
			ele.value = sample[i];
			ele.readOnly = true;
			ele.setStyle({
				backgroundColor:'#EEEEEE'
			});
		}
		i++;
	});
}
function getRow(ele){
	var r = new Array();
	var row = parseInt(ele.id) % 9;
	for(var i = 0; i<= 8; i++){
		r[i] = table[row];
		row+=9;
	}
	return r;
}

function getBox(ele){
	var r = new Array();
	var row = parseInt(ele.id) % 9;
	var col = ~~(parseInt(ele.id) / 9); //~~ is Rounding
	var start = ele.id - (col %3)*9 - row%3;
	for(var i = 0; i<=8 ; i++, start++){
		r[i] = table[start];
		if(start % 3 == 2){
			start -= 3;
			start += 9;
		}	
	}
	return r;
}

function getCol(ele){
	var r = new Array();
	var col = ~~(parseInt(ele.id) / 9) * 9; //~~ is Rounding
	for(var i = 0; i<= 8; i++){
		r[i] = table[col++];
	}
	return r;
}


function getElement(row,col){
	var r = (col+1)*9+row;
	//if(r < 0 || r > 80)
	//	console.log("Bad getElement request. " + row +":"+col);
	return table[(col)*9+row];
}
function validatePuzzle(){
	alert(validate());
}
function validate(){
	for(var i=10; i<=64 ; i+=27){
		for(var j=i; j<=i+8 ; j+=3){
			if(!bucketTest(getBox(table[j]))){
				return false;
			}
		}
	}
	//Validate rows
	for(var i = 0; i<=8; i++){
		if(!bucketTest(getRow(table[i]))){
			return false;
		}
	}
	//Validate cols
	for(var i = 0; i<=72; i+=9){
		if(!bucketTest(getCol(table[i]))){
			return false;
		}
	}
	return true;
}
function bucketTest(ele){
	var bucket = new Array();
	for(var i = 0; i<=8; i++) bucket[i] = 0;
	for(var i = 0; i<=8; i++){
		if(ele[i].value < 0 || ele[i].value > 9){
			return false;
		}
		bucket[ele[i].value-1]++;
		if(bucket[ele[i].value-1] > 1)
			return false;
	}
	return true;
}
function logicSolve(){
	bruteForce(0);
}
function count(){
	if(!validate()){
		alert(-1);
	}else{
		numberSolutions = 0;
		countSolutions(0);
		alert(numberSolutions);
	}
}
var numberSolutions = 0;
function countSolutions(cnt) {
	while(table[cnt] && table[cnt].value && cnt!=81){//lets try to not have a recursive depth of 81
		cnt++;
	}
	if(cnt == 81){
		numberSolutions++;
		return;
	}
	for (var val = 1; val <= 9; val++) {
		if (legal(table[cnt], val) == true) {
			table[cnt].value = val;
			countSolutions(cnt+1);//recurse
		}
	}
	table[cnt].value = ''; 
	return;
}
function bruteForce(cnt) {
	while(table[cnt] && table[cnt].value && cnt!=81){//lets try to not have a recursive depth of 81
		cnt++;
	}
	if(cnt == 81){
		return true;
	}
	for (var val = 1; val <= 9; val++) {
		if (legal(table[cnt], val) == true) {
			table[cnt].value = val;
			if (bruteForce(cnt+1) == true ){
				return true;
			}
		}
	}
	table[cnt].value = ''; 
	return false;
}
function legal(ele, val) {
	var r = getRow(ele);
	var c = getCol(ele);
	var b = getBox(ele);
	for(var bc = 0; bc< 9; bc++){
		if(r[bc].value == val || c[bc].value == val || b[bc].value == val)
			return false;
	}
	return true; 
}