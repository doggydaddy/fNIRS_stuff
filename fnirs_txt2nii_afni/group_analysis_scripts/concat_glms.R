#!/usr/bin/Rscript
args<-commandArgs(TRUE);

# this filename is assumed to be without the post/pre in it
file_name<-args[1];

file_name_pre<-paste0(file_name,"pre");
file_name_post<-paste0(file_name,"post");

pre_glm1<-paste0(file_name_pre,".glm1");
pre_glm2<-paste0(file_name_pre,".glm2");
post_glm1<-paste0(file_name_post,".glm1");
post_glm2<-paste0(file_name_post,".glm2");

pre_g1 <- read.table(pre_glm1);
pre_g1 <- pre_g1[,1];
pre_g2 <- read.table(pre_glm2);
pre_g2 <- pre_g2[,1];
post_g1 <- read.table(post_glm1);
post_g1 <- post_g1[,1];
post_g2 <- read.table(post_glm2);
post_g2 <- post_g2[,1];

# assuming glm1 and glm2 are of the same length
pre_N <- length(pre_g1);
post_N <- length(post_g1);

padding_pre <- array(0,dim=post_N);
padding_post <- array(0,dim=pre_N);

pre_g1 <- c(pre_g1, padding_pre);
pre_g2 <- c(pre_g2, padding_pre);
post_g1 <- c(padding_post, post_g1);
post_g2 <- c(padding_post, post_g2);

write.table(pre_g1, file=paste0("pad",file_name_pre,".glm1"), row.names=FALSE, col.names=FALSE, quote=FALSE);
write.table(pre_g2, file=paste0("pad",file_name_pre,".glm2"), row.names=FALSE, col.names=FALSE, quote=FALSE);
write.table(post_g1, file=paste0("pad",file_name_post,".glm1"), row.names=FALSE, col.names=FALSE, quote=FALSE);
write.table(post_g2, file=paste0("pad",file_name_post,".glm2"), row.names=FALSE, col.names=FALSE, quote=FALSE);
