#!/bin/bash

cat << "EOF"

⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣾⣿⣿⣿⣿⣷⣶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄⠀⠀⠀⠀⠀
⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀
⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⠟⠿⠿⡿⠀⢰⣿⠁⢈⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀
⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣤⣄⠀⠀⠀⠈⠉⠀⠸⠿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀
⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⢠⣶⣶⣤⡀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⡆
⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠼⣿⣿⡿⠃⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣷
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⢀⣀⣀⠀⠀⠀⠀⢴⣿⣿⣿⣿⣿⣿⣿⣿⣿
⢿⣿⣿⣿⣿⣿⣿⣿⢿⣿⠁⠀⠀⣼⣿⣿⣿⣦⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⡿
⠸⣿⣿⣿⣿⣿⣿⣏⠀⠀⠀⠀⠀⠛⠛⠿⠟⠋⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⠇
⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⣤⡄⠀⣀⣀⣀⣀⣠⣾⣿⣿⣿⣿⣿⣿⣿⡟⠀
⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣄⣰⣿⠁⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀
⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀
⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⢿⣿⣿⣿⣿⡿⠿⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀
EOF

echo -e "\nnodestats v1.0 - https://github.com/alexandre-pecorilla/nodestats\n"

# Fetch data
blockchaininfo=$(bitcoin-cli getblockchaininfo)
networkinfo=$(bitcoin-cli getnetworkinfo)
getinfo=$(bitcoin-cli -getinfo)
peerinfo=$(bitcoin-cli getpeerinfo)
uptime=$(bitcoin-cli uptime)

# Parse data
blocks=$(echo "$blockchaininfo" | jq -r '.blocks')
headers=$(echo "$blockchaininfo" | jq -r '.headers')
difficulty=$(echo "$blockchaininfo" | jq -r '.difficulty')
chain=$(echo "$blockchaininfo" | jq -r '.chain')

connections=$(echo "$networkinfo" | jq -r '.connections')
version=$(echo "$networkinfo" | jq -r '.subversion' | awk -F: '{print $2}' | tr -d '/')
relay_fee=$(echo "$networkinfo" | jq -r '.relayfee')
p2p_onion_address=$(echo "$networkinfo" | jq -r '.localaddresses[] | select(.address | contains(".onion")) | "\(.address):\(.port)"')

blockchain_size=$(du -sh ~/.bitcoin/blocks 2>/dev/null | awk '{print $1}')
progress=$(echo "$getinfo" | grep "Verification progress:" | sed 's/Verification progress: //')

uptime_formatted=$(echo "$uptime" | awk '{print int($1 / 3600) "h " int(($1 % 3600) / 60) "m"}')

mempool_txs=$(bitcoin-cli getmempoolinfo | jq -r '.size')

peer_addresses=$(echo "$peerinfo" | jq -r '[.[] | select(.addr | contains(".onion")) | .addr] | join("\n")')

# Output data
echo -e "\nSync Progress: $progress\n"

echo "Bitcoin Core Version: $version"
echo "Chain: $chain"
echo "P2P Address: $p2p_onion_address"
echo -e "Node Uptime: $uptime_formatted\n"

echo "Blocks Synced: $blocks"
echo "Current Height: $headers"
echo -e "Blockchain Size: $blockchain_size\n"

echo "Difficulty: $difficulty"
echo -e "Mempool Transactions: $mempool_txs\n"
#echo "Min Relay Fee: $relay_fee BTC/kB"

echo "Peers: $connections"
echo -e "Peer Addresses:\n"
echo -e "$peer_addresses"


