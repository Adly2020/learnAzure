#!/bin/bash



# Variables générales
resource_group=`az group list --query '[0].name' --output tsv`
location=`az group list --query '[0].location' --output tsv`
vnet1="VNet1"
vnet2="VNet2"
vnet3="VNet3"
subnet1="Subnet1"
subnet2="Subnet2"
subnet3="Subnet3"
vm_size="Standard_DS2_v2"
image_linux="Ubuntu2204"
image_winserver="Win2022Datacenter"
admin_username="azureuser"
admin_password="Administrator/"

# Créer le groupe de ressources
az group create --name $resource_group --location $location

# Créer la première VNet et deux VM Ubuntu
az network vnet create --resource-group $resource_group --name $vnet1 --address-prefix 10.1.0.0/16 --subnet-name $subnet1 --subnet-prefix 10.1.0.0/24

for i in 1 2; do
    az vm create \
        --resource-group $resource_group \
        --name UbuntuVM${i} \
        --image $image_linux \
        --size $vm_size \
        --vnet-name $vnet1 \
        --subnet $subnet1 \
        --admin-username $admin_username \
        --admin-password $admin_password \
        --generate-ssh-keys 
done
# Done
echo '--------------------------------------------------------'
echo '             Vnet 1 et VM Setup Completed'
echo '--------------------------------------------------------'

# Créer la deuxième VNet et une VM Ubuntu
az network vnet create --resource-group $resource_group --name $vnet2 --address-prefix 10.2.0.0/16 --subnet-name $subnet2 --subnet-prefix 10.2.0.0/24

az vm create \
    --resource-group $resource_group \
    --name UbuntuVM3 \
    --image $image_linux \
    --size $vm_size \
    --vnet-name $vnet2 \
    --subnet $subnet2 \
    --admin-username $admin_username \
    --admin-password $admin_password \
    --generate-ssh-keys 

# Done
echo '--------------------------------------------------------'
echo '             Vnet 2 et VM Setup Completed'
echo '--------------------------------------------------------'

# Créer la troisième VNet et une VM Windows Server 2022 Datacenter
az network vnet create --resource-group $resource_group --name $vnet3 --address-prefix 10.3.0.0/16 --subnet-name $subnet3 --subnet-prefix 10.3.0.0/24

az vm create \
    --resource-group $resource_group \
    --name WindowsVM \
    --image $image_winserver \
    --size $vm_size \
    --vnet-name $vnet3 \
    --subnet $subnet3 \
    --admin-username $admin_username \
    --admin-password $admin_password

# Done
echo '--------------------------------------------------------'
echo '             Vnet 3 et VM Setup Completed'
echo '--------------------------------------------------------'

echo "Toutes les machines virtuelles ont été créées avec succès."
