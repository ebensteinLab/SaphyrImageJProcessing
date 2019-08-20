extension = ".tif";
  prefix="B";
  Channels=3;
  dir1 = getDirectory("Choose Source Directory ");
  Dialog.create("Channels & Bank number");
  //Dialog.addNumber("Number of FOV to open:", 137);
  Dialog.addNumber("Number of Channels:", 3);
  Dialog.addNumber("Number of Banks in folder:", 1);
  Dialog.addCheckbox("Remove background?", 0);
  Dialog.show();
  
    //FOV = Dialog.getNumber();
  Channels = Dialog.getNumber();
  Bank = Dialog.getNumber();
	RMbackground = Dialog.getCheckbox() ;
run("Image Sequence...", "open=dir1 file=((^B)||(.tif)) sort");   
 /*Dialog.create("Channels & FOV number");
  Dialog.addNumber("Number of FOV to open:", nSlices);
  Dialog.show();
  FOV = Dialog.getNumber();*/
 newframes=floor(nSlices/(Channels*Bank));
run("Stack to Hyperstack...", "order=xyztc channels=Channels slices=Bank frames=newframes display=Composite");
if(RMbackground)
	run("Subtract Background...", "rolling=10");
recolorChannel(1,"Blue");
recolorChannel(2,"Green");
recolorChannel(3,"Red");



function recolorChannel(channel, lut) {
	Stack.setChannel(channel);
	run("Enhance Contrast", "saturated=0.03");
	run(lut); // Entry in Image>Lookup Tables
}