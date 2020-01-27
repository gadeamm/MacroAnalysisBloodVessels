//macro to measure the green intensity in the blood vessels

//by Gadea Mata Martínez 

//VARIABLES
output="output";

minSize=90;
maxSize="Infinity";
disPixels=150;
knownDis=50;
minSizeGreen=0;
maxSizeGreen="Infinity";

//PROCESS
directory=getDirectory("Choose the folder with the images"); //path to choose the images
files=getFileList(directory);//obtain the files from the folder
//Dialog to set of the scale
Dialog.create("Introduce the scale");
Dialog.addNumber("Distance in pixels:", disPixels);
Dialog.addNumber("Known distance:", knownDis);
Dialog.show();
disPixels = Dialog.getNumber();
knownDis = Dialog.getNumber();;
//create the output folder
outputPath=directory+output;
if(!File.exists(outputPath)){
	File.makeDirectory(outputPath);
}


run("Options...", "iterations=1 count=1 black do=Nothing"); //fix the black color as background in the binary images

setBackgroundColor(0, 0, 0);//black color for background
setTool("freehand");//mark thre freehand option 

for(i=0;i<files.length; i++) //for each file from the folder with the images
{
	if(endsWith(files[i], ".tif")) //check that the file is an image (tif-file)
	{
		//choose the measurements which it is going to analyze
		run("Set Measurements...", "area mean standard display redirect=None decimal=5"); //fix the measures which we want
		
		open(directory+File.separator+files[i]);//open the image
		title=getTitle(); //get title
		print(title); //write the information in the log-file
		
		run("Set Scale...", "distance="+disPixels+" known="+knownDis+" pixel=1.000 unit=micron"); //settings the scale of the image

		waitForUser("Draw","Draw the area to analyze and click on OK to continue"); //pause to wait for an action 
		getStatistics(area, mean, min, max, std, histogram);
		run("Clear Outside"); //remove the outside of the region
		run("Split Channels"); //split the channels
		
		//remove the blue channel
		selectWindow(title+" (blue)");
		close();

		//obtain which is the red and green channels
		redCh=title+" (red)";
		greenCh=title+" (green)";

		//processing of the red channel
		selectWindow(redCh);
		run("8-bit");
		run("Red"); //visual color
		
		//duplicate the red channel 
		selectWindow(redCh);
		run("Duplicate...", " "); //duplicate the red channel
		selectWindow(redCh+"-1");
		//apply the Smooth filter to remove the noise
		run("Smooth"); 
		run("Smooth");
		run("Threshold...");//segmentation of the blood vessels
		setAutoThreshold("MaxEntropy dark");
		waitForUser("Review the threshold", "Click on OK to continue");//pause to wait for an action 
		
		run("Analyze Particles...", "size="+minSize+"-"+maxSize+" clear include add"); //obtain the regions of the blood vessels
		
		selectWindow(redCh+"-1");//close the duplicate image
		close();

		//processing of the green channel
		selectWindow(greenCh);
		run("8-bit");
		run("Green");
		//draw the regions over the green channel to measure the intensity on this channel
		roiManager("Show None");
		roiManager("Show All");
		roiManager("Show All without labels");//draw the red regions over the green channel
		roiManager("Measure");//measure the red regions in the green channel
		//Adding the area value of the region analyzed
		nRow=roiManager("count");
		setResult("Label", nRow, title);
		setResult("Area", nRow, area);
		updateResults();
		waitForUser("Review the regions", "Click on OK to continue");//pause to check the results

		//save the results
		roiManager("Save", outputPath+File.separator+"RoiSet_"+redCh+".zip"); //save the regions obtained into the output folder
		saveAs("Results", outputPath+File.separator+"Results_"+greenCh+".csv"); //save the results in a csv-file
		selectWindow("Results");
		run("Close");

		
		//measure the area of the green channel into the red region selected like blood vessels

		selectWindow(greenCh);

		getDimensions(width, height, channels, slices, frames);
		newImage("redMask", "8-bit black",width, height, 1);
		selectWindow("redMask");
		roiManager("Show All without labels");
		roiManager("Fill");
		roiManager("reset");

		selectWindow(greenCh);
		roiManager("show none");
		setAutoThreshold("IJ_IsoData dark"); //segmentation of the green cells
		run("Threshold...");
		waitForUser("Review the threshold", "Click on OK to continue");

		run("Analyze Particles...", "size="+minSizeGreen+"-"+maxSizeGreen+" clear include add"); //obtain the regions of the green cells

		if(roiManager("count")!=0)
		{
			newImage("greenMask", "8-bit black",width, height, 1);
			selectWindow("greenMask");
			roiManager("Show All without labels");
			roiManager("Fill");
			roiManager("reset");
			
			imageCalculator("AND create", "redMask","greenMask");
			rename("green_in_red");
	
			run("Set Scale...", "distance="+disPixels+" known="+knownDis+" pixel=1.000 unit=micron"); //settings the scale of the image
			//choose the measurements which it is going to analyze
			run("Set Measurements...", "area display redirect=None decimal=5"); //fix the measures which we want
			run("Watershed");
			run("Analyze Particles...", "clear include add");

			roiManager("Show None");
			roiManager("Show All without labels");
			roiManager("Measure");
			saveAs("Results", outputPath+File.separator+"Results_Area_"+greenCh+".csv");
			roiManager("Save", outputPath+File.separator+"RoiSet_"+greenCh+".zip"); //save the regions obtained into the output folder
			waitForUser("Click on OK to continue");
		}
		else{
			waitForUser("This image do not have any green cells into a blood vessel with these criteria. Click on OK to continue with the next image")
		}
		
		//close images and results windows and the ROI-manager
		run("Close All");
		selectWindow("ROI Manager");
		run("Close");
		if(isOpen("Results")){
			selectWindow("Results");
			run("Close");
		}

	}
}
selectWindow("Threshold");
run("Close");
print("Done!");


