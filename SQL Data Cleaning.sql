Select *
From [dbo].[NVHousing];

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From [dbo].[NVHousing];

Update [dbo].[NVHousing]
SET SaleDate = CONVERT(Date,SaleDate);

ALTER TABLE NVHousing
Add SaleDateConverted Date;

Update NVHousing
SET SaleDateConverted = CONVERT(Date,SaleDate);

--Populate Property Address Data

Select *
 From [dbo].[NVHousing]
 --Where PropertyAddress is 
 order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[NVHousing]a
JOIN[dbo].[NVHousing] b
 on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;

Update a
SET propertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[NVHousing]a
JOIN[dbo].[NVHousing] b
 on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;
-----------------------------------------------------------------------------------------
--Breaking out Address into Individual Columns (Address, City, State)

 Select PropertyAddress
 From [dbo].[NVHousing]
 --Where PropertyAddress is null
 --order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [dbo].[NVHousing];

ALTER TABLE NVHousing
Add PropertySplitAddress Nvarchar(255);

Update NVHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE NVHousing
Add PropertySplitCity Nvarchar(255);

Update NVHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From [dbo].[NVHousing];

Select OwnerAddress
From [dbo].[NVHousing];

Select 
PARSENAME(REPLACE(OwnerAddress,',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress,',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)
From [dbo].[NVHousing];


ALTER TABLE NVHousing
Add OwnerSplitAddress Nvarchar(255);

Update NVHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') , 3)

ALTER TABLE NVHousing
Add OwnerSplitCity Nvarchar(255);

Update NVHousing
SET PropertySplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') , 2)


ALTER TABLE NVHousing
Add PropertySplitAddress Nvarchar(255);

Update NVHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)


Select *
From [dbo].[NVHousing];

----------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [dbo].[NVHousing]
Group by SoldAsVacant
Order by 2;

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From [dbo].[NVHousing];

Update NVHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END;


-------------------------------------------------------------------------------

--Remove Duplicates

With RowNumCTE AS(
Select *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				     UniqueID
					 ) row_num
				
From [dbo].[NVHousing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;


Select *
From [dbo].[NVHousing];

--------------------------------------------------------------------------

--Delete Unused Columns

Select *
From [dbo].[NVHousing];

Alter TABLE [dbo].[NVHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress; 

Alter TABLE [dbo].[NVHousing]
DROP COLUMN SaleDate;











