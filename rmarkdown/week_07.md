---
title: "Week 7 - ggplot II"
author: "Jose Luis Rodriguez Gil"
date: "26/10/2020"
output: 
  html_document:
    keep_md: true
---







```r
source(here("functions", "theme_pepe.R"))
```

# Annotations

WE create the same mock dataset we used last week.


```r
set.seed(1111)

depth_data <- tibble(depth = seq(0,1000, by = 100),
                     compound_a = sort(abs(rnorm(11, 1000, 10000))),
                     compound_b = abs(rnorm(11, 80, 50)))

depth_data
```

```
## # A tibble: 11 × 3
##    depth compound_a compound_b
##    <dbl>      <dbl>      <dbl>
##  1     0       134.     130.  
##  2   100      2163.       3.29
##  3   200      7397.      10.9 
##  4   300      7775.      97.8 
##  5   400      8765.     123.  
##  6   500     12178.      76.0 
##  7   600     12748.      31.9 
##  8   700     13839.      85.6 
##  9   800     14225.      67.1 
## 10   900     14840.     154.  
## 11  1000     28308.     114.
```


Some useful geoms to annotate your plots with


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  # main plotting elements
  ggplot() +
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  # annotation layers
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) + # Single shaded area
  
  
  annotate(geom = "text",
           x = 1, y = 500,
           label = "Reference level",
           hjust = -0.1,
           vjust = -0.5) +  # text annotations
  
    annotate(geom = "text",
           x = 1, y = 900,
           label = "y = 3x +10.5",
           hjust = -0.1,
           vjust = -0.5) + # text annotations

  
    annotate(geom = "label",
           x = 2500, y = 200,
           label = "Important point",
           hjust = 1,
           vjust = -0.5) + # text annotations
  
  annotate(geom = "curve",
           x = 900 , y = 180, xend = 6500, yend = 200,
           arrow = arrow(length = unit(1, "mm")),
           curvature = 0.5) + # bent line
  
  

  #scales
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10(limits = c(1, 50000)) +
  
  # themes
  
  theme_minimal()
```

![](week_07_files/figure-html/unnamed-chunk-1-1.png)<!-- -->

but what if i wanted to provide all the values???

Now the actual `geom_text()` comes handy, because we actually need to map labels to data


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  # Main plotting elements
  ggplot() +
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  
  # Annotation layers
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) +  
  
  
  geom_text(aes(x = concentration, 
                y = depth, 
                label = round(concentration)),
            hjust = -0.5, 
            size = 3) +
  
  # Scales
  scale_y_reverse() +
  scale_x_log10(limits = c(1, 50000)) +
  
  # Themes
  
  theme_minimal()
```

![](week_07_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

Unfortunately the labels overlap. the package `{ggrepel}` can help with that! You can use its function `geom_text_repel()` which is like `geom_text()` but ensures the text does not overlap


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  # Main plotting elements
  ggplot() +
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  
  # Annotation layers
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) +  
  
  
  geom_text_repel(aes(x = concentration, 
                y = depth, 
                label = round(concentration)), 
            size = 3) +
  
  # Scales
  scale_y_reverse() +
  scale_x_log10(limits = c(1, 50000)) +
  
  # Themes
  
  theme_minimal()
```

![](week_07_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

# Commong formating options

The x axis is in log scale. The log scale is not evenly spaced, so lets make sure we show that with some tick marks

In this one we are going to also edit the title, subtitle, and the lables of the x and y axis.



```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  # Main plotting elements
  ggplot() +
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  # Annotation layers
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) +  
  
  
  #scales
  
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10(limits = c(1, 50000), expand = expansion(mult = 0, add = 0)) +
  
  annotation_logticks(sides = "b") + # adds log-spaced tick marks
  
  # theme and other formatting
  
  theme_bw() +
  
  labs(title = "Test depth profile",
       subtitle = "comparison of Compound A and Compound B",
       x = "Concentration (mg/L)",
       y = "Depth (m)")
```

![](week_07_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

But what if the concentration was in $\mu$g/L (more info on how to include greek symbols in ggplots [here](https://github.com/tidyverse/ggplot2/wiki/Plotmath))


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  # Main plotting elements
  ggplot() +
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  # Annotation layers
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) +  
  
  
  #scales
  
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10(limits = c(1, 50000), expand = expansion(mult = 0, add = 0)) +
  
  annotation_logticks(sides = "b") + # adds log-spaced tick marks
  
  # theme and other formatting
  
  theme_bw() +

  labs(title = "Test depth profile",
       subtitle = "comparison of Compound A and Compound B",
       x = expression(Concentration~(mu*g~.~L^{-1})),  # with expression() you can plot math. "~" means a space
       y = "Depth (m)")
```

![](week_07_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

Let's change now some of theme elements


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  # Main plotting elements
  ggplot() +
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  # Annotation layers
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) +  
  
  
  #scales
  
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10(limits = c(1, 50000), expand = expansion(mult = 0, add = 0)) +
  
  annotation_logticks(sides = "b") + # adds log-spaced tick marks
  
  # theme and other formatting
  
  theme_bw() +

  labs(title = "Test depth profile",
       subtitle = "comparison of Compound A and Compound B",
       x = expression(Concentration~(mu*g~.~L^{-1})),  # with expression() you can plot math. "~" means a space
       y = "Depth (m)") +
  
  theme(text = element_text(size = 9, colour = 'grey10'),
        line = element_line(size = 0.25),
        axis.line = element_line(size = 0.25, colour = "red"),
        axis.ticks = element_line(size = 0.25, colour = "red"),
        plot.margin = unit(c(0.7,0.7,0,0), "cm" ))
```

![](week_07_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

Now, let's move the legend around


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  # Main plotting elements
  ggplot() +
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  # Annotation layers
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) +  
  
  
  #scales
  
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10(limits = c(1, 50000), expand = expansion(mult = 0, add = 0)) +
  
  annotation_logticks(sides = "b") + # adds log-spaced tick marks
  
  # theme and other formatting
  
  theme_bw() +

  labs(title = "Test depth profile",
       subtitle = "comparison of Compound A and Compound B",
       x = expression(Concentration~(mu*g~.~L^{-1})),  # with expression() you can plot math. "~" means a space
       y = "Depth (m)") +
  
  theme(text = element_text(size = 9, colour = 'grey10'),
        line = element_line(size = 0.25),
        axis.line = element_line(size = 0.25, colour = "red"),
        axis.ticks = element_line(size = 0.25, colour = "red"),
        plot.margin = unit(c(0.7,0.7,0,0), "cm" )) +
  
  
  theme(legend.position = "bottom")
```

![](week_07_files/figure-html/unnamed-chunk-7-1.png)<!-- -->


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  # Main plotting elements
  ggplot() +
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  # Annotation layers
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) +  
  
  
  #scales
  
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10(limits = c(1, 50000), expand = expansion(mult = 0, add = 0)) +
  
  annotation_logticks(sides = "b") + # adds log-spaced tick marks
  
  # theme and other formatting
  
  theme_bw() +

  labs(title = "Test depth profile",
       subtitle = "comparison of Compound A and Compound B",
       x = expression(Concentration~(mu*g~.~L^{-1})),  # with expression() you can plot math. "~" means a space
       y = "Depth (m)") +
  
  theme(text = element_text(size = 9, colour = 'grey10'),
        line = element_line(size = 0.25),
        axis.line = element_line(size = 0.25, colour = "red"),
        axis.ticks = element_line(size = 0.25, colour = "red"),
        plot.margin = unit(c(0.7,0.7,0,0), "cm" )) +
  
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        legend.direction = "vertical")
```

![](week_07_files/figure-html/unnamed-chunk-8-1.png)<!-- -->


## Custom themes in ggplot

This section is highly inspired by [this post](https://rpubs.com/mclaire19/ggplot2-custom-themes)

# Option 1 - Creat your theme as an object, then call it

Instead of having a long list of theme variable syou want modified on each plot, you can save these into one single object and call it in your plot





```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) +  # Probably the easiest aproach when annotating is the goal
  
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  #scales
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10(limits = c(1, 50000), expand = expansion(mult = 0, add = 0)) +
  
  annotation_logticks(sides = "b") + # adds log-spaced tick marks
  
  # theme and other formatting
  
  labs(title = "Test depth profile",
       subtitle = "comparison of Compound A and Compound B",
       x = expression(Concentration~(mu*g~.~L^{-1})),  # with expression() you can plot math. "~" means a space
       y = "Depth (m)") +
  
  
  theme_bw() +
  
  theme_pepe  # Notice that it is an object, so no () needed
```

![](week_07_files/figure-html/unnamed-chunk-10-1.png)<!-- -->


# Option 2 - Save it as a function that you can call on all your scripts

Lets see what is inside one of ggoplot's preset themes:


```r
theme_bw
```

```
## function (base_size = 11, base_family = "", base_line_size = base_size/22, 
##     base_rect_size = base_size/22) 
## {
##     theme_grey(base_size = base_size, base_family = base_family, 
##         base_line_size = base_line_size, base_rect_size = base_rect_size) %+replace% 
##         theme(panel.background = element_rect(fill = "white", 
##             colour = NA), panel.border = element_rect(fill = NA, 
##             colour = "grey20"), panel.grid = element_line(colour = "grey92"), 
##             panel.grid.minor = element_line(size = rel(0.5)), 
##             strip.background = element_rect(fill = "grey85", 
##                 colour = "grey20"), legend.key = element_rect(fill = "white", 
##                 colour = NA), complete = TRUE)
## }
## <bytecode: 0x121380410>
## <environment: namespace:ggplot2>
```



```r
theme_pepe_2 <- function(){
  
  theme_bw() %+replace%    # we start with theme_bw() and replace what we want
    
    theme(
      
      text = element_text(          # Set up the default for ALL text elements (unless they are over-written in theme_bw())
        size = 10,                  # set up size
        colour = '#1d3557'),         # Set up colour (hex number)
      
      line = element_line(          # set up the default for ALL lines (unless they are over-written in theme_bw())
        size = 0.25,                # Set line thickness
        colour = '#1d3557'),        # Set line colour (hex number)
      
      plot.title = element_text(    # specific details for plot title
        hjust = 0,                  # Make sure it is left-aligned
        size = 12,                  # We make it a bit bigger than the default
        face = 'bold'),       
            
      plot.subtitle = element_text(    # specific details for plot title
        hjust = 0,                     # Make sure it is left-aligned
        colour = '#457b9d',            # Set colour (hex number)
        margin = margin(5,0,10,0)),    # add a bit of margin top and bottom to separate from title and plot
                                       # margins are specified as top, right, bottom and left
      
      # Remove backgrounds      

      plot.background = element_blank(),    # remove the background for the whole plotting area
      
      panel.background = element_blank(),   # remove the background for the plot itself
      
      panel.border = element_blank(),       # remove the border of the plot
      
      # Work the axis a bit
      
      axis.line = element_line(             # details specific for axis
        size = 0.6),

      axis.ticks = element_line(            # Details specific to axis ticks
        size = 0.6),
      
      # A few changes on legends 
      # you dont want to "hardcode" too much on legends as these are very plot-speciffic
      
      legend.title = element_blank(),            # remove legend title
      legend.background = element_blank(),       # remove background on legend itself
      legend.box.background = element_blank(),   # remove background on legend box
      
      # margin around the plot
      
      plot.margin = unit(c(0.7,0.7,0,0), "cm" )  # margin around the plot (top, right, bottom, left)
    )
}
```




```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  
  annotate(geom = "rect", 
           ymin = 250, ymax = 500, xmin = 1, xmax = Inf,
           alpha = 0.2) +  # Probably the easiest aproach when annotating is the goal
  
  
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +

  #scales
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10(limits = c(1, 50000), expand = expansion(mult = 0, add = 0)) +
  
  annotation_logticks(sides = "b") + # adds log-spaced tick marks
  
  # theme and other formatting
  
  labs(title = "Test depth profile",
       subtitle = "comparison of Compound A and Compound B",
       x = expression(Concentration~(mu*g~.~L^{-1})),  # with expression() you can plot math. "~" means a space
       y = "Depth (m)") +
  
  
  theme_pepe_2()  # Notice that it is an actual function, so the () ARE needed
```

![](week_07_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

```r
                  # no need for theme_bw() now, as this is part of our new theme
```

# Heatmaps


```r
decapod <- read_delim(here("data", "decapod.txt"), delim = "\t") %>%
  clean_names() %>% 
  pivot_longer(cols = c(-sample, -t1m, -t45_35m, -s1m, -s45_35m, -ch0_10m, -year, - location),
               names_to = "species",
               values_to = "counts") %>%
  filter(sample <= 14) %>% 
  mutate(sample = as.factor(sample))
```

```
## Rows: 45 Columns: 20
```

```
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: "\t"
## dbl (20): Sample, FGal, FPag, FPor, FHipp, FCra, FPro, FPan, FAlp, FCall, FU...
```

```
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```


```r
decapod %>% 
  ggplot() +
  geom_tile(aes(x = species, y = sample, fill = counts)) +
  scale_fill_viridis() +
  theme_bw()
```

![](week_07_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

# Combining multiple plots into one

We have seen how to use the `facet_wrap()` to create multiple pannels for differents samples, sites, stations, etc. But in order to do that we need to be making the exact same plot for all. What if we want to combine different plots. The `{patchwork}` package allows us to combine multiple plots.


```r
decapod_counts <- decapod %>%
  ggplot() +
  geom_col(aes(x = sample, y = counts, fill = species), position = "stack") +
  scale_y_continuous(expand = expansion(mult = 0, add = 0)) +
  scale_fill_viridis(discrete = TRUE) +
  labs(x = "Sample",
       y = "Species counts") +
  theme_bw()

print(decapod_counts)
```

![](week_07_files/figure-html/unnamed-chunk-15-1.png)<!-- -->


```r
decapod_proportions <- decapod %>%
  ggplot() +
  geom_col(aes(x = sample, y = counts, fill = species), position = "fill") +
  scale_y_continuous(expand = expansion(mult = 0, add = 0)) +
  scale_fill_viridis(discrete = TRUE) +
    labs(x = "Sample",
       y = "Species porportional pressence") +
  theme_bw()

print(decapod_proportions)
```

![](week_07_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

We can now merge both plots using the `{patchwork}` package


```r
decapod_counts + 
  decapod_proportions +
  plot_layout(ncol = 2,             # You can specify the number of columns and rows
              guides = 'collect') +   # With this we can tell it to share the legend
  plot_annotation(tag_levels = c('A', '1'))
```

![](week_07_files/figure-html/unnamed-chunk-17-1.png)<!-- -->


