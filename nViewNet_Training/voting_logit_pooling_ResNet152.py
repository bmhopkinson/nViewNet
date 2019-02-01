#predict on test data set and save preds/lables for Confusion Matrix

import numpy as np
import sys
import torch
from torch.autograd import Variable
from torch.utils.data import DataLoader

#sys.path.append('~/Documents/nViewNet/common')
from meshtrain_dataset import MeshTrainDataset
from rn152 import RN152

# Dataset, model infiles, outfilesD
test_infile  = 'test_infile_20180828.txt'
outfile_logit = "logit_pooling_test_preds_labels.txt"
outfile_voting = "voting_test_preds_labels.txt"
model_path = './models/ResNet152_trained_FL_20180830.torch'
n_classes = 11
#
# Data Loaders and Datasets
#
batch_size = 1  # I don't expect to use this script much so can only handle batch size 1
nview_len = 8

test_data = MeshTrainDataset(test_infile, nview_len = nview_len, ann_ones_based = True )
data_loader = DataLoader(test_data, batch_size=batch_size, shuffle=False, num_workers=8 )
n_elms = len(test_data)

resnet = torch.load(model_path)
resnet.eval()  # this preps your dropout and batchnorm layers for validation

#setup vectors to hold predictions
#y_pred_logit  = np.zeros([n_elms,1], dtype= int)  #slightly odd array shape required to match output format
#y_pred_vote   = np.zeros([n_elms,1], dtype= int)  #slightly odd array shape required to match output format
#y_label = np.zeros([n_elms]  , dtype= int)logit
#i_s = 0  		#batch start index
#i_e = batch_size	#batch end index
y_pred_logit = []
y_pred_vote = []
y_label = []

#loop through samples and make a prediction for each meshI
for it, sample in enumerate(data_loader):
    image_series = Variable(sample['X'], volatile=True)  #acquire image data
    logit_pool = np.zeros((nview_len, n_classes))
    votes = np.zeros(n_classes, dtype=int)
    for i in range(0, nview_len):
        one_im = image_series[..., i].float()
        one_im = one_im.unsqueeze(4)  #this is dumb but relates to old structure of andrew slight mods in rn152.py
        #print(one_im.size())
        output = resnet(one_im).cpu()  # pass individual image through resnet152
        logits = output.data  #may need to add .numpy() logits
        #print(logits)
        #print(type(logits))
        this_vote = output.data.max(1, keepdim=True)[1].numpy().astype(int)	 # PROBABLY NEED TO ADD .numpy().astype(int)   predicted class is one with max logit score
        votes[this_vote]  =  votes[this_vote] + 1
        logit_pool[i,:] = logits

    y_pred_logit.append(np.argmax(np.mean(logit_pool,axis = 0)))
    y_pred_vote.append(np.argmax(votes))
    y_label.append(sample['Y'].numpy().astype(int))

    if it % 10 == 0:
        print(it*batch_size)

with open(outfile_logit, 'w') as outport:
    for l, p in zip(y_label, y_pred_logit):
        outport.write('%d %d\n' % (l, p) )

with open(outfile_voting, 'w') as outport:
    for l, p in zip(y_label, y_pred_vote):
        outport.write('%d %d\n' % (l, p) )

#save results
#np.savetxt('0441_simple_meshIDs.txt', y_id  , fmt='%d')
#np.savetxt('0441_simple_preds.txt'  , y_pred, fmt='%d')
