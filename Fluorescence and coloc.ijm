//Measure fluorescence (integrated density) of antibody staining in 2 channels
//Also calculates Pearson coefficient for colocalization
//Can be used with all particles, do not run Phagosome Finder for zymosan particles, use freehand selections
//Author: PL
//Version 1.1 - 6th of March, 2015

/*
Dependencies:
- Polar Stack by Geert van den Bogaart
 */


//Set measurements
run("Set Measurements...", "area mean integrated redirect=None decimal=3");

//Prepare samples
run("Duplicate...", "title=dupe duplicate");
run("Polar Stack");
run("Split Channels");

//Close redundant windows (BF images and DAPI)
selectWindow("C4-resultPolar.tif");
close();
selectWindow("C1-resultPolar.tif");
close();

//Ask user for ROI
 if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }
selectWindow("C2-resultPolar.tif");
run("In [+]");
run("In [+]");
ID = getImageID();
setTool(0);
beep();
waitForUser("Select ROI");
selectImage(ID);
roiManager("Add");

//Measure area, mean intensity and integrated density 
//Apply ROI input to all samples here (use ROI manager)
selectWindow("C2-resultPolar.tif");
roiManager("Select", 0);
run("Measure");
selectWindow("C3-resultPolar.tif");
roiManager("Select", 0);
run("Measure");

//Colocalization measurement
run("Coloc 2", "channel_1=C2-resultPolar.tif channel_2=C3-resultPolar.tif roi_or_mask=[ROI Manager] spearman's_rank_correlation manders'_correlation psf=3 costes_randomisations=10");

//Clean up windows
selectWindow("dupe");
close();
selectWindow("C2-resultPolar.tif");
close();
selectWindow("C3-resultPolar.tif");
close();


selectWindow("Results"); //Open results window for easy exporting
selectWindow("Log"); //Open log window for Pearson correlation

/*Changelog
06-03-2015 v1.1
- Added ROI functionality: asks to define a ROI before measuring and Coloc 2

05-03-2015 v1.0.1
- Close redundant windows after colocolization measurement


*/
/*To do
- Automate background measurements
- Allow picking of channels 
- Enable measuring more than 2 channels upon request

*/