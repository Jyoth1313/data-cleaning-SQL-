--Cleaning Data in SQL Queries



Select *
From housing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From housing


Update housing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update housing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From housing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From housing a
JOIN housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From housing a
JOIN housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From housing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From housing


ALTER TABLE housing
Add PropertySplitAddress Nvarchar(255);

Update housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housing
Add PropertySplitCity Nvarchar(255);

Update housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From housing





Select OwnerAddress
From housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From housing



ALTER TABLE housing
Add OwnerSplitAddress Nvarchar(255);

Update housing
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housing
Add OwnerSplitCity Nvarchar(255);

Update housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE housing
Add OwnerSplitState Nvarchar(255);

Update housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From housing

-- change Y or N to YES TO NO "sold as vacant"

select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from housing
group by SoldAsVacant
order by 2




select SoldAsVacant
, case when SoldAsVacant = 'y' then 'yes'
		when SoldAsVacant = 'n' then 'No'
		else SoldAsVacant
		end
from housing

update housing
set SoldAsVacant = case when SoldAsVacant = 'y' then 'yes'
		when SoldAsVacant = 'n' then 'No'
		else SoldAsVacant
		end


		-- avoiding (removing) duplicate


with RowNumCTE as(
select *,
ROW_NUMBER() over (
partition by parcelID, 
			 propertyAddress,
			 Saleprice,
			 SaleDate,
			 LegalReference
			 ORDER BY
				UniqueID
				)row_num

from housing
)
select * 
from RowNumCTE
where row_num >1
--order by PropertyAddress



-- delete unused coloumns 

select *
from housing


alter table housing
drop column OwnerAddress, TaxDistrict,propertyAddress


alter table housing
drop column SaleDate

alter table housing
drop column SaleDateconverted

















