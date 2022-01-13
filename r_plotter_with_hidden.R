create_plot <- function(output, parameters, weights, nodes = NULL, png.title=NULL, pos.col = "#858585", neg.col = "#e23128", node.col = "#999999", node.otl = "#4F4F4F", text.col = "white", line.diff = 4){
  if(!is.null(nodes)&& is.list(nodes) && is.list(weights)){
    weights <- convert_to_structure(weights, nodes)
  }
  
  # get structure
  struct <- list()
  for(i in 1:length(weights)){
    struct <- append(struct, length(weights[[i]]))
  }
  struct <- append(struct, 1)
  
  # short every parameter with more than 20 chars
  for (title in parameters){
    l = nchar(title)
    if (l > 19){
      parameters[[match(title, parameters)]] <- paste0(substr(title, 1, 19), "...")
    }
  }
  
  # short output if longer than 20 chars
  if (nchar(output) > 15){
    output <- paste0(substr(output, 1, 15), "...") 
  }
  
  # short weights if their digit places are more than 5
  for(layer in 1:length(weights)){
    for(node in 1:length(weights[[layer]])){
      for(weight in 1:length(weights[[layer]][[node]])){
        weights[[layer]][[node]][[weight]] <- round(weights[[layer]][[node]][[weight]],4)
      }
    }
  }

  # create x and y coordinates for every parameter
  # and some text adjustments
  nn <- data.frame(matrix(nrow=0, ncol = 2))
  names(nn) <-c ("x","y")
  text_pos <- c()
  offset_vector <- c()
  for(val in 1:length(parameters)){
    text_pos <- c(text_pos,2)
    offset_vector <- c(offset_vector, 1.6)
  }
  
  max_y <- struct[[1]]
  for(s in struct){
    if(s > max_y){
      max_y <- s
    }
  }
  
  # create x and y coordinates for every hidden layer node
  # and store them
  x_coordinates <- list()
  y_coordinates <- list() 
  y_function = function(v, m_y, st) v*7+5 + (m_y-st)/2 * 7
  for(s in 1:length(head(struct, -1))){
    x_coords <- list()
    y_coords <- list()
    for(val in 0:(head(struct, -1)[[s]]-1)){
      x_ <- s-1
      y_ <- y_function(val, max_y, head(struct, -1)[[s]])
      x_coords <- append(x_coords, x_)
      y_coords <- append(y_coords, y_)
      de <- data.frame(x_, y_)
      names(de) <- c("x","y")
      nn <- rbind(nn, de)
    }
    x_coordinates <- append(x_coordinates, list(x_coords))
    y_coordinates <- append(y_coordinates, list(y_coords))
  }
  
  # add the x and y coordinates of the output to the dataframe
  # also prepare some text and plot adjustments
  max_y_scaled <- (max_y-1)*7 + 10
  output_x <- length((struct)) -1
  output_y <- max_y_scaled / 2
  output_coords <- data.frame(output_x, output_y)
  names(output_coords) <- c("x","y")
  nn <- rbind(nn, output_coords)
  text_pos <- c(text_pos, 4)
  offset_vector <- c(offset_vector, 0.4)

  # use created data to create a plot of the nodes
  # also create a png
  if(!is.null(png.title)){
    png(filename=png.title,width=1200,height=1000, bg=NA)
  }
  
  
  p <- plot(nn,
       col = node.otl,
       bg = node.col,
       xlab = " ",
       ylab = " ",
       pch = 21,
       cex = 7,
       lty = "solid",
       lwd =2,
       ylim = c(0,max_y_scaled),
       xlim = c(-1.4, (output_x+1)),
       bty="n",
       axes = F,
       yaxt="n",
       xaxt="n"
  )
  
  # add some text with previously created text adjustments
  text_y_coords = c(y_function(seq.int(0,(struct[[1]]-1),by=1), max_y, struct[[1]] ), output_y)
  text_x_coords = c(replicate(struct[[1]], 0), output_x)
  text(x= text_x_coords, y = text_y_coords, labels=append(parameters,output), cex=1.8, pos=text_pos, offset=offset_vector, col=text.col)

  # get min and max abs weight per layer for line widths
  max_weight_per_layer <- list()
  min_weight_per_layer <- list()
  for(layer in weights){
    max_weight <- abs(layer[[1]][[1]])
    min_weight <- abs(layer[[1]][[1]])
    for(node in layer){
      for(weight in node){
        abs_weight <- abs(weight)
        if(abs_weight > max_weight){
          max_weight <- abs_weight
        }else if(abs_weight < min_weight){
          min_weight <- abs_weight
        }
      }
    }
    
    max_weight_per_layer <- append(max_weight_per_layer, max_weight)
    min_weight_per_layer <- append(min_weight_per_layer, min_weight)
  }
  
  # create lines between nodes
  for(layer in 1:(length(weights))){
    for(node in 1:length(weights[[layer]])){
      for(weight in 1:length(weights[[layer]][[node]])){
        if(weights[[layer]][[node]][[weight]] >= 0){
          color <- pos.col
        }else{
          color <- neg.col
        }
        line_width = ((abs(weights[[layer]][[node]][[weight]]) - min_weight_per_layer[[layer]])/max_weight_per_layer[[layer]])*line.diff + 1
        if(layer < length(weights)){
          arrows(x_coordinates[[layer]][[node]]+ 0.06 + (0.02*(length(struct)-2)), y_coordinates[[layer]][[node]], x_coordinates[[layer+1]][[weight]]- 0.06 - (0.02*(length(struct)-2)), y_coordinates[[layer+1]][[weight]], code=0, col=color, lwd = line_width)
        }else{
          arrows(x_coordinates[[layer]][[node]]+ 0.06 + (0.02*(length(struct)-2)), y_coordinates[[layer]][[node]], output_x- 0.06 - (0.02*(length(struct)-2)), output_y, code=0, col=color, lwd = line_width)
        }
      }
    }
  }
  
  # save the image
  if(!is.null(png.title)){
    dev.off() 
  }
  return(p)
}

convert_to_structure <- function(weights, nodes){
  counter = 1
  nums <- list()
  layers <- length(nodes)
  for(am in 1:layers){
    num <- list()
    if(am != layers){
      am_nodes = nodes[[am]]
      for(i in 1:am_nodes){
        n <- list()
        am_nodes_next_layer <- nodes[[am+1]]
        for(j in 1:am_nodes_next_layer){
          if(counter > length(weights)){
            break
          }
          n <- append(n,weights[[counter]])
          counter = counter + 1
        }
        num <- append(num, list(n))
        if(counter > length(weights)){
          break
        }
      }
      nums <- append(nums, list(num))
      if(counter > length(weights)){
        break
      }
    }
  }
  return(nums)
}
