function doSomething() 
{ 
	//getDimensions(width, height, channels, slices, frames);
	//y_row = newArray(height);


// function description
}



macro "Statistical_Analyses" {
//only applies to 8-bit gray, colors are from 0-255
	run("Select None");
	getDimensions(width, height, channels, slices, frames);
	y_row = newArray(height);
	for (i=0; i<height; i+=1) {
		y_row[i] = i;
	}
	x_uncorroded = newArray(height);
	x_right_edge = newArray(height);
	x_ratio = newArray(height);
	x_left_edge = newArray(height);
	x_thickness = newArray(height);
	
	for (l=0; l<height; l+=1) {
		temp = 0;
		for (m=0; m<width; m+=1) {
			temp = getPixel(m,l);
			
			if (temp != 0) {
				x_left_edge[l] = m;
				m = width;
			}
		}
	}
	
	for (j=0; j<height; j+=1) {
		temp_1 = 0;
		temp_2 = 0;
		for (i=0; i<width; i+=1) {
			temp_1 = getPixel(i,j);
			if (temp_1 >= 240) {
				x_uncorroded[j] = i-x_left_edge[j];
				i = width;
			}
			
		}
//find the first pixel from the left that is corroded (larger than the selected gray level)
	for (k=width-1; k>0; k-=1) {
			temp_2 = getPixel(k,j);
			if (temp_2 >0) {
				x_right_edge[j] = k+1-x_left_edge[j];
				k = 0;
			}
				

	
//find the first pixel from the right that defines the edge (non-black)
		x_ratio[j] = 1-(x_uncorroded[j]/x_right_edge[j]);
		x_thickness[j] = x_right_edge[j]-x_left_edge[j];
		
//calculate the ratio
		if(x_ratio[j]>0.99){
			x_ratio[j]=0;
		}
//this is to correct for the uncorroded, which was assigned to be 0 if no corroded pixel is detected for that row. If it is not corroded for a pixel row, then the ratio should be 0 instead of 1.
		}
		}
	Table.create("results");
	Table.setColumn("Row_by_Pixel", y_row);
	Table.setColumn("Uncorroded_Depth_by_Pixel", x_uncorroded);
	Table.setColumn("Thickness_by_Pixel", x_right_edge);
	Table.setColumn("Thickness_Left_Pixel", x_left_edge);
	Table.setColumn("Thickness", x_left_edge);
	Table.setColumn("Corrosion_Depth_Ratio", x_ratio);
	Table.update;
	//saveAs("Results", "C:/Users/Weiyue Zhou/Desktop/results.csv");
}
