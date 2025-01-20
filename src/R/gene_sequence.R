install.packages("msigdbr")
library(msigdbr)
hm <- msigdbr(species="human", category="H")
gs <- unique(hm[hm$gs_name=="HALLMARK_G2M_CHECKPOINT",]$gene_symbol)
gs_string <- paste(gs, collapse=", ")
prompt <- paste("Act as an expert in DNA sequencing method, describe anything interesting from the following set of gene symbols: ", gs_string)
print(prompt)
res <- ollamar::generate(model = "llama3.2:1b", prompt = prompt, output="text")
print(res)


