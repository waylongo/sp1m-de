# Sequential Possibilistic One-Means Clustering with Dynamic Eta

> Wenlong Wu, James M. Keller, Thomas. A. Runkler 

# Abstract
The Possibilistic C-Means (PCM) was developed as an extension of the Fuzzy C-Means (FCM) by abandoning the membership sum-to-one constraint. In PCM, each cluster is independent of the other clusters, and can be processed separately. Thus, the Sequential Possibilistic One-Means (SP1M) was proposed to find clusters sequentially by running P1M C times. One critical problem in both PCM and SP1M is how to determine the parameter η. The Sequential Possibilistic One Means with Adaptive Eta (SP1M-AE) was developed to allow η to change during iterations. In this paper, we introduce a new dynamic adaption mechanism for the parameter η in each cluster and apply it into SP1M. The resultant algorithm, called the Sequential Possibilistic One-Means with Dynamic Eta (SP1M-DE) is shown to provide superior performance over PCM, SP1M, and SP1M-AE in determining correct clustering results.

###  File System

```matlab
/ [root]
├── functions
│   ├── knee_pt.m
│   ├── dynamic_estimate_eta.m
│   ├── sp1m.m
│   ├── random_select.m
│   └── randsrc.m
├── datasets
│   ├── clusterData_ANFIS.csv
│   └── clusterData_ANFIS_noise1.csv
├── SP1M_DE_main.m (main)
└── README.md
```

### Configurations 

Tune "*scaler*" to scale up/down the "*eta*" value if cluster size is not Gaussian shape.

Other parameters are listed in **Parameters** section in **SP1M_DE_main.m** function.

### Base Environment

MATLAB R2019a

# Reference

[1] W. Wu, J. Keller and T. Runkler, "Sequential Possibilistic One-Means Clustering with Dynamic Eta", IEEE International Conference on Fuzzy Systems, pp. 1-8, 2018.