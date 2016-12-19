//------------------------------------------------------------------------------
//  rootlogon.C: a sample ROOT logon macro allowing use of ROOT script 
//               compiler in CDF RunII environment. The name of this macro file
//               is defined by the .rootrc file
//
//  USESHLIBS variable has to be set to build Stntuple libraries locally:  
//
//  setenv USESHLIBS 1
//
//  Feb 12 2001 P.Murat
//------------------------------------------------------------------------------
{

  TStyle *myStyle  = new TStyle("MyStyle","My Root Styles");
 
                                // print overflows/underflows in the stat box
  myStyle->SetOptStat(11111111); //Integral, Overflow, Underflow, RMS, Mean, Nent, Name
                                // print fit results in the stat box
  myStyle->SetOptFit(1111);     //probability, Chi2, errors, name/values of parameters
                                // this line reports the process ID which simplifies
                                // debugging

  //gInterpreter->ProcessLine(".! ps | grep root");

  //gROOT->SetStyle("Plain");

// See http://root.cern.ch/root/roottalk/roottalk00/1067.html
// Objec<F25>ts like the title box and the statistics box are generated on the fly
// when the histogram or graph is being drawn.
// Use the TStyle control object to set your own defaults:
//
  //myStyle->SetTitleX(0.1);    //Title box x position (top left-hand corner)  
  //myStyle->SetTitleY(0.995);   //Title box y position (default value)    
  //myStyle->SetTitleW(0.6);    //Title box width as fraction of pad size
  //myStyle->SetTitleH(0.08);  //Title box height as fraction of pad size  
  //myStyle->SetTitleColor(0);  //Title box fill color
  //myStyle->SetTitleTextColor(4);  //Title box text color
  //myStyle->SetTitleStyle(1001);  //Title box fill style!
  ////TitleFont = 10*fontid + 2 (12 is normal, 22 bold 32 italic)
  //myStyle->SetTitleFont(32);    //Title box font (32=italic times bold)
  //myStyle->SetTitleBorderSize(2);  //Title box border thickness
  //myStyle->SetTitleOffset(0.8,"x");  //X-axis title offset from axis
  //myStyle->SetTitleOffset(1.1,"y");  //X-axis title offset from axis
  //myStyle->SetTitleSize(0.05,"x");    //X-axis title size
  //myStyle->SetTitleSize(0.05,"y");
  //myStyle->SetTitleSize(0.05,"z");
  //myStyle->SetLabelOffset(0.025);


  //myStyle->SetStatX(0.995);    //Stat box x position (top right hand corner)  
  //myStyle->SetStatY(0.995);     //Stat box y position     
  //myStyle->SetStatW(0.09);       //Stat box width as fraction of pad size  
  //myStyle->SetStatH(0.09);       //Size of each line in stat box  
  //myStyle->SetStatColor(0);    //Stat box fill color
  //myStyle->SetStatTextColor(1);    //Stat box text color
  //myStyle->SetStatStyle(1001);    //Stat box fill style!
  //StatFont = 10*fontid + 2 (12 is normal, 22 bold 32 italic)
  //myStyle->SetStatFont(62);      //Stat box fond
  //myStyle->SetStatBorderSize(2);    //Stat box border thickness
  //myStyle->SetStatFormat("6.4g");

  //Statistic box options     (from left to right)

  //Go to view menu on canvas, select markers to view possible values
  //myStyle->SetMarkerStyle(20);    //Marker is a circle
  //myStyle->SetMarkerSize(.5);      //Reasonable marker size
  //
  //to modify a given histogram already in a pad use this?
  //TPaveText *title = (TPavbeText*)gPad->GetPrimitive("title");
  //title->SetX2NDC(0.6);
  //gPad->Modified();
  //myStyle->SetTitleOffset(0.8,"x");  //X-axis title offset from axis
  //myStyle->SetTitleOffset(1.1,"y");  //X-axis title offset from axis
  //myStyle->SetTickLength(-0.03,"XY");
  //gROOT->ForceStyle();
  gROOT->SetStyle("MyStyle"); //uncomment to set this style   
   
}
