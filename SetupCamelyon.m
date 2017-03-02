%SETUP Setting up project paths
[pathstr,name,ext] = fileparts(mfilename('fullpath')); 
% 
addpath([pathstr filesep]);
addpath([pathstr filesep 'util']);
addpath([pathstr filesep 'net']);
addpath([pathstr filesep 'patchgen']);
addpath([pathstr filesep 'RMPostProcess']);

addpath([pathstr filesep 'extern' filesep 'matconvnet-1.0-beta20' filesep]);
addpath([pathstr filesep 'extern' filesep 'matconvnet-1.0-beta20' filesep 'matlab' filesep]);
addpath([pathstr filesep 'extern' filesep  'matconvnet-1.0-beta20' filesep 'examples']);
addpath([pathstr filesep 'extern' filesep 'prec_rec' filesep]);
addpath([pathstr filesep 'extern' filesep 'ksvdbox' filesep 'utils' filesep]);
addpath([pathstr filesep 'camelyonDefaults']);


run([pathstr filesep 'extern' filesep 'tepismat' filesep 'init.m']);

if (ispc)
    setenv('PATH', [getenv('PATH') ';' [pathstr filesep 'extern' filesep 'openslide-win64-20150527' filesep 'bin' filesep]]);  
    OpenSlide.initialize([pathstr filesep 'extern' filesep 'openslide-win64-20150527' filesep 'include' filesep 'openslide' filesep]);
else 
   setenv('LD_LIBRARY_PATH', [getenv('LD_LIBRARY_PATH') ':' '/work/openslide-3.4.1/installed/lib:/work/OpenJPEG/openjpeg/installed/lib']);
   addpath('/work/openslide-3.4.1/installed/lib');
   addpath('/work/OpenJPEG/openjpeg/installed/lib');

   OpenSlide.initialize('/work/openslide-3.4.1/installed/include/openslide/');
    
end

vl_setupnn
%vl_setup
