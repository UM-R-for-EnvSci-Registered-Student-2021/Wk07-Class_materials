---
title: "Week 6 - ggplot II"
author: "Jose Luis Rodriguez Gil"
date: "19/10/2021"
output: 
  html_document:
    keep_md: true
---




```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
```

```
## ✓ ggplot2 3.3.5     ✓ purrr   0.3.4
## ✓ tibble  3.1.4     ✓ dplyr   1.0.7
## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
## ✓ readr   2.0.1     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(janitor)
```

```
## 
## Attaching package: 'janitor'
```

```
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```

```r
library(here)
```

```
## here() starts at /Users/pepe/Dropbox/Postdoc/03_ELA/Teaching/UofM/R course/R Course - 2021/Class materials/Wk07-Class_materials
```

```r
library(palmerpenguins)

library(ggridges)
library(viridis)
```

```
## Loading required package: viridisLite
```


Lets load some data on bentic polichetes from Argentinan coastal areas.


```r
argentina_data <- read_delim(here("data", "Argentina.txt"), delim = "\t")
```

```
## Rows: 60 Columns: 12
```

```
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: "\t"
## chr  (1): data
## dbl (11): L.acuta, H.similis, U.uruguayensis, N.succinea, MedSand, FineSand,...
```

```
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```


```r
argentina_clean <- argentina_data %>% 
  clean_names() %>% 
  pivot_longer(cols = c(l_acuta, h_similis, u_uruguayensis, n_succinea), 
               names_to = "species",
               values_to = "counts") %>% 
  rename(site = data)

argentina_clean
```

```
## # A tibble: 240 × 10
##    site  med_sand fine_sand   mud organ_mat season transect river species counts
##    <chr>    <dbl>     <dbl> <dbl>     <dbl>  <dbl>    <dbl> <dbl> <chr>    <dbl>
##  1 A1        2.46      72.2  25.4      6.59      1        1     0 l_acuta     22
##  2 A1        2.46      72.2  25.4      6.59      1        1     0 h_simi…      5
##  3 A1        2.46      72.2  25.4      6.59      1        1     0 u_urug…      0
##  4 A1        2.46      72.2  25.4      6.59      1        1     0 n_succ…      0
##  5 A2        1.23      70    28.8      6.6       1        1     0 l_acuta     40
##  6 A2        1.23      70    28.8      6.6       1        1     0 h_simi…      3
##  7 A2        1.23      70    28.8      6.6       1        1     0 u_urug…      0
##  8 A2        1.23      70    28.8      6.6       1        1     0 n_succ…      0
##  9 A3        0.56      67.4  32        6.48      1        1     0 l_acuta     54
## 10 A3        0.56      67.4  32        6.48      1        1     0 h_simi…     11
## # … with 230 more rows
```

# More  bar plots

I have expressed my disapproval of bar plots, however i indicated that there are still some acceptable uses for them. One of these, could be species counts. If you are going to use them, you should be aware of your options.

## Stacked bars

Plain stacked bars vary in height depending on the total value of the stack. Great for showing differences in the absolute number of, for example, organisms between sites, while also showing differences in composition.


```r
argentina_clean %>% 
  filter(season == "2") %>% 
  ggplot() +
  geom_col(aes(x = site, y = counts, fill = species))
```

![](week_06_files/figure-html/stacked_bars-1.png)<!-- -->


## Stacked bars percent

In this version, we loose the information relative to the differneces in the total counts per site, but we make difference sin species composition much more obvious.


```r
argentina_clean %>% 
  filter(season == "2") %>% 
  ggplot() +
  geom_col(aes(x = site, y = counts, fill = species), position = "fill")
```

```
## Warning: Removed 8 rows containing missing values (geom_col).
```

![](week_06_files/figure-html/stacked_bars_percent-1.png)<!-- -->

## Side-by-ide bars

Not quite aplicable for the particular case of species counts, but it can be handy in some instances.


```r
argentina_clean %>% 
  filter(season == "2") %>% 
  ggplot() +
  geom_col(aes(x = site, y = counts, fill = species), position = "dodge")
```

![](week_06_files/figure-html/Side_by_side_bars-1.png)<!-- -->


of course, you can always use tools like faceting to include more variables, like season in this case



```r
argentina_clean %>% 
  ggplot() +
  facet_wrap(~season) +
  geom_col(aes(x = site, y = counts, fill = species), position = "fill")
```

```
## Warning: Removed 8 rows containing missing values (geom_col).
```

![](week_06_files/figure-html/stacked_bars_percent_facets-1.png)<!-- -->


# Distributions

Showing the actual distribution of the date can be very helpful to discern the nature of the distribution (e.g. normal, poison, bimodal) of your data, but also to visually assess overlap (and hence, have an idea of any potencial sdifferences)

`geom_histogram()` will create histograms from your data with automatic binning


```r
penguins %>% 
  ggplot() +
  facet_wrap(~species) +
  geom_histogram(aes(x = body_mass_g))
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

```
## Warning: Removed 2 rows containing non-finite values (stat_bin).
```

![](week_06_files/figure-html/unnamed-chunk-1-1.png)<!-- -->

`geom_density()` is also very helpful as a *smooth* version of the histogram


```r
penguins %>% 
  ggplot() +
  geom_density(aes(x = body_mass_g, fill = species), alpha = 0.4)
```

```
## Warning: Removed 2 rows containing non-finite values (stat_density).
```

![](week_06_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

An option that is becoming quite popular is the `geom_density_ridgelines()` which is part of is part of the `ggridges` package by Claus Wilke. It is great to show the overlap between distributions, and hence, highlight any existing differences.


```r
penguins %>% 
  ggplot() +
  geom_density_ridges(aes(x = body_mass_g, y = species, fill = species), alpha = 0.4) 
```

```
## Picking joint bandwidth of 153
```

```
## Warning: Removed 2 rows containing non-finite values (stat_density_ridges).
```

![](week_06_files/figure-html/unnamed-chunk-3-1.png)<!-- -->


# Scales

## carefull with "zooming"

You might want to adjust the extent of your axes to *"zoom in"* in a section.

There are two aproaches in ggplot, but **be careful** because they have two very different behaviours.


Lets start by showing the distribution of the penguins' body weght again. For this example we are going to introduce `geom_violin` wich is also a quite popular version of a box plot which shows where the bulk of the data is located.

Here is the default:


```r
penguins %>% 
  ggplot() +
  geom_violin(aes(x = body_mass_g, y = species, fill = species))
```

```
## Warning: Removed 2 rows containing non-finite values (stat_ydensity).
```

![](week_06_files/figure-html/unnamed-chunk-4-1.png)<!-- -->


Now... Be very careful, when you indicate the limits on the scales, you are **not** "zooming in", you are selecting the range of data you want to use. Which means that all stats computed during a ggplot, will change!!



```r
penguins %>% 
  
  # main plot elements
  ggplot() +
  geom_violin(aes(x = body_mass_g, y = species, fill = species)) +
  
  # scales
  scale_x_continuous(limits = c(4000,10000))
```

```
## Warning: Removed 167 rows containing non-finite values (stat_ydensity).
```

![](week_06_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

`coord_catersian` on the other hand, does work like a zoom!! use it if you are expecting R to conduct any calculations in your plot.


```r
penguins %>% 
  
  # main plot elements
  ggplot() +
  geom_violin(aes(x = body_mass_g, y = species, fill = species)) +
 
   # scales
  coord_cartesian(xlim = c(4000,10000))
```

```
## Warning: Removed 2 rows containing non-finite values (stat_ydensity).
```

![](week_06_files/figure-html/unnamed-chunk-6-1.png)<!-- -->


## playing with your scales

First i am going to make some mock data of the concentrations of two compounds measured at different depths (could be a soil, could be a lake, could be the ocean...)



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


Lets give it a first try to plotting them


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound))
```

![](week_06_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

But depth is easier seen if it goes **down**!


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  
  # Scales
  scale_y_reverse()
```

![](week_06_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

Now... there is such a difference in concentrations... Let's see if i can log the x axis!



```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +

  
  #scales
  scale_y_reverse() +
  scale_x_log10()
```

![](week_06_files/figure-html/unnamed-chunk-9-1.png)<!-- -->
## Expansion - addedd padding and how to deal with it



```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +

  
  #scales
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10()
```

![](week_06_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

# Lines, all the lines!!

So far we have used `geom_path()`. `geom_path()` connects the dots in the order they appear in the dataset, which was great for our depth case


```r
depth_data %>% 
  pivot_longer(cols = -depth, names_to = "compound", values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +

  
  #scales
  scale_y_reverse() +
  scale_x_log10()
```

![](week_06_files/figure-html/unnamed-chunk-11-1.png)<!-- -->


`geom_line()` is a more common function, that is because it draws the lines in the order in which the pints appear in the x axis. Unfortunately, that would not have worked, for our depth plot!

Lets see...


```r
depth_data %>% 
  pivot_longer(cols = -depth, names_to = "compound", values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_line(aes(x = concentration, y = depth, colour = compound)) +

  
  #scales
  scale_y_reverse() +
  scale_x_log10()
```

![](week_06_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

However most times, you will be plotting lines in the horizontal direction (think **time series!**), so `geom_line()` will be perfect

`geom_step()` if a bit more unique, but it is a common plotting approach for things like **survival curves**. It also goes in the direction of the x


```r
depth_data %>% 
  pivot_longer(cols = -depth, names_to = "compound", values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_step(aes(x = concentration, y = depth, colour = compound)) +

  
  #scales
  scale_y_reverse() +
  scale_x_log10()
```

![](week_06_files/figure-html/unnamed-chunk-13-1.png)<!-- -->


There is a last option, when we want to include fixed lines (e.g. for a reference level). for this we use `geom_vline()`



```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  
  geom_hline(aes(yintercept = 500), linetype = "dashed") +
  
  geom_hline(aes(yintercept = 250), linetype = "dotdash") +
  
  geom_vline(aes(xintercept = 1000)) +
  


  #scales
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10()
```

![](week_06_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

----------------------------------------------------------------------------------------------------------

# We start here for Week 07

----------------------------------------------------------------------------------------------------------

We had missed the `geom_abline()` which allow us to create a line between two points (hence the A B Line), or to provide an intercept and a slope to plot a line. Very usefult to set a 1:1 line for something like a QQ-Plot


```r
tibble(x = seq(from = 1, to = 10, by = 1),
       y = seq(from = 1, to = 10, by = 1)) %>% 
ggplot() +
  geom_point(aes(x = x, y = y)) +
  geom_abline(aes(intercept = 0, slope = 1)) +
  geom_abline(aes(intercept = 2, slope = 0.5), linetype = "dashed") +
  
  theme_bw()
```

![](week_06_files/figure-html/geom_abline()-1.png)<!-- -->



# discrete vs continus scales

Let's make a new mock dataset


```r
site_data <- tibble(site = rep(c(1,2,3,4,5), each = 10),
       concentration = c(abs(rnorm(10, 8, 3)),
                         abs(rnorm(10, 10, 10)),
                         abs(rnorm(10, 4, 0.5)),
                         abs(rnorm(10, 15, 8)),
                         abs(rnorm(10, 5, 3))))

site_data
```

```
## # A tibble: 50 × 2
##     site concentration
##    <dbl>         <dbl>
##  1     1          5.84
##  2     1          6.36
##  3     1         12.6 
##  4     1          7.88
##  5     1          9.15
##  6     1         14.7 
##  7     1         13.3 
##  8     1         11.7 
##  9     1         15.8 
## 10     1         13.3 
## # … with 40 more rows
```


Let's try to make some box plots to see the differences between sites:


```r
site_data %>% 
  ggplot() +
  geom_boxplot(aes(x = site, y = concentration))
```

```
## Warning: Continuous x aesthetic -- did you forget aes(group=...)?
```

![](week_06_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

That wasn't quite what i wanted...

What if i plot the points?


```r
site_data %>% 
  ggplot() +
  geom_point(aes(x = site, y = concentration, colour = site))
```

![](week_06_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

Hum... what's with that legend?


**It is considering i all as numeric!**

Careful when your categories are numbers. You might have to specify that you want them to be factors.


```r
site_data %>% 
  mutate(site = as.factor(site)) %>% 
  ggplot() +
  geom_boxplot(aes(x = site, y = concentration))
```

![](week_06_files/figure-html/unnamed-chunk-18-1.png)<!-- -->




```r
site_data %>%
  mutate(site = as.factor(site)) %>% 
  ggplot() +
  geom_point(aes(x = site, y = concentration, colour = site))
```

![](week_06_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

Talking about colour scales scales...



```r
site_data %>%
  mutate(site = as.factor(site)) %>% 
  # main plotting elements
  ggplot() +
  geom_point(aes(x = site, y = concentration, colour = site)) +
  
  # scales
  
  scale_color_viridis(discrete = TRUE)
```

![](week_06_files/figure-html/unnamed-chunk-20-1.png)<!-- -->


```r
site_data %>%
  mutate(site = as.factor(site)) %>% 
  # main plotting elements
  ggplot() +
  geom_point(aes(x = site, y = concentration, colour = site)) +
  
  # scales
  
  scale_color_viridis(discrete = TRUE, option = "magma")
```

![](week_06_files/figure-html/unnamed-chunk-21-1.png)<!-- -->

# Default Themes


By now you  must be used to that grey background... Well, there are more options! ggplot comes wth a series of default themes!

## theme black and white


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +

  #scales
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10() +
  
  # themes
  
  theme_bw()
```

![](week_06_files/figure-html/unnamed-chunk-22-1.png)<!-- -->

## theme classic


```r
depth_data %>% 
  pivot_longer(cols = -depth, names_to = "compound", values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +

  #scales
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10() +
  
  # themes
  
  theme_classic()
```

![](week_06_files/figure-html/unnamed-chunk-23-1.png)<!-- -->

## theme minimal


```r
depth_data %>% 
  pivot_longer(cols = -depth, 
               names_to = "compound", 
               values_to = "concentration") %>% 
  
  #main plotting elements
  ggplot() +
  geom_point(aes(x = concentration, y = depth, colour = compound)) +
  geom_path(aes(x = concentration, y = depth, colour = compound)) +
  geom_hline(aes(yintercept = 500), linetype = "dashed") +

  #scales
  scale_y_reverse(expand = expansion(mult = 0, add = 0)) +
  scale_x_log10(limits = c(10, 50000)) +
  
  # themes
  
  theme_minimal()
```

```
## Warning: Removed 1 rows containing missing values (geom_point).
```

![](week_06_files/figure-html/unnamed-chunk-24-1.png)<!-- -->




