--cleaning in sql queries

select *
from PortfolioProjects..NashvilleHousing


------------------------------------------------------------------------
-- standardize date format

select saledate
from PortfolioProjects..NashvilleHousing

select SaleDateConverted, convert(date, saledate)
from PortfolioProjects..NashvilleHousing

update NashvilleHousing
set saledate = convert(date, saledate)

alter table NashvilleHousing
Add SaleDateconverted date;

update nashvilleHousing
set SaleDateconverted = convert(date, saledate)

---------------------------------------------------------------------------
-- Populate property adress data

select *
from PortfolioProjects..NashvilleHousing
--where propertyaddress is null
order by parcelid


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProjects..NashvilleHousing as a
join PortfolioProjects..NashvilleHousing as b
on a.ParcelID = B.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress IS NULL


update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProjects..NashvilleHousing as a
join PortfolioProjects..NashvilleHousing as b
on a.ParcelID = B.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress IS NULL


-----------------------------------------------------------------------------------------------
-- Breaking out Address into Individual columns(Address, State, City)

select *
from PortfolioProjects..NashvilleHousing
--where propertyaddress is null
--order by parcelid

select 
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address,
SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress)+1,len(propertyaddress)) as City
from PortfolioProjects..NashvilleHousing

alter table NashvilleHousing
Add PropertysplitAddress Nvarchar(255)

update nashvilleHousing
set PropertysplitAddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

alter table NashvilleHousing
Add PropertysplitCity Nvarchar(255)

update nashvilleHousing
set PropertysplitCity = SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress)+1,len(propertyaddress))


select *
from PortfolioProjects..NashvilleHousing

select
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProjects..NashvilleHousing


alter table NashvilleHousing
Add OwnersplitAddress Nvarchar(255)

update nashvilleHousing
set OwnersplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

alter table NashvilleHousing
Add OwnersplitCity Nvarchar(255)

update nashvilleHousing
set OwnersplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

alter table NashvilleHousing
Add OwnersplitStates Nvarchar(255)

update nashvilleHousing
set OwnersplitStates = PARSENAME(Replace(OwnerAddress,',','.'),1)


-- change Y & N TO YES AND NO in "SoldAsVacant" Field


select DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProjects..NashvilleHousing
GROUP BY SoldAsVacant
order by 2

select SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
END
from PortfolioProjects..NashvilleHousing


Update NashvilleHousing
set SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
END

---------------------------------------------------------------------------
-- Remove Duplicates

WITH Row_numCTE AS
(
Select*,
	ROW_NUMBER()
	OVER(PARTITION BY
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		Order by UniqueID) AS Row_num

from PortfolioProjects..NashvilleHousing
--order by ParcelID
)

SELECT*
from Row_numCTE
WHERE Row_num > 1
--order by PropertyAddress

---------------------------------------------------------------
-- Delete Unused columns

select*
from PortfolioProjects..NashvilleHousing

Alter Table  PortfolioProjects..NashvilleHousing
drop column PropertyAddress,OwnerAddress, TaxDistrict

Alter Table  PortfolioProjects..NashvilleHousing
drop column SaleDate


