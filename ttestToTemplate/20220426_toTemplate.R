toTemplate <- function(data, col_num) {
	template <- read.table('fNIRS_template.txt')
	for (i in 1:16) 
	{
		rs <- which(template$V4 == i)
		template$V4[rs] <- data[i , col_num]
	}
	return( template )
}

toFile <- function(template, filename)
{
	write.table(template, file="tmp.dump", quote=FALSE, col.names=FALSE, row.names=FALSE);
	system(paste0("3dUndump -datum float -mask fNIRS_template_mask.nii -master fNIRS_template.nii -ijk -prefix ", filename, ".nii tmp.dump"));
	system("rm tmp.dump");
}


