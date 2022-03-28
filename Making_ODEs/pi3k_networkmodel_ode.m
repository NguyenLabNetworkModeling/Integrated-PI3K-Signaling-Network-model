function [output] = pi3k_networkmodel_ode(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Generated: 22-Mar-2022 17:43:34
% 
% [output] = pi3k_networkmodel_ode() => output = initial conditions in column vector
% [output] = pi3k_networkmodel_ode('states') => output = state names in cell-array
% [output] = pi3k_networkmodel_ode('algebraic') => output = algebraic variable names in cell-array
% [output] = pi3k_networkmodel_ode('parameters') => output = parameter names in cell-array
% [output] = pi3k_networkmodel_ode('parametervalues') => output = parameter values in column vector
% [output] = pi3k_networkmodel_ode('variablenames') => output = variable names in cell-array
% [output] = pi3k_networkmodel_ode('variableformulas') => output = variable formulas in cell-array
% [output] = pi3k_networkmodel_ode(time,statevector) => output = time derivatives in column vector
% 
% State names and ordering:
% 
% statevector(1): IGF
% statevector(2): IR
% statevector(3): IRL
% statevector(4): IRp
% statevector(5): IRi
% statevector(6): PI3Ka
% statevector(7): PI3Kb
% statevector(8): IRp_PI3Ka
% statevector(9): IRp_PI3Kb
% statevector(10): pHER3L_PI3Ka
% statevector(11): pHER3L_PI3Kb
% statevector(12): PIP3
% statevector(13): PIP2
% statevector(14): PDK1
% statevector(15): mPDK1
% statevector(16): GAB
% statevector(17): mGABp
% statevector(18): PREX1
% statevector(19): mPREX1
% statevector(20): dRac1
% statevector(21): tRac1
% statevector(22): Akt
% statevector(23): pAkt
% statevector(24): SGK1
% statevector(25): pSGK1
% statevector(26): SGK3
% statevector(27): pSGK3
% statevector(28): GSK3
% statevector(29): pGSK3
% statevector(30): mTORC1
% statevector(31): amTORC1
% statevector(32): FOXO3
% statevector(33): pFOXO3
% statevector(34): NDRG1
% statevector(35): pNDRG1
% statevector(36): S6K
% statevector(37): pS6K
% statevector(38): S6
% statevector(39): pS6
% statevector(40): dRas
% statevector(41): tRas
% statevector(42): Raf
% statevector(43): aaRaf
% statevector(44): Mek
% statevector(45): pMek
% statevector(46): Erk
% statevector(47): pErk
% statevector(48): HER3
% statevector(49): HRG
% statevector(50): HER3L
% statevector(51): pHER3L
% statevector(52): iHER3L
% statevector(53): ER
% statevector(54): pER
% statevector(55): RB
% statevector(56): pRB
% statevector(57): ppRB
% statevector(58): E2F
% statevector(59): E2FRB
% statevector(60): Cd
% statevector(61): CDK4
% statevector(62): K4D
% statevector(63): K4Da
% statevector(64): Ce
% statevector(65): CDK2
% statevector(66): K2E
% statevector(67): K2Ea
% statevector(68): p21
% statevector(69): K4Da_p21
% statevector(70): K2Ea_p21
% statevector(71): cMyc
% statevector(72): p_p21
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global time
parameterValuesNew = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HANDLE VARIABLE INPUT ARGUMENTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 0,
	% Return initial conditions of the state variables (and possibly algebraic variables)
	output = [0, 150, 0, 0, 0, 200, 200, 0, 0, 0, ...
		0, 0, 3000, 100, 0, 225, 0, 100, 0, 100, ...
		0, 100, 0, 100, 0, 100, 0, 100, 0, 100, ...
		0, 100, 0, 100, 0, 100, 0, 100, 0, 150, ...
		0, 100, 0, 200, 0, 400, 0, 100, 0, 0, ...
		0, 0, 10, 0, 100, 0, 0, 0, 0, 0, ...
		100, 0, 0, 0, 100, 0, 0, 0, 0, 0, ...
		0, 0];
	output = output(:);
	return
elseif nargin == 1,
	if strcmp(varargin{1},'states'),
		% Return state names in cell-array
		output = {'IGF', 'IR', 'IRL', 'IRp', 'IRi', 'PI3Ka', 'PI3Kb', 'IRp_PI3Ka', 'IRp_PI3Kb', 'pHER3L_PI3Ka', ...
			'pHER3L_PI3Kb', 'PIP3', 'PIP2', 'PDK1', 'mPDK1', 'GAB', 'mGABp', 'PREX1', 'mPREX1', 'dRac1', ...
			'tRac1', 'Akt', 'pAkt', 'SGK1', 'pSGK1', 'SGK3', 'pSGK3', 'GSK3', 'pGSK3', 'mTORC1', ...
			'amTORC1', 'FOXO3', 'pFOXO3', 'NDRG1', 'pNDRG1', 'S6K', 'pS6K', 'S6', 'pS6', 'dRas', ...
			'tRas', 'Raf', 'aaRaf', 'Mek', 'pMek', 'Erk', 'pErk', 'HER3', 'HRG', 'HER3L', ...
			'pHER3L', 'iHER3L', 'ER', 'pER', 'RB', 'pRB', 'ppRB', 'E2F', 'E2FRB', 'Cd', ...
			'CDK4', 'K4D', 'K4Da', 'Ce', 'CDK2', 'K2E', 'K2Ea', 'p21', 'K4Da_p21', 'K2Ea_p21', ...
			'cMyc', 'p_p21'};
	elseif strcmp(varargin{1},'algebraic'),
		% Return algebraic variable names in cell-array
		output = {};
	elseif strcmp(varargin{1},'parameters'),
		% Return parameter names in cell-array
		output = {'ka_rt_001', 'kd_rt_001', 'kc1_rt_002', 'vm_rt_002', 'kc1_rt_003', 'vm_rt_003', 'kc2_rt_004', 'vm_rt_004', 'Ki_rt_004', 'kc2_rt_005', ...
			'vm_rt_005', 'kc2_rt_006', 'vm_rt_006', 'kc2_rt_007', 'vm_rt_007', 'alpha_rt_008a', 'alpha_rt_008b', 'alpha_rt_008c', 'kc2_rt_010', 'Ki_rt_010', ...
			'vm_rt_010', 'kc2_rt_008', 'kc2_rt_009', 'Km_rt_008', 'vm_rt_011', 'kc2_rt_011', 'kc2_rt_012', 'vm_rt_012', 'kc2_rt_013', 'vm_rt_013', ...
			'kc2_rt_014', 'vm_rt_014', 'ki_rt_014', 'kc2_rt_015', 'vm_rt_015', 'kc2_rt_016', 'vm_rt_016', 'kc2_rt_016a', 'vm_rt_016a', 'kc2_rt_017a', ...
			'kc2_rt_017b', 'alpha_rt_017', 'vm_rt_017', 'kc2_rt_018a', 'kc2_rt_018b', 'vm_rt_018', 'kc2_rt_019', 'vm_rt_019', 'kc2_rt_020a', 'kc2_rt_020b', ...
			'vm_rt_020', 'kc2_rt_021a', 'kc2_rt_021b', 'kc2_rt_021c', 'vm_rt_021', 'Ki_rt_021', 'Ki_rt_022', 'kc2_rt_022', 'Km_rt_022', 'kc2_rt_023', ...
			'Km_rt_023', 'vm_rt_023', 'alpha_rt_023', 'kc2_rt_024', 'vm_rt_024', 'vs_rt_025', 'Km_rt_025', 'kdeg_rt_026', 'vs_rt_027', 'kc2_rt_029', ...
			'vm_rt_029', 'kdeg_rt_030', 'Km_rt_030', 'Km_rt_031', 'vs_rt_031', 'deg_rt_031', 'alpha_rt_031', 'kd_rt_033', 'ka_rt_033', 'alpha_rt_034_a', ...
			'kc1_rt_034_a', 'vm_rt_034_a', 'kc1_rt_034', 'vm_rt_034', 'Km_rt_035', 'vs_rt_035b', 'deg_rt_035', 'vm_rt_037', 'kc2_rt_037', 'mtPIK3CA', ...
			'vs_cc_001', 'kc1_cc_003', 'vm_cc_003', 'kc2_cc_005', 'vm_cc_005', 'tr_cc_007a', 'Km_cc_007a', 'Km_cc_007b', 'tr_cc_007b', 'tr_cc_007c', ...
			'kdeg_cc_008a', 'kdeg_cc_008b', 'Km_cc_008', 'ka_cc_009', 'kd_cc_009', 'vs_cc_010c', 'kdeg_cc_011', 'Km_cc_011', 'kc2_cc_011', 'Km_cc_010b', ...
			'ka_cc_012', 'kd_cc_012', 'kc1_cc_013', 'kc2_cc_013a', 'vm_cc_013b', 'ka_cc_014', 'kc2_cc_014a', 'kd_cc_014', 'vs_cc_015', 'kdeg_cc_015', ...
			'Km_cc_015', 'ka_cc_017', 'kd_cc_017', 'kc1_cc_018a', 'vm_cc_018b', 'ka_cc_019', 'kd_cc_019', 'vs_cc_020', 'Km_cc_020', 'deg_cc_021', ...
			'kc2_cc_021a', 'kc2_cc_021b', 'Km_cc_021a', 'Km_cc_021b', 'Km_cc_025a', 'Km_cc_025b', 'vs_cc_025a', 'vs_cc_025b', 'deg_cc_025', 'kc1_cc_026', ...
			'a0', 'b0', 'PTEN', 'IGF_on_time', 'HRG_on_time', 'BYL719_on_time', 'BYL719', 'w_drg', 'Ki_drg', 'pi3kbi_on_time', ...
			'pi3kbi', 'igfri_on_time', 'igfri', 'her3i_on_time', 'her3i', 'pdk1i_on_time', 'pdk1i', 'pprexi_on_time', 'pprexi', 'rac1i_on_time', ...
			'rac1i', 'ndrg1i_on_time', 'ndrg1i', 'sgk1i_on_time', 'sgk1i', 'sgk3i_on_time', 'sgk3i', 'akti_on_time', 'akti', 'rasi_on_time', ...
			'rasi', 'rafi_on_time', 'rafi', 'meki_on_time', 'meki', 'erki_on_time', 'erki', 'gsk3i_on_time', 'gsk3i', 'mtorc1i_on_time', ...
			'mtorc1i', 'foxo3i_on_time', 'foxo3i', 'myci_on_time', 'myci', 'cdi_on_time', 'cdi', 'cei_on_time', 'cei', 'e2fi_on_time', ...
			'e2fi', 'p21i_on_time', 'p21i', 'eri_on_time', 'eri', 's6ki_on_time', 's6ki'};
	elseif strcmp(varargin{1},'parametervalues'),
		% Return parameter values in column vector
		output = [0.0831764, 0.0141254, 0.108393, 26.9153, 23.4423, 2.69153, 0.229087, 2.75423, 0.00331131, 0.00645654, ...
			0.724436, 316.228, 0.0128825, 28.1838, 0.0295121, 0.0162181, 316.228, 0.11749, 7.94328, 128.825, ...
			50.1187, 0.0707946, 288.403, 2.81838, 0.954993, 28.8403, 0.218776, 0.616595, 1, 64.5654, ...
			0.436516, 0.112202, 281.838, 2.29087, 100, 1.31826, 0.128825, 316.228, 2.04174, 0.111429, ...
			13.1826, 0.00988553, 147.911, 316.228, 316.228, 0.00213796, 102.329, 263.027, 1.02329, 154.882, ...
			316.228, 41.6869, 0.0416869, 316.228, 0.01, 0.389045, 316.228, 0.00550808, 316.228, 316.228, ...
			2.5704, 316.228, 316.228, 316.228, 194.984, 2.95121, 87.0964, 3.63078, 31.6228, 22.9087, ...
			316.228, 0.17378, 0.323594, 218.776, 184.077, 0.0891251, 316.228, 0.0851138, 0.0537032, 0.102329, ...
			10.617, 295.121, 0.316228, 1.34896, 12.8825, 12.5893, 208.93, 0.00288403, 0.0186209, 0.112202, ...
			10.7152, 0.0831764, 0.00416869, 239.883, 0.562341, 0.0616595, 13.1826, 0.138038, 316.228, 0.0371535, ...
			173.78, 79.4328, 0.0177828, 2.44343, 0.245471, 0.234423, 0.0125893, 0.0239883, 51.88, 0.00288403, ...
			0.01, 0.00954993, 0.0286418, 0.732825, 237.137, 0.691831, 0.0245471, 0.301995, 0.0269153, 316.228, ...
			0.0245471, 234.423, 7.24436, 0.0218776, 0.758578, 2.5704, 2.29087, 1.51356, 316.228, 0.00724436, ...
			81.2831, 316.228, 0.213796, 0.0588844, 4.0738, 0.0562341, 0.398107, 245.471, 0.125893, 0.0552077, ...
			1, 1, 100, 2000, 2000, 100000, 0, 1, 0.05, 100000, ...
			0, 100000, 0, 100000, 0, 100000, 0, 100000, 0, 100000, ...
			0, 100000, 0, 100000, 0, 100000, 0, 100000, 0, 100000, ...
			0, 100000, 0, 100000, 0, 100000, 0, 100000, 0, 100000, ...
			0, 100000, 0, 100000, 0, 100000, 0, 100000, 0, 100000, ...
			0, 100000, 0, 100000, 0, 100000, 0];
	elseif strcmp(varargin{1},'variablenames'),
		% Return variable names in cell-array
		output = {'IGF_on', 'HRG_on', 'BYL719_on', 'pi3kbi_on', 'igfri_on', 'her3i_on', 'pdk1i_on', 'pprexi_on', 'rac1i_on', 'ndrg1i_on', ...
			'sgk1i_on', 'sgk3i_on', 'akti_on', 'rasi_on', 'rafi_on', 'meki_on', 'erki_on', 'gsk3i_on', 'mtorc1i_on', 'foxo3i_on', ...
			'myci_on', 'cdi_on', 'cei_on', 'e2fi_on', 'p21i_on', 'eri_on', 's6ki_on', 'phosphoAkt', 'phosphoErk', 'phosphoHER3', ...
			'phosphoS6', 'phosphoS6K', 'phosphoFOXO3', 'phosphoIGFR', 'phosphoRB', 'phosphoSGK1', 'phosphoSGK3', 'phosphoGSK3', 'phosphoNDRG1', 'phosphomGAB', ...
			'actmTORC1', 'phosphoER', 'activeCd', 'activeE2F', 'totalSGK3', 'totalAkt', 'totalErk', 'totalHER3', 'totalS6', 'totalS6K', ...
			'totalCd', 'totalCe', 'totalp21', 'totalcMyc', 'totalRB', 'totalE2F', 'totalER', 'totalCDK4', 'totalCDK2', 'totalIGFR', ...
			'totalPI3Ka', 'totalPI3Kb', 'totalPIP', 'totalGAB', 'totalPDK1', 'totalPPREX1', 'totalRac1', 'totalSGK1', 'totalFOXO3', 'totalRas', ...
			'totalRaf', 'totalMEK', 'totalNDRG1'};
	elseif strcmp(varargin{1},'variableformulas'),
		% Return variable formulas in cell-array
		output = {'piecewiseIQM(1,ge(time,IGF_on_time),0)', 'piecewiseIQM(1,ge(time,HRG_on_time),0)', 'piecewiseIQM(1,ge(time,BYL719_on_time),0)', 'piecewiseIQM(1,ge(time,pi3kbi_on_time),0)', 'piecewiseIQM(1,ge(time,igfri_on_time),0)', 'piecewiseIQM(1,ge(time,her3i_on_time),0)', 'piecewiseIQM(1,ge(time,pdk1i_on_time),0)', 'piecewiseIQM(1,ge(time,pprexi_on_time),0)', 'piecewiseIQM(1,ge(time,rac1i_on_time),0)', 'piecewiseIQM(1,ge(time,ndrg1i_on_time),0)', ...
			'piecewiseIQM(1,ge(time,sgk1i_on_time),0)', 'piecewiseIQM(1,ge(time,sgk3i_on_time),0)', 'piecewiseIQM(1,ge(time,akti_on_time),0)', 'piecewiseIQM(1,ge(time,rasi_on_time),0)', 'piecewiseIQM(1,ge(time,rafi_on_time),0)', 'piecewiseIQM(1,ge(time,meki_on_time),0)', 'piecewiseIQM(1,ge(time,erki_on_time),0)', 'piecewiseIQM(1,ge(time,gsk3i_on_time),0)', 'piecewiseIQM(1,ge(time,mtorc1i_on_time),0)', 'piecewiseIQM(1,ge(time,foxo3i_on_time),0)', ...
			'piecewiseIQM(1,ge(time,myci_on_time),0)', 'piecewiseIQM(1,ge(time,cdi_on_time),0)', 'piecewiseIQM(1,ge(time,cei_on_time),0)', 'piecewiseIQM(1,ge(time,e2fi_on_time),0)', 'piecewiseIQM(1,ge(time,p21i_on_time),0)', 'piecewiseIQM(1,ge(time,eri_on_time),0)', 'piecewiseIQM(1,ge(time,s6ki_on_time),0)', 'pAkt', 'pErk', 'pHER3L', ...
			'pS6', 'pS6K', 'pFOXO3', 'IRp', 'pRB+ppRB', 'pSGK1', 'pSGK3', 'pGSK3', 'pNDRG1', 'mGABp', ...
			'amTORC1', 'pER', 'K4Da+K4Da_p21', 'E2F', 'SGK3+pSGK3', 'Akt+pAkt', 'Erk+pErk', 'HER3+HER3L+pHER3L+iHER3L+pHER3L_PI3Ka+pHER3L_PI3Kb', 'S6+pS6', 'S6K+pS6K', ...
			'Cd+K4D+K4Da+K4Da_p21', 'Ce+K2E+K2Ea+K2Ea_p21', 'p21+K4Da_p21+K2Ea_p21+p_p21', 'cMyc', 'RB+pRB+ppRB+E2FRB', 'E2F+E2FRB', 'ER+pER', 'CDK4+K4D+K4Da+K4Da_p21', 'CDK2+K2E+K2Ea+K2Ea_p21', 'IR+IRL+IRp+IRi+IRp_PI3Ka+IRp_PI3Kb', ...
			'PI3Ka+IRp_PI3Ka+pHER3L_PI3Ka', 'PI3Kb+IRp_PI3Kb+pHER3L_PI3Kb', 'PIP2+PIP3', 'GAB+mGABp', 'PDK1+mPDK1', 'PREX1+mPREX1', 'dRac1+tRac1', 'SGK1+pSGK1', 'FOXO3+pFOXO3', 'dRas+tRas', ...
			'Raf+aaRaf', 'Mek+pMek', 'NDRG1+pNDRG1'};
	else
		error('Wrong input arguments! Please read the help text to the ODE file.');
	end
	output = output(:);
	return
elseif nargin == 2,
	time = varargin{1};
	statevector = varargin{2};
elseif nargin == 3,
	time = varargin{1};
	statevector = varargin{2};
	parameterValuesNew = varargin{3};
	if length(parameterValuesNew) ~= 197,
		parameterValuesNew = [];
	end
elseif nargin == 4,
	time = varargin{1};
	statevector = varargin{2};
	parameterValuesNew = varargin{4};
else
	error('Wrong input arguments! Please read the help text to the ODE file.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STATES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IGF = statevector(1);
IR = statevector(2);
IRL = statevector(3);
IRp = statevector(4);
IRi = statevector(5);
PI3Ka = statevector(6);
PI3Kb = statevector(7);
IRp_PI3Ka = statevector(8);
IRp_PI3Kb = statevector(9);
pHER3L_PI3Ka = statevector(10);
pHER3L_PI3Kb = statevector(11);
PIP3 = statevector(12);
PIP2 = statevector(13);
PDK1 = statevector(14);
mPDK1 = statevector(15);
GAB = statevector(16);
mGABp = statevector(17);
PREX1 = statevector(18);
mPREX1 = statevector(19);
dRac1 = statevector(20);
tRac1 = statevector(21);
Akt = statevector(22);
pAkt = statevector(23);
SGK1 = statevector(24);
pSGK1 = statevector(25);
SGK3 = statevector(26);
pSGK3 = statevector(27);
GSK3 = statevector(28);
pGSK3 = statevector(29);
mTORC1 = statevector(30);
amTORC1 = statevector(31);
FOXO3 = statevector(32);
pFOXO3 = statevector(33);
NDRG1 = statevector(34);
pNDRG1 = statevector(35);
S6K = statevector(36);
pS6K = statevector(37);
S6 = statevector(38);
pS6 = statevector(39);
dRas = statevector(40);
tRas = statevector(41);
Raf = statevector(42);
aaRaf = statevector(43);
Mek = statevector(44);
pMek = statevector(45);
Erk = statevector(46);
pErk = statevector(47);
HER3 = statevector(48);
HRG = statevector(49);
HER3L = statevector(50);
pHER3L = statevector(51);
iHER3L = statevector(52);
ER = statevector(53);
pER = statevector(54);
RB = statevector(55);
pRB = statevector(56);
ppRB = statevector(57);
E2F = statevector(58);
E2FRB = statevector(59);
Cd = statevector(60);
CDK4 = statevector(61);
K4D = statevector(62);
K4Da = statevector(63);
Ce = statevector(64);
CDK2 = statevector(65);
K2E = statevector(66);
K2Ea = statevector(67);
p21 = statevector(68);
K4Da_p21 = statevector(69);
K2Ea_p21 = statevector(70);
cMyc = statevector(71);
p_p21 = statevector(72);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(parameterValuesNew),
	ka_rt_001 = 0.0831764;
	kd_rt_001 = 0.0141254;
	kc1_rt_002 = 0.108393;
	vm_rt_002 = 26.9153;
	kc1_rt_003 = 23.4423;
	vm_rt_003 = 2.69153;
	kc2_rt_004 = 0.229087;
	vm_rt_004 = 2.75423;
	Ki_rt_004 = 0.00331131;
	kc2_rt_005 = 0.00645654;
	vm_rt_005 = 0.724436;
	kc2_rt_006 = 316.228;
	vm_rt_006 = 0.0128825;
	kc2_rt_007 = 28.1838;
	vm_rt_007 = 0.0295121;
	alpha_rt_008a = 0.0162181;
	alpha_rt_008b = 316.228;
	alpha_rt_008c = 0.11749;
	kc2_rt_010 = 7.94328;
	Ki_rt_010 = 128.825;
	vm_rt_010 = 50.1187;
	kc2_rt_008 = 0.0707946;
	kc2_rt_009 = 288.403;
	Km_rt_008 = 2.81838;
	vm_rt_011 = 0.954993;
	kc2_rt_011 = 28.8403;
	kc2_rt_012 = 0.218776;
	vm_rt_012 = 0.616595;
	kc2_rt_013 = 1;
	vm_rt_013 = 64.5654;
	kc2_rt_014 = 0.436516;
	vm_rt_014 = 0.112202;
	ki_rt_014 = 281.838;
	kc2_rt_015 = 2.29087;
	vm_rt_015 = 100;
	kc2_rt_016 = 1.31826;
	vm_rt_016 = 0.128825;
	kc2_rt_016a = 316.228;
	vm_rt_016a = 2.04174;
	kc2_rt_017a = 0.111429;
	kc2_rt_017b = 13.1826;
	alpha_rt_017 = 0.00988553;
	vm_rt_017 = 147.911;
	kc2_rt_018a = 316.228;
	kc2_rt_018b = 316.228;
	vm_rt_018 = 0.00213796;
	kc2_rt_019 = 102.329;
	vm_rt_019 = 263.027;
	kc2_rt_020a = 1.02329;
	kc2_rt_020b = 154.882;
	vm_rt_020 = 316.228;
	kc2_rt_021a = 41.6869;
	kc2_rt_021b = 0.0416869;
	kc2_rt_021c = 316.228;
	vm_rt_021 = 0.01;
	Ki_rt_021 = 0.389045;
	Ki_rt_022 = 316.228;
	kc2_rt_022 = 0.00550808;
	Km_rt_022 = 316.228;
	kc2_rt_023 = 316.228;
	Km_rt_023 = 2.5704;
	vm_rt_023 = 316.228;
	alpha_rt_023 = 316.228;
	kc2_rt_024 = 316.228;
	vm_rt_024 = 194.984;
	vs_rt_025 = 2.95121;
	Km_rt_025 = 87.0964;
	kdeg_rt_026 = 3.63078;
	vs_rt_027 = 31.6228;
	kc2_rt_029 = 22.9087;
	vm_rt_029 = 316.228;
	kdeg_rt_030 = 0.17378;
	Km_rt_030 = 0.323594;
	Km_rt_031 = 218.776;
	vs_rt_031 = 184.077;
	deg_rt_031 = 0.0891251;
	alpha_rt_031 = 316.228;
	kd_rt_033 = 0.0851138;
	ka_rt_033 = 0.0537032;
	alpha_rt_034_a = 0.102329;
	kc1_rt_034_a = 10.617;
	vm_rt_034_a = 295.121;
	kc1_rt_034 = 0.316228;
	vm_rt_034 = 1.34896;
	Km_rt_035 = 12.8825;
	vs_rt_035b = 12.5893;
	deg_rt_035 = 208.93;
	vm_rt_037 = 0.00288403;
	kc2_rt_037 = 0.0186209;
	mtPIK3CA = 0.112202;
	vs_cc_001 = 10.7152;
	kc1_cc_003 = 0.0831764;
	vm_cc_003 = 0.00416869;
	kc2_cc_005 = 239.883;
	vm_cc_005 = 0.562341;
	tr_cc_007a = 0.0616595;
	Km_cc_007a = 13.1826;
	Km_cc_007b = 0.138038;
	tr_cc_007b = 316.228;
	tr_cc_007c = 0.0371535;
	kdeg_cc_008a = 173.78;
	kdeg_cc_008b = 79.4328;
	Km_cc_008 = 0.0177828;
	ka_cc_009 = 2.44343;
	kd_cc_009 = 0.245471;
	vs_cc_010c = 0.234423;
	kdeg_cc_011 = 0.0125893;
	Km_cc_011 = 0.0239883;
	kc2_cc_011 = 51.88;
	Km_cc_010b = 0.00288403;
	ka_cc_012 = 0.01;
	kd_cc_012 = 0.00954993;
	kc1_cc_013 = 0.0286418;
	kc2_cc_013a = 0.732825;
	vm_cc_013b = 237.137;
	ka_cc_014 = 0.691831;
	kc2_cc_014a = 0.0245471;
	kd_cc_014 = 0.301995;
	vs_cc_015 = 0.0269153;
	kdeg_cc_015 = 316.228;
	Km_cc_015 = 0.0245471;
	ka_cc_017 = 234.423;
	kd_cc_017 = 7.24436;
	kc1_cc_018a = 0.0218776;
	vm_cc_018b = 0.758578;
	ka_cc_019 = 2.5704;
	kd_cc_019 = 2.29087;
	vs_cc_020 = 1.51356;
	Km_cc_020 = 316.228;
	deg_cc_021 = 0.00724436;
	kc2_cc_021a = 81.2831;
	kc2_cc_021b = 316.228;
	Km_cc_021a = 0.213796;
	Km_cc_021b = 0.0588844;
	Km_cc_025a = 4.0738;
	Km_cc_025b = 0.0562341;
	vs_cc_025a = 0.398107;
	vs_cc_025b = 245.471;
	deg_cc_025 = 0.125893;
	kc1_cc_026 = 0.0552077;
	a0 = 1;
	b0 = 1;
	PTEN = 100;
	IGF_on_time = 2000;
	HRG_on_time = 2000;
	BYL719_on_time = 100000;
	BYL719 = 0;
	w_drg = 1;
	Ki_drg = 0.05;
	pi3kbi_on_time = 100000;
	pi3kbi = 0;
	igfri_on_time = 100000;
	igfri = 0;
	her3i_on_time = 100000;
	her3i = 0;
	pdk1i_on_time = 100000;
	pdk1i = 0;
	pprexi_on_time = 100000;
	pprexi = 0;
	rac1i_on_time = 100000;
	rac1i = 0;
	ndrg1i_on_time = 100000;
	ndrg1i = 0;
	sgk1i_on_time = 100000;
	sgk1i = 0;
	sgk3i_on_time = 100000;
	sgk3i = 0;
	akti_on_time = 100000;
	akti = 0;
	rasi_on_time = 100000;
	rasi = 0;
	rafi_on_time = 100000;
	rafi = 0;
	meki_on_time = 100000;
	meki = 0;
	erki_on_time = 100000;
	erki = 0;
	gsk3i_on_time = 100000;
	gsk3i = 0;
	mtorc1i_on_time = 100000;
	mtorc1i = 0;
	foxo3i_on_time = 100000;
	foxo3i = 0;
	myci_on_time = 100000;
	myci = 0;
	cdi_on_time = 100000;
	cdi = 0;
	cei_on_time = 100000;
	cei = 0;
	e2fi_on_time = 100000;
	e2fi = 0;
	p21i_on_time = 100000;
	p21i = 0;
	eri_on_time = 100000;
	eri = 0;
	s6ki_on_time = 100000;
	s6ki = 0;
else
	ka_rt_001 = parameterValuesNew(1);
	kd_rt_001 = parameterValuesNew(2);
	kc1_rt_002 = parameterValuesNew(3);
	vm_rt_002 = parameterValuesNew(4);
	kc1_rt_003 = parameterValuesNew(5);
	vm_rt_003 = parameterValuesNew(6);
	kc2_rt_004 = parameterValuesNew(7);
	vm_rt_004 = parameterValuesNew(8);
	Ki_rt_004 = parameterValuesNew(9);
	kc2_rt_005 = parameterValuesNew(10);
	vm_rt_005 = parameterValuesNew(11);
	kc2_rt_006 = parameterValuesNew(12);
	vm_rt_006 = parameterValuesNew(13);
	kc2_rt_007 = parameterValuesNew(14);
	vm_rt_007 = parameterValuesNew(15);
	alpha_rt_008a = parameterValuesNew(16);
	alpha_rt_008b = parameterValuesNew(17);
	alpha_rt_008c = parameterValuesNew(18);
	kc2_rt_010 = parameterValuesNew(19);
	Ki_rt_010 = parameterValuesNew(20);
	vm_rt_010 = parameterValuesNew(21);
	kc2_rt_008 = parameterValuesNew(22);
	kc2_rt_009 = parameterValuesNew(23);
	Km_rt_008 = parameterValuesNew(24);
	vm_rt_011 = parameterValuesNew(25);
	kc2_rt_011 = parameterValuesNew(26);
	kc2_rt_012 = parameterValuesNew(27);
	vm_rt_012 = parameterValuesNew(28);
	kc2_rt_013 = parameterValuesNew(29);
	vm_rt_013 = parameterValuesNew(30);
	kc2_rt_014 = parameterValuesNew(31);
	vm_rt_014 = parameterValuesNew(32);
	ki_rt_014 = parameterValuesNew(33);
	kc2_rt_015 = parameterValuesNew(34);
	vm_rt_015 = parameterValuesNew(35);
	kc2_rt_016 = parameterValuesNew(36);
	vm_rt_016 = parameterValuesNew(37);
	kc2_rt_016a = parameterValuesNew(38);
	vm_rt_016a = parameterValuesNew(39);
	kc2_rt_017a = parameterValuesNew(40);
	kc2_rt_017b = parameterValuesNew(41);
	alpha_rt_017 = parameterValuesNew(42);
	vm_rt_017 = parameterValuesNew(43);
	kc2_rt_018a = parameterValuesNew(44);
	kc2_rt_018b = parameterValuesNew(45);
	vm_rt_018 = parameterValuesNew(46);
	kc2_rt_019 = parameterValuesNew(47);
	vm_rt_019 = parameterValuesNew(48);
	kc2_rt_020a = parameterValuesNew(49);
	kc2_rt_020b = parameterValuesNew(50);
	vm_rt_020 = parameterValuesNew(51);
	kc2_rt_021a = parameterValuesNew(52);
	kc2_rt_021b = parameterValuesNew(53);
	kc2_rt_021c = parameterValuesNew(54);
	vm_rt_021 = parameterValuesNew(55);
	Ki_rt_021 = parameterValuesNew(56);
	Ki_rt_022 = parameterValuesNew(57);
	kc2_rt_022 = parameterValuesNew(58);
	Km_rt_022 = parameterValuesNew(59);
	kc2_rt_023 = parameterValuesNew(60);
	Km_rt_023 = parameterValuesNew(61);
	vm_rt_023 = parameterValuesNew(62);
	alpha_rt_023 = parameterValuesNew(63);
	kc2_rt_024 = parameterValuesNew(64);
	vm_rt_024 = parameterValuesNew(65);
	vs_rt_025 = parameterValuesNew(66);
	Km_rt_025 = parameterValuesNew(67);
	kdeg_rt_026 = parameterValuesNew(68);
	vs_rt_027 = parameterValuesNew(69);
	kc2_rt_029 = parameterValuesNew(70);
	vm_rt_029 = parameterValuesNew(71);
	kdeg_rt_030 = parameterValuesNew(72);
	Km_rt_030 = parameterValuesNew(73);
	Km_rt_031 = parameterValuesNew(74);
	vs_rt_031 = parameterValuesNew(75);
	deg_rt_031 = parameterValuesNew(76);
	alpha_rt_031 = parameterValuesNew(77);
	kd_rt_033 = parameterValuesNew(78);
	ka_rt_033 = parameterValuesNew(79);
	alpha_rt_034_a = parameterValuesNew(80);
	kc1_rt_034_a = parameterValuesNew(81);
	vm_rt_034_a = parameterValuesNew(82);
	kc1_rt_034 = parameterValuesNew(83);
	vm_rt_034 = parameterValuesNew(84);
	Km_rt_035 = parameterValuesNew(85);
	vs_rt_035b = parameterValuesNew(86);
	deg_rt_035 = parameterValuesNew(87);
	vm_rt_037 = parameterValuesNew(88);
	kc2_rt_037 = parameterValuesNew(89);
	mtPIK3CA = parameterValuesNew(90);
	vs_cc_001 = parameterValuesNew(91);
	kc1_cc_003 = parameterValuesNew(92);
	vm_cc_003 = parameterValuesNew(93);
	kc2_cc_005 = parameterValuesNew(94);
	vm_cc_005 = parameterValuesNew(95);
	tr_cc_007a = parameterValuesNew(96);
	Km_cc_007a = parameterValuesNew(97);
	Km_cc_007b = parameterValuesNew(98);
	tr_cc_007b = parameterValuesNew(99);
	tr_cc_007c = parameterValuesNew(100);
	kdeg_cc_008a = parameterValuesNew(101);
	kdeg_cc_008b = parameterValuesNew(102);
	Km_cc_008 = parameterValuesNew(103);
	ka_cc_009 = parameterValuesNew(104);
	kd_cc_009 = parameterValuesNew(105);
	vs_cc_010c = parameterValuesNew(106);
	kdeg_cc_011 = parameterValuesNew(107);
	Km_cc_011 = parameterValuesNew(108);
	kc2_cc_011 = parameterValuesNew(109);
	Km_cc_010b = parameterValuesNew(110);
	ka_cc_012 = parameterValuesNew(111);
	kd_cc_012 = parameterValuesNew(112);
	kc1_cc_013 = parameterValuesNew(113);
	kc2_cc_013a = parameterValuesNew(114);
	vm_cc_013b = parameterValuesNew(115);
	ka_cc_014 = parameterValuesNew(116);
	kc2_cc_014a = parameterValuesNew(117);
	kd_cc_014 = parameterValuesNew(118);
	vs_cc_015 = parameterValuesNew(119);
	kdeg_cc_015 = parameterValuesNew(120);
	Km_cc_015 = parameterValuesNew(121);
	ka_cc_017 = parameterValuesNew(122);
	kd_cc_017 = parameterValuesNew(123);
	kc1_cc_018a = parameterValuesNew(124);
	vm_cc_018b = parameterValuesNew(125);
	ka_cc_019 = parameterValuesNew(126);
	kd_cc_019 = parameterValuesNew(127);
	vs_cc_020 = parameterValuesNew(128);
	Km_cc_020 = parameterValuesNew(129);
	deg_cc_021 = parameterValuesNew(130);
	kc2_cc_021a = parameterValuesNew(131);
	kc2_cc_021b = parameterValuesNew(132);
	Km_cc_021a = parameterValuesNew(133);
	Km_cc_021b = parameterValuesNew(134);
	Km_cc_025a = parameterValuesNew(135);
	Km_cc_025b = parameterValuesNew(136);
	vs_cc_025a = parameterValuesNew(137);
	vs_cc_025b = parameterValuesNew(138);
	deg_cc_025 = parameterValuesNew(139);
	kc1_cc_026 = parameterValuesNew(140);
	a0 = parameterValuesNew(141);
	b0 = parameterValuesNew(142);
	PTEN = parameterValuesNew(143);
	IGF_on_time = parameterValuesNew(144);
	HRG_on_time = parameterValuesNew(145);
	BYL719_on_time = parameterValuesNew(146);
	BYL719 = parameterValuesNew(147);
	w_drg = parameterValuesNew(148);
	Ki_drg = parameterValuesNew(149);
	pi3kbi_on_time = parameterValuesNew(150);
	pi3kbi = parameterValuesNew(151);
	igfri_on_time = parameterValuesNew(152);
	igfri = parameterValuesNew(153);
	her3i_on_time = parameterValuesNew(154);
	her3i = parameterValuesNew(155);
	pdk1i_on_time = parameterValuesNew(156);
	pdk1i = parameterValuesNew(157);
	pprexi_on_time = parameterValuesNew(158);
	pprexi = parameterValuesNew(159);
	rac1i_on_time = parameterValuesNew(160);
	rac1i = parameterValuesNew(161);
	ndrg1i_on_time = parameterValuesNew(162);
	ndrg1i = parameterValuesNew(163);
	sgk1i_on_time = parameterValuesNew(164);
	sgk1i = parameterValuesNew(165);
	sgk3i_on_time = parameterValuesNew(166);
	sgk3i = parameterValuesNew(167);
	akti_on_time = parameterValuesNew(168);
	akti = parameterValuesNew(169);
	rasi_on_time = parameterValuesNew(170);
	rasi = parameterValuesNew(171);
	rafi_on_time = parameterValuesNew(172);
	rafi = parameterValuesNew(173);
	meki_on_time = parameterValuesNew(174);
	meki = parameterValuesNew(175);
	erki_on_time = parameterValuesNew(176);
	erki = parameterValuesNew(177);
	gsk3i_on_time = parameterValuesNew(178);
	gsk3i = parameterValuesNew(179);
	mtorc1i_on_time = parameterValuesNew(180);
	mtorc1i = parameterValuesNew(181);
	foxo3i_on_time = parameterValuesNew(182);
	foxo3i = parameterValuesNew(183);
	myci_on_time = parameterValuesNew(184);
	myci = parameterValuesNew(185);
	cdi_on_time = parameterValuesNew(186);
	cdi = parameterValuesNew(187);
	cei_on_time = parameterValuesNew(188);
	cei = parameterValuesNew(189);
	e2fi_on_time = parameterValuesNew(190);
	e2fi = parameterValuesNew(191);
	p21i_on_time = parameterValuesNew(192);
	p21i = parameterValuesNew(193);
	eri_on_time = parameterValuesNew(194);
	eri = parameterValuesNew(195);
	s6ki_on_time = parameterValuesNew(196);
	s6ki = parameterValuesNew(197);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IGF_on = piecewiseIQM(1,ge(time,IGF_on_time),0);
HRG_on = piecewiseIQM(1,ge(time,HRG_on_time),0);
BYL719_on = piecewiseIQM(1,ge(time,BYL719_on_time),0);
pi3kbi_on = piecewiseIQM(1,ge(time,pi3kbi_on_time),0);
igfri_on = piecewiseIQM(1,ge(time,igfri_on_time),0);
her3i_on = piecewiseIQM(1,ge(time,her3i_on_time),0);
pdk1i_on = piecewiseIQM(1,ge(time,pdk1i_on_time),0);
pprexi_on = piecewiseIQM(1,ge(time,pprexi_on_time),0);
rac1i_on = piecewiseIQM(1,ge(time,rac1i_on_time),0);
ndrg1i_on = piecewiseIQM(1,ge(time,ndrg1i_on_time),0);
sgk1i_on = piecewiseIQM(1,ge(time,sgk1i_on_time),0);
sgk3i_on = piecewiseIQM(1,ge(time,sgk3i_on_time),0);
akti_on = piecewiseIQM(1,ge(time,akti_on_time),0);
rasi_on = piecewiseIQM(1,ge(time,rasi_on_time),0);
rafi_on = piecewiseIQM(1,ge(time,rafi_on_time),0);
meki_on = piecewiseIQM(1,ge(time,meki_on_time),0);
erki_on = piecewiseIQM(1,ge(time,erki_on_time),0);
gsk3i_on = piecewiseIQM(1,ge(time,gsk3i_on_time),0);
mtorc1i_on = piecewiseIQM(1,ge(time,mtorc1i_on_time),0);
foxo3i_on = piecewiseIQM(1,ge(time,foxo3i_on_time),0);
myci_on = piecewiseIQM(1,ge(time,myci_on_time),0);
cdi_on = piecewiseIQM(1,ge(time,cdi_on_time),0);
cei_on = piecewiseIQM(1,ge(time,cei_on_time),0);
e2fi_on = piecewiseIQM(1,ge(time,e2fi_on_time),0);
p21i_on = piecewiseIQM(1,ge(time,p21i_on_time),0);
eri_on = piecewiseIQM(1,ge(time,eri_on_time),0);
s6ki_on = piecewiseIQM(1,ge(time,s6ki_on_time),0);
phosphoAkt = pAkt;
phosphoErk = pErk;
phosphoHER3 = pHER3L;
phosphoS6 = pS6;
phosphoS6K = pS6K;
phosphoFOXO3 = pFOXO3;
phosphoIGFR = IRp;
phosphoRB = pRB+ppRB;
phosphoSGK1 = pSGK1;
phosphoSGK3 = pSGK3;
phosphoGSK3 = pGSK3;
phosphoNDRG1 = pNDRG1;
phosphomGAB = mGABp;
actmTORC1 = amTORC1;
phosphoER = pER;
activeCd = K4Da+K4Da_p21;
activeE2F = E2F;
totalSGK3 = SGK3+pSGK3;
totalAkt = Akt+pAkt;
totalErk = Erk+pErk;
totalHER3 = HER3+HER3L+pHER3L+iHER3L+pHER3L_PI3Ka+pHER3L_PI3Kb;
totalS6 = S6+pS6;
totalS6K = S6K+pS6K;
totalCd = Cd+K4D+K4Da+K4Da_p21;
totalCe = Ce+K2E+K2Ea+K2Ea_p21;
totalp21 = p21+K4Da_p21+K2Ea_p21+p_p21;
totalcMyc = cMyc;
totalRB = RB+pRB+ppRB+E2FRB;
totalE2F = E2F+E2FRB;
totalER = ER+pER;
totalCDK4 = CDK4+K4D+K4Da+K4Da_p21;
totalCDK2 = CDK2+K2E+K2Ea+K2Ea_p21;
totalIGFR = IR+IRL+IRp+IRi+IRp_PI3Ka+IRp_PI3Kb;
totalPI3Ka = PI3Ka+IRp_PI3Ka+pHER3L_PI3Ka;
totalPI3Kb = PI3Kb+IRp_PI3Kb+pHER3L_PI3Kb;
totalPIP = PIP2+PIP3;
totalGAB = GAB+mGABp;
totalPDK1 = PDK1+mPDK1;
totalPPREX1 = PREX1+mPREX1;
totalRac1 = dRac1+tRac1;
totalSGK1 = SGK1+pSGK1;
totalFOXO3 = FOXO3+pFOXO3;
totalRas = dRas+tRas;
totalRaf = Raf+aaRaf;
totalMEK = Mek+pMek;
totalNDRG1 = NDRG1+pNDRG1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REACTION KINETICS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rt_001 = ka_rt_001*IR*IGF*IGF_on-kd_rt_001*IRL;
rt_002 = kc1_rt_002*IRL*(1-w_drg*igfri_on*igfri/(Ki_drg+igfri))-vm_rt_002*IRp;
rt_003 = kc1_rt_003*IRp-vm_rt_003*IRi;
rt_004 = kc2_rt_004*IRp*PI3Ka/(1+Ki_rt_004*pS6K*(1-w_drg*s6ki_on*s6ki/(Ki_drg+s6ki)))-vm_rt_004*IRp_PI3Ka;
rt_005 = kc2_rt_005*IRp*PI3Kb/(1+Ki_rt_004*pS6K*(1-w_drg*s6ki_on*s6ki/(Ki_drg+s6ki)))-vm_rt_005*IRp_PI3Kb;
rt_006 = kc2_rt_006*pHER3L*PI3Ka-vm_rt_006*pHER3L_PI3Ka;
rt_007 = kc2_rt_007*pHER3L*PI3Kb-vm_rt_007*pHER3L_PI3Kb;
rt_008 = PIP2*kc2_rt_008/(Km_rt_008+PIP2)*((mtPIK3CA+(IRp_PI3Ka+pHER3L_PI3Ka)*(1+alpha_rt_008a*mGABp+alpha_rt_008b*tRas*(1-w_drg*rasi_on*rasi/(Ki_drg+rasi))))*(1-w_drg*BYL719_on*BYL719/(Ki_drg+BYL719))+(IRp_PI3Kb+pHER3L_PI3Kb)*(1+alpha_rt_008a*mGABp+alpha_rt_008c*tRac1*(1-w_drg*rac1i_on*rac1i/(Ki_drg+rac1i)))*(1-w_drg*pi3kbi_on*pi3kbi/(Ki_drg+pi3kbi)));
rt_009 = kc2_rt_009*PIP3*PTEN;
rt_010 = kc2_rt_010*GAB*PIP3/(1+Ki_rt_010*pErk*(1-w_drg*erki_on*erki/(Ki_drg+erki)))-vm_rt_010*mGABp;
rt_011 = kc2_rt_011*PDK1*PIP3-vm_rt_011*mPDK1;
rt_012 = kc2_rt_012*PREX1*PIP3-vm_rt_012*mPREX1;
rt_013 = kc2_rt_013*mPREX1*dRac1*(1-w_drg*pprexi_on*pprexi/(Ki_drg+pprexi))-vm_rt_013*tRac1;
rt_014 = kc2_rt_014*mPDK1*Akt*(1-w_drg*pdk1i_on*pdk1i/(Ki_drg+pdk1i))/(1+ki_rt_014*ppRB)-vm_rt_014*pAkt;
rt_015 = kc2_rt_015*SGK1*mPDK1*(1-w_drg*pdk1i_on*pdk1i/(Ki_drg+pdk1i))/(1+ki_rt_014*ppRB)-vm_rt_015*pSGK1;
rt_016 = kc2_rt_016*mPDK1*SGK3*(1-w_drg*pdk1i_on*pdk1i/(Ki_drg+pdk1i))/(1+ki_rt_014*ppRB)-vm_rt_016*pSGK3;
rt_016a = kc2_rt_016a*pAkt*GSK3*(1-w_drg*akti_on*akti/(Ki_drg+akti))-vm_rt_016a*pGSK3;
rt_017 = mTORC1*(kc2_rt_017a*pAkt*(1-w_drg*akti_on*akti/(Ki_drg+akti))+kc2_rt_017b*pSGK1*(1-w_drg*sgk1i_on*sgk1i/(Ki_drg+sgk1i)))*(1+alpha_rt_017*K4Da)-vm_rt_017*amTORC1;
rt_018 = FOXO3*(kc2_rt_018a*pAkt*(1-w_drg*akti_on*akti/(Ki_drg+akti))+kc2_rt_018b*pSGK1*(1-w_drg*sgk1i_on*sgk1i/(Ki_drg+sgk1i)))-vm_rt_018*pFOXO3;
rt_019 = kc2_rt_019*S6K*amTORC1*(1-w_drg*mtorc1i_on*mtorc1i/(Ki_drg+mtorc1i))-vm_rt_019*pS6K;
rt_020 = S6*kc2_rt_020a*pS6K-vm_rt_020*pS6;
rt_021 = dRas*(kc2_rt_021a*pHER3L+kc2_rt_021b*IRp/(1+Ki_rt_004*pS6K*(1-w_drg*s6ki_on*s6ki/(Ki_drg+s6ki)))+kc2_rt_021c*mGABp)/(1+Ki_rt_021*pErk*(1-w_drg*erki_on*erki/(Ki_drg+erki)))-vm_rt_021*tRas;
rt_022 = kc2_rt_022*tRas*Raf*(1-w_drg*rasi_on*rasi/(Ki_drg+rasi))/(Km_rt_022+Raf)/(1+Ki_rt_022*pAkt*(1-w_drg*akti_on*akti/(Ki_drg+akti)))-kc2_rt_022*aaRaf;
rt_023 = kc2_rt_023*(1+alpha_rt_023*tRac1*(1-w_drg*rac1i_on*rac1i/(Ki_drg+rac1i)))*aaRaf*(1-w_drg*rafi_on*rafi/(Ki_drg+rafi))*Mek/(Km_rt_023+Mek)-vm_rt_023*pMek;
rt_024 = kc2_rt_024*Erk*pMek*(1-w_drg*meki_on*meki/(Ki_drg+meki))-vm_rt_024*pErk;
rt_025 = vs_rt_025*(ER+pER)*(1-w_drg*eri_on*eri/(Ki_drg+eri))/(Km_rt_025+(ER+pER));
rt_026 = kdeg_rt_026*SGK3;
rt_027 = vs_rt_027;
rt_028 = (vs_rt_027/50)*NDRG1;
rt_029 = kc2_rt_029*NDRG1*(pSGK1*(1-w_drg*sgk1i_on*sgk1i/(Ki_drg+sgk1i))+pSGK3*(1-w_drg*sgk3i_on*sgk3i/(Ki_drg+sgk3i)))-vm_rt_029*pNDRG1;
rt_030 = kdeg_rt_030*pNDRG1*GSK3/(Km_rt_030+pNDRG1);
rt_031 = vs_rt_031*FOXO3*(1-w_drg*foxo3i_on*foxo3i/(Ki_drg+foxo3i))/(Km_rt_031+FOXO3);
rt_032 = deg_rt_031*HER3*(1+alpha_rt_031*(NDRG1+pNDRG1)*(1-w_drg*ndrg1i_on*ndrg1i/(Ki_drg+ndrg1i)));
rt_033 = ka_rt_033*HER3*HRG*HRG_on-kd_rt_033*HER3L;
rt_034 = kc1_rt_034*HER3L*(1-w_drg*her3i_on*her3i/(Ki_drg+her3i))-vm_rt_034*pHER3L;
rt_034_a = kc1_rt_034_a*pHER3L*(1+alpha_rt_034_a*pErk*(1-w_drg*erki_on*erki/(Ki_drg+erki)))-vm_rt_034_a*iHER3L;
rt_035 = vs_rt_035b*FOXO3*(1-w_drg*foxo3i_on*foxo3i/(Ki_drg+foxo3i))/(Km_rt_035+FOXO3);
rt_036 = deg_rt_035*ER;
rt_037 = kc2_rt_037*pErk*ER*(1-w_drg*erki_on*erki/(Ki_drg+erki))-vm_rt_037*pER;
cc_001 = vs_cc_001;
cc_002 = (vs_cc_001/100)*RB;
cc_003 = kc1_cc_003*RB*(K4Da+K4Da_p21)-vm_cc_003*pRB;
cc_005 = kc2_cc_005*K2Ea*pRB-vm_cc_005*ppRB;
cc_007 = tr_cc_007a*E2F*(1-w_drg*e2fi_on*e2fi/(Ki_drg+e2fi))/(Km_cc_007b+E2F)+tr_cc_007b*(cMyc*(1-w_drg*myci_on*myci/(Ki_drg+myci))/(Km_cc_007a+cMyc))*(E2F*(1-w_drg*e2fi_on*e2fi/(Ki_drg+e2fi))/(Km_cc_007b+E2F))+tr_cc_007c*(cMyc*(1-w_drg*myci_on*myci/(Ki_drg+myci))/(Km_cc_007a+cMyc));
cc_008 = E2F*(1-w_drg*e2fi_on*e2fi/(Ki_drg+e2fi))*(kdeg_cc_008b+kdeg_cc_008a*K2Ea)/(Km_cc_008+E2F);
cc_009 = (ka_cc_009*E2F*RB-kd_cc_009*E2FRB);
cc_010 = vs_cc_010c*amTORC1*(1-w_drg*mtorc1i_on*mtorc1i/(Ki_drg+mtorc1i))/(Km_cc_010b+amTORC1);
cc_011 = kdeg_cc_011*Cd*(1+kc2_cc_011*GSK3*(1-w_drg*gsk3i_on*gsk3i/(Ki_drg+gsk3i))/(Km_cc_011+GSK3));
cc_012 = ka_cc_012*Cd*CDK4*(1-w_drg*cdi_on*cdi/(Ki_drg+cdi))-kd_cc_012*K4D;
cc_013 = kc1_cc_013*K4D-vm_cc_013b*K4Da;
cc_013a = kc2_cc_013a*K4Da*GSK3*(1-w_drg*gsk3i_on*gsk3i/(Ki_drg+gsk3i))/(Km_cc_011+GSK3);
cc_014 = ka_cc_014*K4Da*p21*(1-w_drg*p21i_on*p21i/(Ki_drg+p21i))-kd_cc_014*K4Da_p21;
cc_014a = kc2_cc_014a*K4Da_p21*GSK3*(1-w_drg*gsk3i_on*gsk3i/(Ki_drg+gsk3i))/(Km_cc_011+GSK3);
cc_015 = vs_cc_015*E2F*(1-w_drg*e2fi_on*e2fi/(Ki_drg+e2fi))/(Km_cc_015+E2F);
cc_016 = kdeg_cc_015*Ce;
cc_017 = ka_cc_017*Ce*CDK2*(1-w_drg*cei_on*cei/(Ki_drg+cei))-kd_cc_017*K2E;
cc_018 = kc1_cc_018a*K2E-vm_cc_018b*K2Ea;
cc_019 = ka_cc_019*K2Ea*p21*(1-w_drg*p21i_on*p21i/(Ki_drg+p21i))-kd_cc_019*K2Ea_p21;
cc_020 = vs_cc_020*pErk*(1-w_drg*erki_on*erki/(Ki_drg+erki))/(Km_cc_020+pErk);
cc_021 = p21*(deg_cc_021+kc2_cc_021b*K2Ea/(Km_cc_021b+K2Ea));
cc_022 = kc2_cc_021a*pAkt*p21*(1-w_drg*akti_on*akti/(Ki_drg+akti))/(Km_cc_021a+pAkt);
cc_023 = p_p21*(deg_cc_021/10+kc2_cc_021b*K2Ea/(Km_cc_021b+K2Ea));
cc_025 = vs_cc_025a*amTORC1*(1-w_drg*mtorc1i_on*mtorc1i/(Ki_drg+mtorc1i))/(Km_cc_025a+amTORC1)+vs_cc_025b*(ER+pER)*(1-w_drg*eri_on*eri/(Ki_drg+eri))/(Km_cc_025b+(ER+pER));
cc_026 = deg_cc_025*cMyc*(1+kc1_cc_026*GSK3*(1-w_drg*gsk3i_on*gsk3i/(Ki_drg+gsk3i)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DIFFERENTIAL EQUATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IGF_dot = -rt_001;
IR_dot = -rt_001;
IRL_dot = +rt_001-rt_002;
IRp_dot = +rt_002-rt_003;
IRi_dot = +rt_003;
PI3Ka_dot = -rt_004-rt_006;
PI3Kb_dot = -rt_005-rt_007;
IRp_PI3Ka_dot = +rt_004;
IRp_PI3Kb_dot = +rt_005;
pHER3L_PI3Ka_dot = +rt_006;
pHER3L_PI3Kb_dot = +rt_007;
PIP3_dot = +rt_008-rt_009;
PIP2_dot = -rt_008+rt_009;
PDK1_dot = -rt_011;
mPDK1_dot = +rt_011;
GAB_dot = -rt_010;
mGABp_dot = +rt_010;
PREX1_dot = -rt_012;
mPREX1_dot = +rt_012;
dRac1_dot = -rt_013;
tRac1_dot = +rt_013;
Akt_dot = -rt_014;
pAkt_dot = +rt_014;
SGK1_dot = -rt_015;
pSGK1_dot = +rt_015;
SGK3_dot = -rt_016+rt_025-rt_026;
pSGK3_dot = +rt_016;
GSK3_dot = -rt_016a;
pGSK3_dot = +rt_016a;
mTORC1_dot = -rt_017;
amTORC1_dot = +rt_017;
FOXO3_dot = -rt_018;
pFOXO3_dot = +rt_018;
NDRG1_dot = +rt_027-rt_028-rt_029;
pNDRG1_dot = +rt_029-rt_030;
S6K_dot = -rt_019;
pS6K_dot = +rt_019;
S6_dot = -rt_020;
pS6_dot = +rt_020;
dRas_dot = -rt_021;
tRas_dot = +rt_021;
Raf_dot = -rt_022;
aaRaf_dot = +rt_022;
Mek_dot = -rt_023;
pMek_dot = +rt_023;
Erk_dot = -rt_024;
pErk_dot = +rt_024;
HER3_dot = +rt_031-rt_032-rt_033;
HRG_dot = -rt_033;
HER3L_dot = +rt_033-rt_034;
pHER3L_dot = +rt_034-rt_034_a;
iHER3L_dot = +rt_034_a;
ER_dot = +rt_035-rt_036-rt_037;
pER_dot = +rt_037;
RB_dot = +cc_001-cc_002-cc_003-cc_009;
pRB_dot = +cc_003-cc_005;
ppRB_dot = +cc_005;
E2F_dot = +cc_007-cc_008-cc_009;
E2FRB_dot = +cc_009;
Cd_dot = +cc_010-cc_011-cc_012;
CDK4_dot = -cc_012+cc_013a+cc_014a;
K4D_dot = +cc_012-cc_013;
K4Da_dot = +cc_013-cc_013a-cc_014;
Ce_dot = +cc_015-cc_016-cc_017;
CDK2_dot = -cc_017;
K2E_dot = +cc_017-cc_018;
K2Ea_dot = +cc_018-cc_019;
p21_dot = -cc_014-cc_019+cc_020-cc_021-cc_022;
K4Da_p21_dot = +cc_014-cc_014a;
K2Ea_p21_dot = +cc_019;
cMyc_dot = +cc_025-cc_026;
p_p21_dot = +cc_022-cc_023;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RETURN VALUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STATE ODEs
output(1) = IGF_dot;
output(2) = IR_dot;
output(3) = IRL_dot;
output(4) = IRp_dot;
output(5) = IRi_dot;
output(6) = PI3Ka_dot;
output(7) = PI3Kb_dot;
output(8) = IRp_PI3Ka_dot;
output(9) = IRp_PI3Kb_dot;
output(10) = pHER3L_PI3Ka_dot;
output(11) = pHER3L_PI3Kb_dot;
output(12) = PIP3_dot;
output(13) = PIP2_dot;
output(14) = PDK1_dot;
output(15) = mPDK1_dot;
output(16) = GAB_dot;
output(17) = mGABp_dot;
output(18) = PREX1_dot;
output(19) = mPREX1_dot;
output(20) = dRac1_dot;
output(21) = tRac1_dot;
output(22) = Akt_dot;
output(23) = pAkt_dot;
output(24) = SGK1_dot;
output(25) = pSGK1_dot;
output(26) = SGK3_dot;
output(27) = pSGK3_dot;
output(28) = GSK3_dot;
output(29) = pGSK3_dot;
output(30) = mTORC1_dot;
output(31) = amTORC1_dot;
output(32) = FOXO3_dot;
output(33) = pFOXO3_dot;
output(34) = NDRG1_dot;
output(35) = pNDRG1_dot;
output(36) = S6K_dot;
output(37) = pS6K_dot;
output(38) = S6_dot;
output(39) = pS6_dot;
output(40) = dRas_dot;
output(41) = tRas_dot;
output(42) = Raf_dot;
output(43) = aaRaf_dot;
output(44) = Mek_dot;
output(45) = pMek_dot;
output(46) = Erk_dot;
output(47) = pErk_dot;
output(48) = HER3_dot;
output(49) = HRG_dot;
output(50) = HER3L_dot;
output(51) = pHER3L_dot;
output(52) = iHER3L_dot;
output(53) = ER_dot;
output(54) = pER_dot;
output(55) = RB_dot;
output(56) = pRB_dot;
output(57) = ppRB_dot;
output(58) = E2F_dot;
output(59) = E2FRB_dot;
output(60) = Cd_dot;
output(61) = CDK4_dot;
output(62) = K4D_dot;
output(63) = K4Da_dot;
output(64) = Ce_dot;
output(65) = CDK2_dot;
output(66) = K2E_dot;
output(67) = K2Ea_dot;
output(68) = p21_dot;
output(69) = K4Da_p21_dot;
output(70) = K2Ea_p21_dot;
output(71) = cMyc_dot;
output(72) = p_p21_dot;
% return a column vector 
output = output(:);
return


