/*
 * Macro to open images from saphyr directories as Hyperstacks.
 */
BlueMinMax=newArray(500,1400);
GreenMinMax=newArray(200,600);
RedMinMax=newArray(200,350);

#@ File (label = "Input directory", style = "directory") input
//#@ File (label = "Output directory", style = "directory") output
//#@ String (label = "File suffix", value = ".tif", persist=false) suffix
#@ Integer (label = "Number of Channels", value=3, persist=false) Channels
#@ Integer (label = "Starting Image:", value=1, persist=false) startingImage
#@ Integer (label = "Number of FOV to display:", value=137 , persist=false) NumFOV
suffix=".tif"
Slices=1;
NumImages=NumFOV*Channels*Slices;
// See also Process_Folder.py for a version of this code
// in the Python scripting language.

processFolder(input);


// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Channels_sort_list(list,Channels);
  	path = input+File.separator+"Sorted_filelist.txt";
  	f = File.open(path);
  	if(startingImage<=0) startingImage=1;
  	if(startingImage>=list.length) startingImage=list.length;
  	if(NumImages>=list.length) NumImages=list.length;
  	if(NumImages+(startingImage-1)*Channels>=list.length) NumImages=list.length-(startingImage-1)*Channels;
  	
    for (j=0; j<NumImages; j++){
          print(f, input+File.separator+list[j+(startingImage-1)*Channels]);
  	}
	File.close(f);
	run("Stack From List...", "open=["+path+"] use");
	Frames=nSlices/(Channels*Slices);
	run("Stack to Hyperstack...", "order=xyczt(default) channels=Channels slices=Slices frames=Frames display=Composite");

	if(Channels==2){
		recolorChannel(1,"Blue",BlueMinMax);
		recolorChannel(2,"Green",GreenMinMax);
	}
	else if(Channels==3){
		recolorChannel(1,"Blue",BlueMinMax);
		recolorChannel(2,"Green",GreenMinMax);
		recolorChannel(3,"Red",RedMinMax);
	}
	rename(File.getName(input));
	
}

function Channels_sort_list(list,Channels){
	if (Channels==2){
		tmpCH1=newArray(0);
		tmpCH2=newArray(0);
		for(i=0;i<list.length;i++){
			if(matches(list[i],".*B.*CH1_C.*")){
			tmpCH1=Array.concat(tmpCH1,list[i]);
			}
			else if(matches(list[i],".*B.*CH2_C.*")){
			tmpCH2=Array.concat(tmpCH2,list[i]);
			}
			
		}
		tmpCH1=Array.sort(tmpCH1);
		tmpCH2=Array.sort(tmpCH2);
		
		sorted_list=newArray(tmpCH1.length+tmpCH2.length);
		print(sorted_list.length);
		i=0;
		for(j=0;j<sorted_list.length;j+=Channels){
			sorted_list[j]=tmpCH1[i];
			sorted_list[j+1]=tmpCH2[i];
			i++;
			}
		}
	else if (Channels==3){
		tmpCH1=newArray(0);
		tmpCH2=newArray(0);
		tmpCH3=newArray(0);
		for(i=0;i<list.length;i++){
			if(matches(list[i],".*B.*CH1_C.*")){
			tmpCH1=Array.concat(tmpCH1,list[i]);
			}
			else if(matches(list[i],".*B.*CH2_C.*")){
			tmpCH2=Array.concat(tmpCH2,list[i]);
			}
			else if(matches(list[i],".*B.*CH3_C.*")){
			tmpCH3=Array.concat(tmpCH3,list[i]);
			}
		}
		tmpCH1=Array.sort(tmpCH1);
		tmpCH2=Array.sort(tmpCH2);
		tmpCH3=Array.sort(tmpCH3);
		
		sorted_list=newArray(tmpCH1.length+tmpCH2.length+tmpCH3.length);
		print(sorted_list.length);
		i=0;
		for(j=0;j<sorted_list.length;j+=Channels){
			sorted_list[j]=tmpCH1[i];
			sorted_list[j+1]=tmpCH2[i];
			sorted_list[j+2]=tmpCH3[i];
			i++;
			}
		}
	return sorted_list;
}
function recolorChannel(channel, lut,MinMax) {
	Stack.setChannel(channel);
	//run("Enhance Contrast", "saturated=0.03");
	
	run(lut); // Entry in Image>Lookup Tables
	setMinAndMax(MinMax[0],MinMax[1]);
}

