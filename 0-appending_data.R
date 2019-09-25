## --------------------------------------------------------------------
## GRAD-E1291: Introduction to Machine Learning
## TITLE OF OUR PROJECT HERE
## OUR NAMES
## --------------------------------------------------------------------

## load packages and functions --------

# set root directory
data_dir <- "../newspaper-data/"

# create string of all file names in folder 
files_de <- list.files(path=paste0(data_dir,"de"), pattern=".RDa$")
files_eng <- list.files(path=paste0(data_dir,"eng"), pattern=".RDa$")

data_de <- list()
data_eng <- list()

# create a loop to read in your data
for (i in 1:length(files_de))
{
  names_de[i]<-load((paste0(data_dir,"de/",files_de[i])))
}

for (i in 1:length(files_eng))
{
  names_eng[i]<-load((paste0(data_dir,"eng/",files_eng[i])))
}

#test_df <- rbind(abendblatt_df, bild_df)
#colnames_de <- data.frame()

colnames_de <- list()
for (i in 1:length(names_de))
{
  colnames_de[i]<-names(names_de[i])
}

