############################################################################################################
###########################             Project Name                          ##############################
###########################                                                   ##############################
############################################################################################################

#############################################
#      Chia RPC MintFile Json Generator     #
#               VERSION 0.1                 #
#                 0xChunk                   #
#############################################

# Instructions: 
# 1.Copy this script into a folder you want to deploy from.
# 2.Make a new folder inside this folder called "xchMintJson".
# 3.Fill in the rest of the details in the "Collection Details" section.
# 4.Create an NFT wallet with DID on the chia cli (or a profile on the chia gui).
# 5.With the Chia cli run "chia wallet show" and find the id of the NFT wallet with the DID that you would like to deploy from.
# 6.Enter the wallet_id into this Deployment Details section.
# 7.Fill in the start and finish NFT that you'd like to convert

################ COLLECTION DETAILS ###########################
$xchMintJson_path = '.\xchMintJson\' # minting files will go in here
$data_uris_base = 'https://XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.ipfs.nftstorage.link/' # this is the 'gateway' address from NFT.storage for you images
$meta_uris_base = 'https://XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.ipfs.nftstorage.link/' # this is the 'gateway' address from NFT.storage for you metadata
$licence_uri = '' # if you have a licence file, you can put an IPFS hash to it here
$licence_hash = ''# if you have a licence, and uploaded it, put the hash of it here.
$royalty_address = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$royalty_percentage = 1000 # 1000 = 10.00%
$target_address = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$series_total = 1000
$fee = 615000000 #blockchain fee for miners to push your transaction through faster! 615000000 recommended when mempool is full

################ DEPLOYMENT DETAILS ###########################
$wallet_id = '3'
$converter_Start = 1
$converter_Finish = 100

#############################################################################################################################
##################################                SCRIPT BELOW                  #############################################
#############################################################################################################################

#Instantiate a WebClient object to retrieve ipfs files
$WebGet = [System.Net.WebClient]::new()
#loop from start to finish
for (($series_number = $converter_Start);  ($series_number -le $converter_Finish); ($series_number++))
     {
        Write-Output ('-------------------------------------------------------------------------')
        Write-Output ('SeriesNo: ' + $series_number.ToString())
        # set token and metadata filenames for this loop
        $data_file = $series_number.ToString() + '.png'
        $data_uris = $data_uris_base + $data_file
        $data_hash = (Get-FileHash -InputStream ($WebGet.OpenRead($data_uris))).Hash.Tolower()
        Write-Output ('Image Hash: '+ $data_hash)        
        
        $meta_file = $series_number.ToString() + '.json'
        $meta_uris = $meta_uris_base + $meta_file
        $meta_hash = (Get-FileHash -InputStream ($WebGet.OpenRead($meta_uris))).Hash.Tolower()
        Write-Output ('Metadata Hash: '+ $meta_hash)


        
        $minting = @"
{
"wallet_id": $wallet_id,
"uris": ["$data_uris"],
"hash": "$data_hash",
"meta_uris": ["$meta_uris"],
"meta_hash": "$meta_hash",
"license_uris": [],
"license_hash": [],
"royalty_address": "$royalty_address",
"royalty_percentage": $royalty_percentage,
"target_address": "$target_address",
"series_number": $series_number,
"series_total": $series_total,
"fee": $fee
}
"@
                Write-Output ($minting)
                Set-Content -Path ($xchMintJson_path + $meta_file) -Value $minting       


    }




