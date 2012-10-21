
			Welcome to the Delphi Zip v1.78
                   This is the Delphi Edition for vaersion 4 and later only
					October 31, 2004
						 
Major Changes

Delphi versions supported
 	not before 4

Directory Structure
  VCL - ZipMaster and ZipSFX files
  Packages - design- and run-time page files
  Dll - dlls and Dlls stored in resource
  Grid - sort grid (used in demos)
  Tools - updater for language resource strings

Configuration
  In VCL/ZipConfig.inc 
   { $DEFINE NO_SPAN}  // uncomment to remove support for multi-part zip files
   { $DEFINE NO_SFX}   // define to remove support for self expanding zip files
   { $DEFINE INTERNAL_SFX}  // define to include TZipSFX as part of ZipMaster 
{$DEFINE USE_ALLZIPSTRINGS}  // define to use 'ResourceString's as default for all strings.
  No need to link ZipMsg??.res language file (US only but can translate using tools) 
  
Files
  VCL/
   VCL\UnzDLL.pas 	- definitions UnzDll
   VCL\ZCallBck.pas 	- definitions for Callback structure
   VCL\ZipBase.pas 	- primitive part of internal class ZMaster
   VCL\ZipDLL.pas 	- definitions for ZipDll
   VCL\ZipMsg.pas 	- Error message Ident constants
   VCL\ZipMstr.pas 	- Main TZipMaster class definitions
   VCL\ZipDlg.pas 	- dialogs
   VCL\ZipCtx.pas	- Help context constants for Dialogs 
   VCL\ZipStrs.pas 	- default strings as ResourceStrings
   VCL\ZipStructs.pas 	- definitions of internal zip file structures
   VCL\ZipUtils.pas 	- some handy functions for handling zip files
   VCL\ZipXcpt.pas 	- definitions of EZipMaster the exceptions raised by ZipMaster
   VCL\ZLibLoad.pas 	- low level loader for dlls
   VCL\ZipWrkr.pas 	- internal class that does the work
   VCL\ZipProg.pas      - class handling progress details
   vcl\zipvers.inc	- include file for Delphi versions
   vcl\zipconfig.inc	- include file to set options ('includes' zipvers.inc)
   
// TZipSFX by markus stephany (with ZipSFX and DZUtils modified by me)
   VCL\DZUtils.pas 
   VCL\SFXInterface.pas 
   VCL\SFXStructs.pas 
   VCL\ZipSFX.pas  
   vcl\delver.inc
   vcl\lang2.inc
   vcl\missing_types.inc
   vcl\sfxver.inc
   
   Packages\zmstrV178R.dpk	- Run-time package (compile first) V = delphi version
   Packages\zmstrV178D.dpk	- Design package (Install last) V = delphi version
   Packages\ZipMstrReg.pas	- register TZipMaster
   Packages\ZipSFXReg.pas	- register TZipSFX
   Packages\zm_grid_R.dpk	- SortGrid Run-time package (compile first) (Optional)
   Packages\zm_grid_D.dpk	- SortGrid Design package (Install last) (Optional)
   Packages\stringgridReg.pas	- register TSortGrid (optional)

   DLL\ZipDll.dll	- compression routines
   DLL\UnzDll.dll	- extraction routines
   dll\resdlls.res	- dlls compressed and saved as resources (automatically extracted)
   
      
     
                           Distribution Policy
                   Guidelines for Legal Re-distribution
     
       1) This applies to both end-users and developers.  The meat of
          this package is the .DLL files, and they are needed by all
          of your end-users if you use this ZIP package in your 
          program.
         
       2) You must not charge money for any part of the ZIP package.
          Warning:  The primary concern here is if you will market a
          new package that is only slightly more than a verbatim copy 
          of this package, or one of it's demos.  ANY release you sell
          is OK as long as you charge ONLY for the changes you make.
     
       3) You MUST either distribute the source code for this ZIP
          package, or give a WWW site where it can be obtained
          freely. This can be on a Help...About screen, in printed
          documentation, or in text files distributed with your 
          package.  Yes, it does seem odd to have this requirement
          for end-users who aren't programmers, but there is no
          mistake.  After all, it isn't hard to give them a URL
          and a few words explaining what it is for.
     
       4) You must document the Info-Zip's WWW home page URL, but 
          don't expect any help from the Info-Zip group, since my 
          release is only a derrivitive of their work.  They are 
          very busy doing support for their "official" releases.
          Since much of the DLL source code comes from them, they
          deserve to be mentioned.
             Info-Zip:   http://www.cdrom.com/pub/infozip/
     
       5) You must handle product support with your own end-users.
          This is needed because I don't have enough time to do
          support for end-users.
     
       6) I will handle support issues with programmers using this 
          package on a time-available basis. Since this is being
          distributed as freeware, you can't expect the kind of 
          support you'd get from a commercial vendor.  Please limit
          your questions to those that directly pertain to this
          ZIP package.
     
       7) You may NOT distribute executable versions of my demo
          programs to end-users without my approval.  These are 
          only example applications to teach you how to use
          this package. 
     
     
                         DLL Source Code in C
            
        The DLL source code is distributed separately due to it's
     size, and the fact that most Delphi users of this package
     probably don't want the C source for the DLL's.  The DLL 
     source is also freeware, and will remain that way. 
     The DLL source code needs Borland C++ Builder v3 - v6.
     
     
                     Problem Reports or Suggestions
     
     We DO want to hear your ideas!  If you find a problem with
     any part of this project, or if you just have an idea for
     us to consider, send us e-mail!
     
     But, please make sure that your bug has not already been
     reported.  Check the "official" web site often:
     
     http://www.geocities.com/SiliconValley/Network/2114/zipbeta.html
       
     Eric Engler
     englere@abraxis.com
     
     Latest Versions and changes available at
     http://www.delphizip.net/index.html
     
     Problems
     please report any to 
     problems@delphizip.net
     
     Amended and updated by
     R.Peters 
     
