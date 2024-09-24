
--Cleaning Data in Sql Queries


Select * 
From HousingData.dbo.mainTable

--------------------------------------------------------------------------------------------
-- Standardize Dat3 Fromat

Select SaleDate
From  HousingData.dbo.mainTable

Select SaleDate, CONVERT(Date,SaleDate)
From  HousingData.dbo.mainTable				
HousingData.dbo.mainTable
Update HousingData.dbo.mainTablele
SET  SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE  HousingData.dbo.mainTable
ADD SaleDateConverted Date;

Update ..dbo.mainTable
SET  SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date,SaleDate)
From  HousingData.dbo.mainTable

--------------------------------------------------------------------------------------------

-- Populate Property Address Data

Select PropertyAddress
From HousingData.dbo.mainTable

-- Getting null values in PropertyAddress Column
Select PropertyAddress
From HousingData.dbo.mainTable
Where PropertyAddress Is Null

Select *
From HousingData.dbo.mainTable
Where PropertyAddress Is Null


Select *
From HousingData.dbo.mainTable
Order By ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
From HousingData.dbo.mainTable a
Join HousingData.dbo.mainTable b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]  -- <> operator means not equal to in MS SQL.
Where a.PropertyAddress Is Null 


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingData.dbo.mainTable a
Join HousingData.dbo.mainTable b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]  -- <> operator means not equal to in MS SQL.
Where a.PropertyAddress Is Null 

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingData.dbo.mainTable a
Join .. mainTable b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress Is Null

------------------------------------------------------------------------------------------
-- Breaking out Address into indinvidual columns(Address,City,State)
Select PropertyAddress
From  HousingData.dbo.mainTable

--Break PropertyAddress to only Address
Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as Address
From ..dbo.mainTable

-- find index no of ','
Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as Address,
CHARINDEX(',',PropertyAddress)
From ..dbo.mainTable

-- Remove ',' from last 
Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
From ..dbo.mainTable

--Break PropertyAddress Address and city
Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
From HousingData.dbo.mainTable

-------------------------------- Add new column to main table -----------------
ALTER TABLE mainTable
Add PropertySplitAddress Nvarchar(255);

Update HousingData.dbo.mainTable
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE mainTable
Add PropertySplitCity Nvarchar(255)

Update HousingData.dbo.mainTable
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

-- verify changing in main table
Select * 
From ..dbo.mainTable

----- Breaking OwnerAddress (Column into Address,city,state) Using PARSENAME

Select OwnerAddress
From HousingData.dbo.mainTable

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From HousingData.dbo.mainTable

-------------------------------- Add new column of OwnerAddress to main table -----------------
ALTER TABLE mainTable
Add OwnerSplitAddress Nvarchar(255);

Update HousingData.dbo.mainTable
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE mainTable
Add OwnerSplitCity Nvarchar(255)

Update HousingData.dbo.mainTable
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE mainTable
Add OwnerSplitState Nvarchar(255)

Update HousingData.dbo.mainTable
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

-- verify changing in main table
Select * 
From  HousingData.dbo.mainTable


--------------------------------------------------------------------------------------------------
--Change Y and N into Yes and No  in "SoldAsVacant" field

--check difference in field
Select Distinct(SoldAsVacant)
From  HousingData.dbo.mainTable

--Count total differnce fields
Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From  HousingData.dbo.mainTable
Group By SoldAsVacant
--Order By SoldAsVacant
Order By 2

-- convert Yes to yes and N to No
Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'N0'
	   Else SoldAsVacant
	   End
From  HousingData. dbo.mainTable

-- Update the field
Update  HousingData.dbo.mainTable
Set SoldAsVacant =  Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
-----------------------------------------------------------------
-- Remove Duplicates

Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference,
				 SaleDate
				 ORDER BY
					UniqueID
					) row_num
From  HousingData.dbo.mainTable
ORDER BY  ParcelID
--
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference,
				 SaleDate
				 ORDER BY
					UniqueID
					) row_num
From  HousingData.dbo.mainTable
)
Select *
From RowNumCTE
--
--
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference,
				 SaleDate
				 ORDER BY
					UniqueID
					) row_num
From  HousingData.dbo.mainTable
)
Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress
--
--
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference,
				 SaleDate
				 ORDER BY
					UniqueID
					) row_num
From  HousingData.dbo.mainTable
)
Delete
From RowNumCTE
Where row_num > 1

--
--
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference,
				 SaleDate
				 ORDER BY
					UniqueID
					) row_num
From  HousingData.dbo.mainTable
)
Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress

--
Select *
From  HousingData.dbo.mainTable


----------------------------------------------------------------------------------------
-- Delete Unused Columns

Select *
From  HousingData.dbo.mainTable

ALTER TABLE  HousingData.dbo.mainTable
DROP COLUMN OwnerAddress, PropertyAddress,TaxDistrict

ALTER TABLE  HousingData.dbo.mainTable
DROP COLUMN SaleDate


Select *
From  HousingData.dbo.mainTable