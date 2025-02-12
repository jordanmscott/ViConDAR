%% Header
%
% Configuration file for all functionalities of ViConDAR. All the inputs to
% the virtual lidar and other modules are read from here, including names,
% paths, parameters and flags.
%
% V.Pettas/F.Costa
% University of Stuttgart, Stuttgart Wind Energy (SWE) 2019

function input = InputParameters()

%% Input variables for naming and indexing and WF properties

input.nameBase = 'TEST'; %This is the first part of the name to be used for the concatenation
% free naming conventions by the user. They should appear in the name of the
% original windfield (at least one). Commenting out will make them not appear
% in the name concatenation.
input.freeInp = {
                 'Sh' ,[25]; % Shear
                 'SD' ,[1];  % Seed number
                 'V'  ,[15]; % Mean velocity
                 'TI' ,[5];  % Turbulence intensity
    }; %#ok<*NBRAK>

% Parameters of the simulator cannot be changed.
% Commenting out will make them not appear in the name concatenation.
% At least one should be used. If any of them has more than variation then
% it should be used in the name.
input.fixedInp ={
    'Pat' ;   %input.PatternNames
    %                 'Ns';     %input.noise_U
    'Tp';     %timeStep_pattern
    'Tm'   ;  %input.timeStep_Measurements
    %                 'Pos'   ; %input.Pos_LiDAR
    %                 'Fd'   ;  %input.ref_plane_dist
    %                 'DAv'  ;  %input.distance_av_space
    %                 'SlAv'  ; %points_av_slice
    };

% This should not be changed. Only when a new lidar feature is added. This is a list of all the parameters required to run lidar simulator
input.AllFixed = {'Pat';'Ns';'Tp';'Tm';'Pos';'Fd' ;'DAv';'SlAv'};
%-------------------------------------------------------------------------%

%% Flags for the different functionalities of the framework.

%Wrapper global flags to choose the functionality
input.flag_getLidarOutput     = 1; % Obtain data for comparison between original and lidar measured time series
input.flag_getTurbsimInput    = 1; % Obtain inputs to create constrained windfield with turbsim
input.flag_getPyconturbInput  = 1; % Obtain inputs to create constrained windfield with pyconturb
input.flag_obtain_Con_Turbsim = 1; % Run turbsim and obtain constrained wind field
input.flag_obtain_Con_Pyconturb_Matlab   = 0; % Run pyconturb and obtain constrained wind field through matlab
input.flag_obtain_Con_Pyconturb_python   = 0; % Run pyconturb and obtain constrained wind field through the Python wrapper
input.flag_obtain_Con_Pyconturb_ConverToMat = 0; % After simulation is done with python run this to obtain the windfiels in matlab for further processing with ViConDAR. This flag has to be used together with flag_obtain_Con_Pyconturb_python
input.flag_calculate_fullWF_statistics = 1; % Calculate statistics from full wind fields (constrained and/or original). Code looks in all folders using the names provided as input
input.flag_floating                    = 0; % Consider Floating Dynamics of WT, Dynamics files from Aeroelastic simulation must be available
input.flag_saveDynamicstoOutput        = 0; % Floating Dynamics are assigned to Output Struct and saved 
%Flags for virtual lidar measurements parameters
input.flag_apply_noise      = 1; % Apply noise to measured points
input.flag_apply_LOS        = 1; % Apply Line of sight of LiDAR
input.flag_apply_weightREWS = 1; % Weight for the length of the blade for REWS caclulation.Implemented by user below (Wi)
input.flag_resampling       = 1; % Apply resampling to the lidar measurments. Currently based on frequency domain zero padding

% Flags for plotting options
input.flag_plot_lidar          = 1; % plot lidar measurements vs original windfield
input.flag_plot_WF_timeseries  = 1; % plot points from the grids of windfields the code will look for all constrained and original windfields with the same name and plot if they exist
input.plot_fullWF_Slices       = 1; % plot slices in time from the grids of windfields the code will look for all constrained and original windfields with the same name and plot if they exist
%-------------------------------------------------------------------------%

%% Lidar parameters

input.PatternY = {[ 54  54 0 -54 -54];[0 -76.5 76.5 -45 45 -45  45]}; % Pattern points Y axis (in meters). Each line of the cell is a pattern
input.PatternZ = {[-54  54 0 -54  54];[0   0    0    63 63 -63 -63]}; % Pattern points Z axis (in meters). Each line of the cell is a pattern

input.PatternNames = {'5P_Rectangular' '7P_Circular' }; % names of the patterns. Important: number of names should equal number of Y,Z coordinates and both (values and name of the pattern) should follow the same order in its cells

input.timestep_pat_vec      = {[5] [10 4] }; %Time step of the total pattern. Sampling rate of total pattern should be that npoins*timestep_meas<=timestep_pat(s). Add one value for each pattern
input.timeStep_Measurements = {[0 1] [0]}; %Time step between each single measured point. Add one value for each pattern [s]

input.ref_plane_dist    = [250]; % Reference Plane for LOS (distance[m]).
input.Pos_LiDAR         = [0,0]; % LiDAR position offset from hub center(meters)==> [Y,Z]. It cannot be used to loop over it. It has to be fixed for now
input.distance_av_space = [30];  % Values to use for imitating range gate averaging in the calculation of wind speeds. Meters before and afer the range gate center point (Lidar volume average)
input.points_av_slice   = [5];   % How many point/slices you want to take in the averaging of distance_av_slice  Totalpoints = distance_av_slice/points_av_slice+1 IT HAS TO BE AN EXACT DIVISION FOR NOW!!!!
input.noise_U           = [20];  % magnitude of noise to be applied in U time series (see help of awgn function)
input.noise_V           = input.noise_U; % magnitude of noise to be applied in V time series (see help of awgn function)
input.noise_W           = input.noise_U; % magnitude of noise to be applied in W time series (see help of awgn function)

%-------------------------------------------------------------------------%

%% Wind field rotation
% not yet implemented, its not functional

input.yaw_angle  = 0; % yaw rotation in degrees 360>yaw>-360 Positive is clockwise looking from the top of the nacelle
input.tilt_angle = 0;  % tilt rotation in degrees. Positive is up

%-------------------------------------------------------------------------%

%% Processing lidar measurements

input.dist_REWS_nd = [0 0.1 0.50 0.6 0.7 0.85 0.9 0.95 1 ]; % Non dimensional span position for rotor effective wind speed calculation [define from 0 to 1 inclusive]. Blade length derived from rotor radius
input.Wi           = [0.2 0.23 0.4 0.6 0.85 0.95 1 0.6 0 ]; % Weight to be applied for rotor effective wind speed calculation. dist_REWS_nd and Wi have to have the same size
input.resampling_factor = 2; % Amount of desired resampling for outputs in Turbsim and PyConTurb used with flag_resampling

input.nComp                = 1;        % 1:u, 2:v+u 3:u+v+w. Number of components to process (U,V,W):
input.type_interpolation   = 'linear'; % (interp1) interpolation between slices line460 (check other options of interpm)
input.type_interpolation_2 = 'linear'; % (interp2)  interpolation in selected slice for values on the pattern points
input.ReconstructionMethod = 'simple'; % 'simple': v=0,w=0 assumption 

%% Directory/path definition

% All directories are strings to be concatenated and they should always finish
% with \ or /. If you run on Mac/Linux definitions should be changed accordingly
input.OriginalWF_dir  = '..\OriginalWF\';      % Direcotry where original windfileds in .mat format are saved
input.LidarOutput_dir = '..\LidarOutput\';     % Directory to save the lidar measurement outputs
input.ConstrainedWF_dir = '..\ConstrainedWF\'; % Directory to save all constrained windfileds

input.TurbSimInput_dir   = '..\InputsForConstrainedTurb\TurbsimInput\';   %Directory to save inputs to use with turbsim constraining functionality
input.PyconturbInput_dir = '..\InputsForConstrainedTurb\PyconturbInput\'; % Directory to save the required inputs to run Pyconturb for constraining a windfield

input.PyconturbOut_dir = '..\ConstrainedWF\PyConTurb\'; % Sub directory to save Pyconturb outputs (.mat, .csv)
input.TurbSimOut_dir   = '..\ConstrainedWF\Turbsim\';  % Sub directory to save Turbsim outputs (.mat,.wnd etc.)

input.fullWF_statistics_dir = [input.ConstrainedWF_dir 'Statistics\']; % Directory to store the statistics from full windfields invcluding both original and constrained

input.TurbSimExe_path = '..\ConstrainedWF\Turbsim\TurbSim_x64.exe'; %Full path to the executable of Turbsim. If other platform than windows is used the correct executable is neeeded

input.pathToTurbSim = '..\ConstrainedWF\Turbsim\';  %
input.TurbSimInpTemplate = '..\ConstrainedWF\Turbsim\Template_Turbsim.inp'; % Full path to Turbsim tempalte .inp. It is required to build upon it the case specific input.
input.PythonExe_path     = 'python';         % Path to run python. If python is set as environmental variable writing python is enough. If not, the full path to the correct python environment and executable is required

input.AddUserDir = {input.LidarOutput_dir input.ConstrainedWF_dir input.TurbSimInput_dir input.PyconturbInput_dir input.PyconturbOut_dir input.TurbSimOut_dir input.fullWF_statistics_dir};

%% Floating Wind parameters

%Directory of Turbine Dynamics to be considered in floating Simulation
input.OriginalDynamics_dir    = '..\Floater_Dynamics\'; % Naming convention for dynamics files: OriginalWFName_dynamics.mat, see example files for required structure
% Name of Dynamic Channels present in Dynamics struct. IMPORTANT: Keep
% order of this name cell,  {'Pitch'; 'Roll'; 'Yaw'; 'x_vel' ; 'y_vel';
% 'z_vel'; 'x_trans_L';'y_trans_L';'z_trans_L'; 'Time'}, Angles have to be
% defined in [deg], translations in [m] and velocities in [m/s], all
% channels must be available in the dynamics input, Naming Convention:
% Dynamics.Channelname
input.channels.channelnames  = {'Pitch'; 'Roll'; 'Yaw'; 'x_vel' ; 'y_vel'; 'z_vel'; 'x_trans_L';'y_trans_L';'z_trans_L'; 'Time'};
% flags for DOF consideration
input.DOF.tilt = 1; % 0: 'Pitch'; 'Roll'; 'Yaw';'x_trans';'y_trans_L';'z_trans_L'; are overwritten with zero
input.DOF.vel  = 1; % 0: 'x_vel' ; 'y_vel'; 'z_vel' are overwritten with zero

%% Wind turbine parameters

input.rotor_radius = 89.15; % Radius of the Rotor [m]
input.Zh           = 119;  % Hub Height [m]

%% Constrained turbulence codes

% %Turbsim .inp file options for details see tha manual of Turbsim V2.00 Alpha (https://nwtc.nrel.gov/Alphas)
input.RandSeed    = round(rand(1)*80682); % random seed for phases
input.UsableTime  = '"ALL"';      % UsableTime input it can also use a number
input.IECstandard = '"1-ED3"';    % iec standard edition
input.SCMod1      = '"GENERAL"';  % standard coherence model NONE IEC=~GENERAL
input.WindProfileType = '"PL"'; % "LOG", "PL" and, if we have more than one measuring point we can also use "TS"
input.LengthScale     = {'"default"', '"default"','"default"'};  %e.g. {"'default'","'100'","'50'"}={"'u'","'v'","'w'"} - Could be default or number. Do not remove quotation marks!

%PyConTurb for details see pycptrub documentation (https://rink.pages.windenergy.dtu.dk/pyconturb/index.html)
input.flag_save_pyconturb_input = 0; % obtain PyConTurb input
input.flag_runPyConTurb         = 0; % Run pyconturb
input.CondaEnv                  = 'PyConEnv';

% input options to run pyconturb (passed through the .csv to the python code)
input.turb_class = 'B';
input.coh_model  = 'iec'; % coh_model (str, optional) � Spatial coherence model specifier. Default is IEC 61400-1.
input.wsp_func   = 'data_profile';% wsp_func (function, optional): constant_profile or power_profile
input.sig_func   = 'data_sig'; %sig_func (function, optional):
input.spec_func  = 'data_spectrum';%spec_func (function, optional). 'kaimal_spectrum',:
input.seed       = uint32(rand(1)*80682); %seed (int, optional): Optional random seed for turbulence generation. Use the same seed and settings to regenerate the same turbulence box.
input.nf_chunk   = 100; % Number of frequencies in a chunk of analysis. Default is 1.[Total chunks if nf_chun=1 are ceil(N_timesteps)/2+1].
input.interp_data = 'Take_list'; % Could be 'all','none' or 'Take_list'. If 'Takes_list' then takes into account what we introduce in wsp_func, sig_func and spec_func.

%% Plotting options
% These option are only relevant if input.plot_fullWF_Slices are switched
% on
input.points_plot_WF_timeseries = [-54 70 0 45; 54 70 0 -63];
input.plot_WF_timeseries_Pyconturb = 0 ; % use constrained windfields with pyconturb for timeseries
input.plot_WF_timeseries_Turbsim = 1 ; % use constrained windfields with turbsim for timeseries

input.time_fullWF_Slices = [52 100]; % slices in time [s]
input.plot_WF_slices_Pyconturb = 0; % use constrained windfields with pyconturb for plotting slices
input.plot_WF_slices_Turbsim = 1;   % use constrained windfields with turbsim for plotting slices
