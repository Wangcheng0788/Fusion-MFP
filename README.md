# Fusion-MFP
Predicting of drug-target interactions based on the Fusion of Multiple Feature Pairs

This code is used for the algorithm named "Fusion of Multiple Feature Pairs (Fusion-MFP)" for drug-target interaction predictions, and cannot be used for commercial purposes without the permission of the authors.


The code placed in the "basic function" folder needs to be placed in the same folder as the main file "Fusion_MFP_predict.m" at runtime. At the same time, the dataset can be download from http://web.kuicr.kyoto-u.ac.jp/supp/yoshi/drugtarget/, the part of "Adjacency matrix of the gold standard drug-target interaction data" is used in the algorithm.

In the code of "feature_check", we need to use the drugs/targets descriptors. These data can be obtained according to PaDEL-Descriptor (http://padel.nus.edu.sg) and PROFEAT (http://bidd2.nus.edu.sg/), and the environment parameter "filepath_drug/filepath_target" should be changed according to the storage location of the data. Libsvm can be downloaded at https://www.csie.ntu.edu.tw/~cjlin/libsvm/.




Fusion_MFP_predict.m		-->		The main code

Data_generation.m		-->	    The function to generate positive, negative and unlabeled sets

Feature_screen.m		 -->	   The function to screen the 3 feature pairs with the lowest coincidence rate

Parameter_adjust.m		-->	  The code is used to adjust parameters in SVM (c and gamma)

Preprocess_dataset.m	-->		It is used to generate "train", "validation" and "test" for models

PSO_optimize.m			-->	    The code is used to obtain optimized weight vector based on PSO algorithm

Test_Unlabel.m			-->	    It is used to predict all the unlabeled set with proposed method

Weight_optimize.m		 -->	   The code is used to obtain optimized weight vector based on Weight-sequence

Codes in "basic function":

AUC_cal.m			  -->	        Calculate the AUC

Cluster_generate.m	-->		  Generate cluster set in cross validation

coincidence_screen.m	-->		Calculate and screen the sum of coincidence rate of feature pairs

feature_check.m			 -->	   Load and define the feature descriptor files

Fold_div_vali.m			-->	    Divide the dataset based on the ratio 3:1:1

Neg_NAME_gener.m		-->	    Generate negative sets with drug/target names, which is used for Feature_screen.m

ran_select.m		-->		      Randomly select samples
