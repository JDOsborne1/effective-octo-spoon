clustering_plan <- drake_plan(
        
        
        # The pca process requires all elements to be numeric
        factor_analysis_test_data = scale(iris[, -5]) 
                
        , PCA_plot = factor_analysis_test_data   %>%      
                prcomp() %>% 
                fviz_pca_ind( title = "PCA - Donation Data", 
                     habillage = iris$Species,  palette = "jco",
                     geom = "point", ggtheme = theme_classic(),
                     legend = "bottom")
        , km.res1 = factor_analysis_test_data %>% 
                kmeans(3)
        
        , Cluster_plot =  fviz_cluster(list(data = factor_analysis_test_data, cluster = km.res1$cluster),
                     ellipse.type = "norm", geom = "point", stand = FALSE,
                     palette = "jco", ggtheme = theme_classic())
        
        , Dendogram_cluster_plot = factor_analysis_test_data %>% 
                dist() %>% 
                hclust() %>% 
                fviz_dend( k = 3, k_colors = "jco", as.ggplot = TRUE, show_labels = FALSE)
        
        , Hopkins_clusterability_stat = factor_analysis_test_data %>% 
                {get_clust_tendency(., nrow(.)-1)}
)