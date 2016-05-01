TIMES_SCORE = read.csv("TIMES_SCORE.csv", encoding="UTF-8", stringsAsFactors = FALSE)
CWUR_SCORE = read.csv("CWUR_SCORE.csv", encoding="UTF-8", stringsAsFactors = FALSE)
PUBLIC = read.csv("public.csv", encoding="UTF-8", stringsAsFactors = FALSE,check.names=FALSE, header=FALSE)
PUBLIC$names <- lapply(PUBLIC, as.character)

PUBLIC_INST_TIMES = TIMES_SCORE[TIMES_SCORE$INSTNM %in% PUBLIC[1,],]
PUBLIC_INST_CWUR =  CWUR_SCORE[CWUR_SCORE$INSTNM %in% PUBLIC[1,],]
PRIVATE_INST_TIMES =TIMES_SCORE[!(TIMES_SCORE$INSTNM %in% PUBLIC[1,]),]
PRIVATE_INST_CWUR =  CWUR_SCORE[!(CWUR_SCORE$INSTNM %in% PUBLIC[1,]),]

require(ggplot2)
#qplot(TIMES_SCORE$female_male_ratio, TIMES_SCORE$ADM_RATE_ALL)
#qplot(CWUR_SCORE$national_rank, CWUR_SCORE$ADM_RATE_ALL)

#reg = lm(CWUR_SCORE$ADM_RATE_ALL ~ CWUR_SCORE$world_rank)
#plot(CWUR_SCORE$world_rank, CWUR_SCORE$ADM_RATE_ALL)
#abline(v = 194, col = "red")
#abline(h = 0.7861, col = "red")
#abline(reg)


# Q1: How does the ranking of the university correspond with admission rate? (for public universities only)
reg = lm(PUBLIC_INST_CWUR$ADM_RATE_ALL ~ PUBLIC_INST_CWUR$world_rank)
plot(PUBLIC_INST_CWUR$world_rank, PUBLIC_INST_CWUR$ADM_RATE_ALL, main="World ranking and admission rate (public inst.)", xlab="world ranking", ylab="admission rate")
abline(reg)

reg = lm(PUBLIC_INST_CWUR$ADM_RATE_ALL ~ PUBLIC_INST_CWUR$national_rank)
plot(PUBLIC_INST_CWUR$national_rank, PUBLIC_INST_CWUR$ADM_RATE_ALL, main="National ranking and admission rate (public inst.)", xlab="national ranking", ylab="admission rate")
abline(reg)

# Q1: How does the ranking of the university correspond with admission rate? (for private universities only)
reg = lm(PRIVATE_INST_CWUR$ADM_RATE_ALL ~ PRIVATE_INST_CWUR$world_rank)
plot(PRIVATE_INST_CWUR$world_rank, PRIVATE_INST_CWUR$ADM_RATE_ALL, main="World ranking and admission rate (private inst.)",xlab="world ranking", ylab="admission rate")
abline(reg)

reg = lm(PRIVATE_INST_CWUR$ADM_RATE_ALL ~ PRIVATE_INST_CWUR$national_rank)
plot(PRIVATE_INST_CWUR$national_rank, PRIVATE_INST_CWUR$ADM_RATE_ALL, main="National ranking and admission rate (public inst.)", xlab="national ranking", ylab="admission rate")
abline(reg)

#reg = lm(CWUR_SCORE$NPT4_PUB ~ CWUR_SCORE$world_rank)
#plot(CWUR_SCORE$world_rank, CWUR_SCORE$NPT4_PUB)
#abline(reg)

#Q2: Is there a correlation between cost of tuition and university ranking? (for public universities)
reg = lm(PUBLIC_INST_CWUR$NPT4_PUB ~ PUBLIC_INST_CWUR$world_rank)
plot(PUBLIC_INST_CWUR$world_rank, PUBLIC_INST_CWUR$NPT4_PUB, main="Tuition and world ranking (public inst.)", xlab="world ranking", ylab = "tuition")
abline(reg)

#Q2: Is there a correlation between cost of tuition and university ranking? (for private universities)
reg = lm(PRIVATE_INST_CWUR$NPT4_PUB ~ PRIVATE_INST_CWUR$world_rank)
plot(PRIVATE_INST_CWUR$world_rank, PRIVATE_INST_CWUR$NPT4_PUB, , main="Tuition and world ranking (private inst.)", xlab="world ranking", ylab = "tuition")
abline(reg)


#reg = lm(CWUR_SCORE$RET_FT4 ~ CWUR_SCORE$world_rank)
#plot(CWUR_SCORE$world_rank, CWUR_SCORE$RET_FT4)
#abline(reg)

reg = lm(PUBLIC_INST_CWUR$RET_FT4 ~ PUBLIC_INST_CWUR$world_rank)
plot(PUBLIC_INST_CWUR$world_rank, PUBLIC_INST_CWUR$RET_FT4)
abline(reg)

reg = lm(PRIVATE_INST_CWUR$RET_FT4 ~ PRIVATE_INST_CWUR$world_rank)
plot(PRIVATE_INST_CWUR$world_rank, PRIVATE_INST_CWUR$RET_FT4)
abline(reg)


#CWUR_SCORE$gt_25k_p6 = as.numeric(CWUR_SCORE$gt_25k_p6)


#Q3: What is the correlation between average SAT score and admission rate?(for public universities)
reg_pub = lm(PUBLIC_INST_CWUR$ACTCM75 ~ PUBLIC_INST_CWUR$world_rank)
plot(PUBLIC_INST_CWUR$world_rank, PUBLIC_INST_CWUR$ACTCM75, main="SAT score and admission rate (public inst.)", xlab = "world ranking", ylab = "SAT score")
abline(reg_pub)

#Q3: What is the correlation between average SAT score and admission rate?(for private universities)
reg_priv =lm(PRIVATE_INST_CWUR$ACTCM75 ~ PRIVATE_INST_CWUR$world_rank)
plot(PRIVATE_INST_CWUR$world_rank, PRIVATE_INST_CWUR$ACTCM75, main="SAT score and admission rate (private inst.)", xlab = "world ranking", ylab = "SAT score")
abline(reg_priv)

smoothScatter(PUBLIC_INST_CWUR$national_rank, PUBLIC_INST_CWUR$ADM_RATE_ALL)
smoothScatter(PRIVATE_INST_CWUR$national_rank, PRIVATE_INST_CWUR$ADM_RATE_ALL)

#reg = lm(CWUR_SCORE$ACTCM75 ~ CWUR_SCORE$world_rank)
#plot(CWUR_SCORE$world_rank, CWUR_SCORE$ACTCM75)
#abline(reg)

#smoothScatter(CWUR_SCORE$national_rank, CWUR_SCORE$ADM_RATE_ALL)
