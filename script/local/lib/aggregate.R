# aggregate.R
# functions to aggegate louisiana data

combine <- function(census, mus2) {

	# unlist data (listed b/c of apply)
	mu <- unlist(mus2$mu)
	s2 <- unlist(mus2$s2)

	# merge data segements
	la <- data.frame(census,mu,s2)

	# calculate white population
	la$pop.white <- la0$pop.all - la0$pop.black

	return(la)
}

aggregate.ej <- function(mu,s2,nframe) {
		
	# reduce function to apply() to each category
	reduce.ej <- function(mu,s2,n) {
		mu.bar <- sum(n*mu) / sum(n)
		s2.bar <- sum(n*s2) / sum(n)^2
		return(c(mu.bar,sqrt(s2.bar)))  # mean, sd	
	}

	# apply reduce function to each column of n's 
	result <- apply(nframe,2,function(i) 
				reduce.ej(mu,s2,i)	)

	# format output
	result <- t(result) 	# orient results
	colnames(result) <- c("mean","sd")
	# create columns for l95 and u95
	result <- data.frame(result)
	result$l95 <- result$mean-1.96*result$sd
	result$u95 <- result$mean+1.96*result$sd
	return(result)
}

# function to do it given an fp code
by.parish <- function(code) {
	parish <- la0[la$COUNTYFP10==code,]
	ej.i   <- ej(mu=parish$mu,s2=parish$s2,nframe=data.frame(parish$pop.white,parish$pop.black))
	return(summary(ej.i)/5280)
}




