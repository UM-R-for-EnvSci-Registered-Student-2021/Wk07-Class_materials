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