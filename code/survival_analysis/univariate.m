%% Author: Arpit Aggarwal
clc
close all
clear 
addpath(genpath('pwd'))

dfs = [410.12039415; 1864.09245165; 483.3203667000001; 431.1779205; 1095.99410955; 408.11491544999996; 330.9039855; 339.92863965; 253.69305554999997; 408.11491544999996; 304.8327624; 309.84645915000004; 666.82166775; 393.0738252; 371.01355949999993; 800.1860013; 630.72305115; 406.10943675000004; 348.9532938; 1049.86809945; 605.6545673999999; 856.3394049; 534.4600735500001; 322.8820707; 540.47650965; 501.369675; 903.46815435; 677.8518006; 233.63826854999996; 358.9806873];
event = [1; 1; 0; 0; 1; 0; 0; 1; 1; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 1; 1; 0; 0; 1; 0; 0; 0; 1; 0; 0];
clinVarRiskLabelMtx = [1; 0; 1; 1; 0; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 0; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1];

[output] = MatSurv(dfs/30.5, event, clinVarRiskLabelMtx)