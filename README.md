## Background
The Indiana Alzheimer's Disease Research Center collects and shares data with NACC, as part of the UDS 4.0 data collection. ADI data is expected for each ADRC particpant, and NACC guidelines suggest that clinical coordinators hand enter addresses into a website in order to return ADI data. This code allows for batch processing of location data, which is much more efficient than staff manually getting ADI data for every participant.

This code takes an input data frame, uses the address data to geocode the participant locations and then spatially joins them to census block groups. Once the locations are associated with block groups, we can then merge them with publicly available ADI data from https://www.neighborhoodatlas.medicine.wisc.edu/.

**Please Note:**  
This repository includes code to take an input data frame with location data, which will likely will coming directly from REDCap or other database source. IU has a customized REDCap API token vault which we utilize to store and retrieve REDCap API tokens securely. Those processes (importing address data; exporting ADI data back into REDCap) are excluded from this code as that syntax would not be applicable to others. If you have any questions about how we do this we'd be happy to discuss further. We would strongly suggest using the redcapAPI R package (https://github.com/vubiostat/redcapAPI) to push/pull data from REDCap.

## ADRC Guidance 
For ADRCs implementing this code for NACC UDS 4.0 A1 form data collection, the importing/exporting steps excluded would entail:
  * First, exporting or otherwise pulling address data into R from REDCap or another data collection software utilizing the input format as described.
  * Once the data is processed using the provided code, importing the ADI data into the UDS A1 form in your REDCap project.
   * For reference, the Indiana ADRC has set the ADI fields in REDCap as read only, and included a note to alert users that the Data Core will fill in these data:
   
![Screenshot of REDCap A1 Form ADI Questions](/assets/images/A1_Screenshot.png)



### Required Input Variables
Variable	| Format	| Description
----------|---------|------------
id	|Numeric or Character	|Participant Unique ID.
street	|Character	|Street address (required).
aptno	|Character	|Apartment number or secondary address if applicable.
city	|Character	|City (required)
state	|Character (XX)	|State abbreviation (required)
zip	|Numeric	|5-digit zip code
