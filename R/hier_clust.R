#' Function that provides agglomerative hierarchical clusters for a data set
#'
#' @param data data set
#' @param cluster user-specified number of clusters
#'
#' @returns a data frame specifying the cluster assignment and index of each observation in the data set
#'
#' @export

hier_clust <- function(data, cluster){
    dist <- dist(data)
    dist <- as.matrix(dist)
    dist <- as.data.frame(apply(dist, 1, function(x) ifelse(x == 0, NA, x)))
    colnames(dist) <- NULL
    rownames(dist) <- NULL

    vec <- c(1, rep(NA, length.out = nrow(data) -1))
    while(NA %in% vec){
        i <- as.numeric(which(is.na(vec))[1])
        cur1 <- as.numeric(which.min(dist[,i]))
        cur <- as.numeric(rownames(dist)[cur1])
        if(!is.na(vec[cur])){
            vec[i] <- vec[cur]
            vec[cur] <- vec[cur]
            dist <- dist[-which(rownames(dist) == i),]
        }
        if(is.na(vec[cur])){
            vec[i] = i
            vec[cur] = i
            dist <- dist[-which(rownames(dist) == cur),]
        }
    }
    i = 1
    while(nrow(dist) > cluster){
        j = unique(vec)[i]
        cur = as.numeric(rownames(dist)[which.min(dist[,j])])
        vec[vec == cur] <- j
        dist <- dist[-which(as.numeric(rownames(dist)) == cur),]
        i <- i + 1
        if(i > length(unique(vec))){
            i = 1
        }


    }
    vec <- factor(vec, labels = c(1:length(unique(vec))))
    return(data.frame(index = rep(1:nrow(data)),
                      clusters = vec))
}
