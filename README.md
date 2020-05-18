## Parse NGAWEST2 GMs to AT2 file and Spectra to txt


This code rewrites the Ground Motion Time-History files downloaded from the NGAWEST2 Database, into vector files. The two directions of the ground motion record will be named as per the filenameX and filenameY, and the Extension. For the given example in this code, the ground motions will be renamed as 'GM1i' and 'GM2i', where 'i' is the ground motion number which goes from 1 to 'n', where 'n' represents the total number of ground motions present in the .csv file. The index "i' is as per given in the .csv file. 

The code also provides the option to write 4 lines of headers containing information of the Earthquake and the Ground Motion, if variable Header is kept to 'Yes'


For example: 
    
    'GM11.AT2' --> Ground Motion 1 in direction 1 (direction 1 can be either one of the bi-directional GM as we are rotating the ground motions it does not matter) 
     
     'GM21.AT2' --> Ground Motion 1 in direction 2 (direction 2 is the other direction of the bi-directional GM)
     
     'GM12.AT2' --> Ground Motion 2 in direction 1 (direction 1 can be either one of the bi-directional GM as we are rotating the ground motions it does not matter)  
     
     'GM22.AT2' --> Ground Motion 2 in direction 2 (direction 2 is the other direction of the bi-directional GM)
 

This code will also write the downloaded Spectra (both Combined and Unscaled Component) of the ground motion (present in the .csv file) to .txt files with indeces corresponding to the GM .AT2 file. Two folders : 'GM_Spectra' and 'Unscaled_Component_Spectra' will be created to store the spectra.


The .txt files in the 'GM_Spectra folder' will contain the combined spectra of the GMs which will be written as: 
    'Type of Spectra'_GM1.txt,  where 'Type of Spectra' can be  RotD50, SRSS etc. which is selected by the user while downloading the GMs from the database.
    
For example:
      'RotD50_GM1.txt' --> contain RotD50 Spectra of the 2 components of Ground Motion 1


While the .txt files in 'Unscaled_Component_Spectra' will contain Unscaled Component spectra of indiviual components of the GMs

For example: 
      
      'Comp_GM11.txt' --> Component Spectra of Ground Motion 1 in direction 1 (direction 1 can be either one of the bi-directional GM as we are rotating the ground motions it does not matter) 
      
      'Comp_GM21.txt' --> Component Spectra of Ground Motion 1 in direction 2 (direction 2 is the other direction of the bi-directional GM)
      
      
INPUT:

Input Variables includes: 

    .csv file which is downloaded from the NGA database alongwith the GM Time-Histories

    filenameX

    filenameY

    Extension


OUTPUT:

    Rewritten GM files will be outputted in a new folder named "Formatted_GMs"

    Combined Spectra of the GMs will be rewritten in a new folder named "GM_Spectra"

    Component Spectra of each component of GMs will be rewritten in a new folder named "Unscaled_Component_Spectra
