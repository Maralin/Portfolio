SELECT * 
FROM sample.nashvillehousing;

# Standardize Date formate
SELECT Sale_Date, CONVERT(SaleDate, date) 
FROM sample.nashvillehousing;

Update sample.Nashvillehousing
Set SaleDate = CONVERT(SaleDate, date) ;

ALTER table sample.Nashvillehousing
Add Sale_Date DATE;

Update sample.Nashvillehousing
Set Sale_Date= CONVERT(SaleDate, date) ;

# Populate the Address data #Replace null when ParcelID already exist with an property address
Select first.ParcelID, first.PropertyAddress, second.ParcelID, second.PropertyAddress, IFNULL(first.PropertyAddress, second.PropertyAddress)
From sample.Nashvillehousing as first
Join sample.Nashvillehousing as second
	On first.ParcelID = second.ParcelID
    and first.UniqueID <> second.UniqueID
Where first.PropertyAddress is null;

Update sample.Nashvillehousing as first
	Join sample.Nashvillehousing as second
		On first.ParcelID = second.ParcelID
        and first.UniqueID <> second.UniqueID
Set first.PropertyAddress = IFNULL(first.PropertyAddress,second.PropertyAddress)
Where first.PropertyAddress is null;

# Breaking down the Property address into individual colums (Address, City, State) 
Select Substring(PropertyAddress, 1, locate(',', PropertyAddress) -1) as Address, #-1 to get rid of the comma
Substring(PropertyAddress, locate(',', PropertyAddress) +1, length(PropertyAddress)) as Address
From sample.nashvillehousing;

ALTER table sample.Nashvillehousing
Add Property_Street_Address varchar(255);

Update sample.Nashvillehousing
Set Property_Street_Address= Substring(PropertyAddress, 1, locate(',', PropertyAddress) -1);

ALTER table sample.Nashvillehousing
Add City varchar(255);

Update sample.nashvillehousing
Set City = Substring(PropertyAddress, locate(',', PropertyAddress) +1, length(PropertyAddress));

# Breaking down the OWNER address into individual colums (Address, City, State) 
Select Substring(OwnerAddress, 1, locate(',', OwnerAddress) -1),
   If(  length(OwnerAddress) - length(replace(OwnerAddress, ' ', ''))>1,  
       SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ' ', -1) ,NULL) 
           as Owner_city,
   SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ' ', -1) AS Owner_State
From sample.nashvillehousing;

ALTER table sample.Nashvillehousing
Add Owner_Address varchar(255);

Update sample.Nashvillehousing
Set Owner_Address= Substring(OwnerAddress, 1, locate(',', OwnerAddress) -1);

ALTER table sample.Nashvillehousing
Add Owner_city varchar(255);

Update sample.Nashvillehousing
Set Owner_city =
If( length(OwnerAddress) - length(replace(OwnerAddress, ' ', ''))>1,  
       SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ' ', -1) ,NULL) ;

ALTER table sample.Nashvillehousing
Add Owner_State varchar(255);

Update sample.Nashvillehousing
Set Owner_State= SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ' ', -1);

#Change Y and N to Yes and No in "Sold as Vacant" field
Select distinct(SoldasVacant), Count(SoldasVacant)
From sample.Nashvillehousing
Group by SoldasVacant
Order by 2;

Select SoldasVacant, 
Case when SoldasVacant = 'Y' Then 'YES'
	When SoldasVacant = 'N' Then 'NO'
    Else SoldasVacant
    End
 From sample.Nashvillehousing;   

Update sample.nashvillehousing
Set SoldasVacant = Case when SoldasVacant = 'Y' Then 'YES'
	When SoldasVacant = 'N' Then 'NO'
    Else SoldasVacant
    End;
    
# Delete Unused Columns
ALTER TABLE sample.nashvillehousing
drop column OwnerAddress,
drop column TaxDistrict, 
drop column PropertyAddress, 
drop column SaleDate;









