# Background
The Indiana Alzheimer's Disease Research Center collects data and shares with NACC, as part of the UDS 4.0 data collection. ADI data is collected for each ADRC particpant as part of UDS 4.0, but NACC guidelines suggest that clinical coordinators hand enter addresses into a website in order to return ADI data. This code allows for batch processing of location data, which is much more efficient than staff manually getting ADI data for every Center participant.

This code takes an input data frame and uses the address data to geocode the participant locations and then spatially join them to census block groups. Once the locations are associated with block groups, we can then merge them with publicly available ADI data from https://www.neighborhoodatlas.medicine.wisc.edu/.

**Please Note**
This repository includes code to take an input data frame with location data, that likely will be exported straight from REDCap or other database source. IU has a cusomized REDCap API token vault, which we utilize to store and retrieve REDCap API tokens securely. That process is excluded from this code as it would no be applicable to others. We would strongly suggest using the redcapAPI R package (https://github.com/vubiostat/redcapAPI) to push/pull data from REDCap. Similarly, we exclude the last step of importing the data into REDCap or other databases. 

## ADRCs 
For ADRCs implementing for NACC UDS 4.0, the importing/exporting steps excluded as noted above would be:
  * Exporting address data from REDCap or other data collection software into the input format as described.
  * Once the data is processed using the provided code, importing these data into the UDS A1 form in your REDCap project.
    * For reference, the Indiana ADRC has set the ADI fields in REDCap as read only, and included a note to alert users that the Data Core will fill in these data.


### Required Input Variables
Variable	| Format	| Description
----------|---------|------------
id	|Numeric or Character	|Participant Unique ID.
street	|Character	|Street address (required).
aptno	|Character	|Apartment number or secondary address if applicable.
city	|Character	|City (required)
state	|Character (XX)	|State abbreviation (required)
zip	|Numeric	|5-digit zip code
