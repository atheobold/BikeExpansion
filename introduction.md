Introduction
========================================================

This <a href="http://shinyapps.io?kid=2B7XZ" target="_blank">ShinyApp</a> allows you to directly interact with the bicycle infrastructure of Montana State University. The data consists of known Montana State University building capacities, the current location and capacity of bike racks, and the locations of trees. 

## Quick Start

1. If this is your first visit, please do not change the settings on the left panel (don't worry you will be able to play with these settings in just a moment). First, familiarize yourself with the outputs.

2. Output One: Select the "Racks" tab to view the raw bike rack data for campus. You can filter the bike rack data by any attribute, such as capacity, rack type, or nearest building.  By clicking on the capacity for a particular bike rack, the capacity can be increased or decreased.  Additionally, clicking on rack type, the type can be updated, the currently supported rack types are Cora, Cora Other, Cora Other|Old, Old, Spline, U shaped, and New.  

3. Output Two: Select the "Buildings" tab to see the raw campus building capacities (dormitories are not included). The buildings can be filtered and sorted by any attribute. A building's capacity can be updated by clicking on the numeric value for the building's capacity.  

4. Now that you have visited the two main output tabs return to the "Map" tab to view the Montana State University bicycle infrastructure. 

5. In the upper right hand corner of the plot there are four check boxes. Each check box controls the display of the corresponding plot characteristic. 
    + The `building polygons` box, creates a transparent overlay for each building included in the data. The area of the overlay corresponds to the building's capacity, i.e. the further the overlay extends beyond the edge of a building, the larger the capacity.  Clicking on the overlay will reveal the building name and capacity.  
    + The `rack circles` box creates a circular overlay around each of the bicycle racks on campus. The exact location of the rack can also be included with the `rack icons` box. The radius of these circles is based on their respective capacities.  Clicking on a circle will reveal the number of racks, capacity, and type.  The circular overlays can be hidden under a building overlay making it unable to be selected.  If this happens, ensure the `rack icons` box is checked, then click on the icon of the bike to reveal the rack information. 
    + The `tree icon` box places tree icons to the map, separated by type (coniferous or deciduous).  We recommend viewing trees when zoomed in further, as the icons do not scale and can be overwhelming from a distance. 

6. There are 3 check boxes to the left hand of the map. Each also controls a different aspect of the the plot characteristics.  
    - The `shape settings` box will open up 4 slider bars.  The first two bars control the color saturation of the building polygons and the rack circles respectively. The second two options control the <b>radius size</b> for buildings and racks. Larger values allow for the capacity of a building or bike rack to extend further from their respective centers.  The radius size can be regarded as the expected distance the capacity of the bike rack can service, or the area the building is being serviced by. Note that currently when the map is zoomed in, the applet re-scales the radius respective to the building. This change can be adjusted with the `alpha` slider.  
    - The `color settings` box will open up 6 color selection boxes, one for buildings, and one for each of five types of racks. To change the color of any of the objects, simply click on the color bar next to it. A color panel will appear to give you a large variety of color options, simply select the color you would like displayed on the map. After selecting a color the map will automatically update. Selecting the `hide` box will remove the corresponding object's overlay from the map. If you would like the same color for all rack types, select the `one color for racks` check box.
    - The `add racks` check box opens up an input dialogue for adding a new bike rack to the dataset and map.  To add a new rack click on the area of the map where you would like to place the rack.  The longitude and latitude coordinates will update to the point you selected on the map.  Enter the desired capacity then click `add rack`.  The map will automatically update by placing the corresponding bike icon or circular overlay.  The added bike rack will have type `new`.

8. Enjoy!