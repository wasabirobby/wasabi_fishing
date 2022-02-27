#wasabi_fishing

This resource was created as a free interactive fishing script for ESX servers.

<b>Features:</b>
- Skill bar based success
- Full animations and props
- Chance of fishing rod breaking upon failing skillbar(Can be changed in config.)
- Configurable fishing rewards(4 by default included)
- Configurable prices to sell fishing rewards for
- No job requirement
- Sell shop for fished items


## Installation

- Download this script
- Download this skillbar: https://github.com/WasabiRobby/skill-bar and re-name resource `skillbar`
- Put both script in your `resources` directory


- Import `wasabi_fishing_weight.sql` to your database if using weight based inventory.
- Import `wasabi_fishing_limit.sql` to your database if using limit based inventory.


- Add `ensure wasabi_fishing` and `ensure skillbar` in your `server.cfg`

### Extra Information
- Inventory images included in the `InventoryImages` directory
- You must add the item `fishingrod` and `fishbait` to one of your in-game shops or have a place for your players to obtain.

## Preview
- Fishing Preview: https://streamable.com/ta6q0m


# Support
Join our discord <a href='https://discord.gg/XJFNyMy3Bv'>HERE</a> for additional scripts and support!
