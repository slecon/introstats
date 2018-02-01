# frequency polygon
freq.poly <- function(x,breaks=NULL,freq=TRUE,xlab="Values",ylab="Frequencies",main="Frequency Polygon") {
  if (is.null(breaks)) stop("No breaks to categorize the data.")
  x.freq <- table(cut(x,breaks,right=FALSE))
  startpoints <- seq(from=1,to=length(breaks)-1,by=1)
  endpoints <- seq(from=2,to=length(breaks),by=1)
  
  # calculate midpoints
  midpoints <- 0.5*(breaks[startpoints] + breaks[endpoints])
  
  if(freq==TRUE) {
    plot(midpoints,
         as.vector(x.freq),
         type="b",
         xlab=paste(xlab),
         ylab=paste(ylab),
         main=paste(main))
    } else {
    plot(midpoints,
         as.vector(x.freq)/length(x),
         type="b",
         xlab=paste(xlab),
         ylab=paste(ylab),
         main=paste(main))
      }
}

# Ogive
ogive <- function(x,breaks=NULL,freq=TRUE,xlab="Values",ylab="Frequencies",main="Ogive") {
  if (is.null(breaks)) stop("No breaks to categorize the data.")
  x.freq <- table(cut(x,breaks,right=FALSE))
  endpoints <- seq(from=2,to=length(breaks),by=1)
  
  # cumfreq0 <- c(0, cumsum(x.freq))
  if(freq==TRUE) {
    plot(c(min(x),breaks[endpoints]),
         c(0,cumsum(x.freq)),
         type="b",
         xlab=paste(xlab),
         ylab=paste(ylab),
         main=paste(main))
  } else {
    plot(c(min(x),breaks[endpoints]),
         c(0,as.vector(cumsum(x.freq))/length(x)),
         type="b",
         xlab=paste(xlab),
         ylab=paste(ylab),
         main=paste(main))
  }
}
