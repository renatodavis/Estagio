// ZipMaster configuration

// uncomment to remove support for multi-part zip files
//{$DEFINE NO_SPAN}
// uncomment to remove support for self expanding zip files
//{$DEFINE NO_SFX}
// define 'INTERNAL_SFX' to include SFXSlave
{$DEFINE INTERNAL_SFX}
// define USE_ALLZIPSTRINGS to use 'ResourceString's for all strings
{$DEFINE USE_ALLZIPSTRINGS}
// define ALLOW_2G to allow 'old' OnProgress to work with files above 2G
//{$DEFINE ALLOW_2G}
       
{$IFDEF INTERNAL_SFX}
{$UNDEF NO_SFX} 
{$ENDIF} 

{$INCLUDE '..\vcl\ZipVers.inc'}
{$IFNDEF VERD4+}
  No longer supported - does not support Int64 (plus others)
{$ENDIF}
{$IFDEF VERD5-}
{$IFNDEF NO_SFX}
  {$DEFINE INTERNAL_SFX}
{$ENDIF}
{$ENDIF}
{$IFDEF VERD6up}
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}


