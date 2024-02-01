

--1. Cleaning data

select *
from housing 

--standartize date format 

select SaleDate, convert(Date, SaleDate)
from housing

Update housing
set SaleDate = convert(Date, SaleDate) --didn't work not sure why? 

Alter Table housing
add SaleDateConverted Date;

Update housing
set SaleDateConverted = convert(Date, SaleDate);

select SaleDateConverted
from housing;

--Property address 
Select ParcelID,  PropertyAddress, OwnerAddress
from housing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from housing a
join housing b
on a.ParcelID=b.ParcelID
and a.UniqueID != b.UniqueID
where a.PropertyAddress is null;

Update a
set PropertyAddress=isnull(a.PropertyAddress, b.PropertyAddress)
from housing a
join housing b
on a.ParcelID=b.ParcelID
and a.UniqueID != b.UniqueID
where a.PropertyAddress is null;

select *
from housing 
where PropertyAddress is null;

--Seperating coloumn address 

select PropertyAddress, substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) 
from housing;

Alter Table housing
add Propertysplitaddress nvarchar(300);

Alter Table housing
add Propertysplitcity nvarchar(300);

update housing
set Propertysplitaddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);


update housing
set Propertysplitcity=
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) 
from housing;


Select * 
from housing;

--split owner address

select PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from housing;

Alter Table housing
add OwnersplitAddress nvarchar(300);

Alter Table housing
add Ownersplitcity nvarchar(300);

Alter Table housing
add Ownersplitstate nvarchar(300);

Update housing
set OwnersplitAddress= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

Update housing
set Ownersplitcity= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

Update housing
set Ownersplitstate= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

select * 
from housing;

--change Y to yes, N to No

select distinct(SoldAsVacant), count(SoldAsVacant) 
from housing
group by SoldAsVacant;

select SoldAsVacant,
case when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
End 
from housing;

update housing
set SoldasVacant= case when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
End 

--remove duplicates
select PropertyAddress, ParcelID, LegalReference, count(*)
from housing
group by PropertyAddress, ParcelID, LegalReference
having count(*)>1;

with RowNumCTE as(
select *,
ROW_NUMBER() over(partition by PropertyAddress, ParcelID, LegalReference
order by UniqueID) row_num 
from housing)
delete
from RowNumCTE
where row_num>1; 

--delete extra columns

alter table housing
drop column OwnerAddress, PropertyAddress

alter table housing
drop column SaleDate;








select *
from housing;