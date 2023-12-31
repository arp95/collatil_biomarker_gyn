clc
% clinVarRiskLabelMtx: a numeric matrix with each row corresponding to a
% patient and each column corresponding to a variable (clinical variables or risk label variable (0: low risk, 1: high risk))
% dfs:  the time interval from diagnosis to DFS event
% event: 1: event, 0: censored
%dfs = [1511; 468; 976; 268; 575; 9; 1658; 949; 592; 2616; 130; 1189; 16; 3525; 2788; 1516; 143; 135; 31; 1004; 1279; 1155; 91; 1035; 1249; 457; 840; 394; 1162; 1799; 1091; 455; 730; 1492; 1157; 365; 608; 90; 943; 420];
%event = [1; 0; 1; 0; 1; 1; 0; 1; 1; 0; 0; 1; 0; 0; 0; 1; 0; 0; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 0];
%clinVarRiskLabelMtx = [[1, 3, 0]; [0, 4, 0]; [0, 3, 0]; [0, 3, 0]; [1, 4, 0]; [0, 4, 0]; [0, 3, 0]; [0, 4, 0]; [1, 3, 0]; [0, 3, 0]; [1, 3, 0]; [0, 3, 0]; [1, 2, 0]; [0, 3, 0]; [0, 3, 0]; [0, 4, 0]; [1, 3, 0]; [0, 3, 1]; [1, 4, 1]; [0, 4, 1]; [0, 3, 1]; [1, 3, 1]; [1, 4, 1]; [1, 3, 1]; [1, 3, 1]; [1, 3, 0]; [1, 3, 0]; [1, 3, 1]; [1, 3, 0]; [1, 4, 0]; [1, 3, 1]; [0, 3, 0]; [1, 3, 1]; [0, 3, 0]; [1, 3, 0]; [0, 4, 1]; [1, 3, 0]; [1, 3, 1]; [0, 4, 0]; [0, 2, 0]];
%clinVarRiskLabelMtx = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 1; 1; 1; 1; 1; 0; 0; 1; 0; 0; 1; 0; 1; 0; 0; 1; 0; 1; 0; 0];
dfs = [1688; 534; 1011; 157; 2234; 491; 6375; 1714; 275; 2226; 1427; 555; 1169; 1099; 454; 1221; 254; 1800; 1791; 1243; 555; 132; 494; 1456; 477; 2669; 621; 4467; 1756; 788; 4738; 11; 595; 1551; 45; 252; 1031; 1617; 617; 542; 0; 542; 491; 0; 1122; 623; 5271; 27; 284; 253; 4483; 524; 523; 284; 2114; 579; 483; 803; 567; 619; 471; 343; 965; 370; 372; 504; 607; 2859; 828; 0; 21; 1946; 830; 410; 919; 1367; 0; 2094; 34; 14; 74; 0; 469; 492; 2496; 2888; 533; 1186; 2893; 861; 490; 442; 911; 825; 1535; 482; 518; 369; 397; 755; 1203; 959; 1472; 867; 1320; 863; 940; 1357; 1210; 636; 119; 954; 729; 1525; 773; 259; 2526; 739; 2383; 448; 951; 543; 1103; 1582; 715; 607; 815; 4879; 279; 1263; 552; 1243; 829; 0];
event = [0; 0; 1; 1; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 0; 0; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 1; 1; 0; 1; 0; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 0; 0; 0; 0; 0; 0; 1; 0];
clinVarRiskLabelMtx = [[1, 4.0, 1]; [1, 4.0, 0]; [0, 3.0, 1]; [0, 4.0, 1]; [0, 3.0, 0]; [0, 4.0, 1]; [1, 4.0, 1]; [1, 3.0, 1]; [1, 3.0, 1]; [1, 3.0, 1]; [0, 4.0, 1]; [1, 3.0, 1]; [0, 4.0, 1]; [1, 4.0, 1]; [1, 3.0, 1]; [0, 3.0, 0]; [1, 3.0, 1]; [0, 3.0, 1]; [1, 3.0, 1]; [1, 3.0, 1]; [1, 4.0, 1]; [0, 4.0, 1]; [0, 3.0, 1]; [0, 4.0, 1]; [0, 3.0, 1]; [1, 3.0, 1]; [1, 3.0, 1]; [0, 3.0, 1]; [1, 4.0, 1]; [1, 4.0, 1]];
%size(dfs)
%size(event)
%size(clinVarRiskLabelMtx)
[b, logl, H, stats] = coxphfit(clinVarRiskLabelMtx, dfs, 'Censoring', ~logical(event));

% coxHrMatx: each element in coxHrMatx correpsonds to HR (and associated CI
% and p value) for each clinical variable or risk label from the mutlivariate analysis
coxHrMatx={};
for varSeqInd=1:size(clinVarRiskLabelMtx, 2)
coxHr=['HR=',num2str(round(exp(stats.beta(varSeqInd)),2)),' (p=',num2str(round(stats.p(varSeqInd),2)),',CI=',...
    num2str(round(exp(stats.beta(varSeqInd)-1.96*stats.se(varSeqInd)),2)),'~',num2str(round(exp(stats.beta(varSeqInd)+1.96*stats.se(varSeqInd)),2),2),')'];
coxHrMatx{varSeqInd}=coxHr;        
end
coxHrMatx(1)
coxHrMatx(2)
coxHrMatx(3)