# Stronghold

Welcome to Stronghold! I made this mod to respond to the frequent requests of a base building aspect in Battle Brothers. In this document, you’ll get an overview of various aspects of the mod.


## How to install the mod

Like most other Battle Brothers mods, just download the .zip file and place it in the Battle Brothers/data/ folder. Do not unzip the contents of the file, keep them as a zip. If you’ve got the game on Steam, you can right-click it in the library and go to manage -> browse local files to quickly find the install location.
You’ll also need [modding script hooks](https://www.nexusmods.com/battlebrothers/mods/42) mod, as well as [MSU](https://www.nexusmods.com/battlebrothers/mods/479).
Furthermore, you’ll need at least the Blazing Deserts DLC, and probably some of the other major ones. I haven't really tested it without the DLC.

## How to build your first base
To be able to build your first base, you’ll need to open the retinue menu. You’ll find the icon of a stronghold in the top left. Click on it.

You’ll be greeted by an overview page, giving you some information about the requirements and uses.

A fulfilled requirement will have a green font, a missing one a red font. Being able to build a port is not a requirement.
You’ll also need over 500 renown, a number of crowns, can’t be on an occupied tile with a town or other things on it, and you can’t have an active contract.
If you fulfill all the requirements, you’ll be able to click the Yes button:

After accepting, your new base will appear at your current location. You’ll also get a contract, which states that enemies will attack you. These enemies hail from the closest lair or settlement to your base. Nobles are included, unless you have more than 70 relation with them. A small band of mercenaries will spawn to assist you in the battle, and wait for the enemies at your base.

Make sure to meet the attackers around your base, so that the mercenaries can join you, and you’ll be fighting on a special terrain.
Once all attacks have been repelled, your base is now completed.

## Base management
To access your base, click on the castle icon in the background.
Stronghold features a fully realized UI screen in which you can manage your base, with the following pages:

### Overview
This page gives you an overview of your base.
The top shows the current name of your base. Change the text and press enter to change the name.
In the top right corner, you'll see what has been gained since you last entered your base. (More on that in the [locations](#locations) page.)
In the middle, you can find any current events, should there be any.
On the bottom, you can find some settings that apply to this base.

### Visuals
In this page, you can change the look of your base on the map. This is purely cosmetic.

### Warehouse
The warehouse page shows the items that are stored in your base. By default, you start with a little warehouse (level 0). You can increase this [location](#locations) to increase the size.

### Roster
This is unlocked by building the [troop quarters](#troop-quarters) location. Here, you can leave brothers at the base, to be retrieved later. Stored brothers cost less wage and their mood adapts to their surroundings; you can read the specifics in the Troop Quarters [location](#location).

### Buildings
In this page, you can add buildings to your base. The buildings work the same as the vanilla buildings. The amount of buildings you can add is determined by your [base tier](#tiers).
Some buildings have extra requirements, which are shown in the requirements rider.

### Locations
Here, you can add locations to your base. Locations are external "buildings" that are connected to your base via road. They provide the same advantages as vanilla locations (such as increasing items in shops or available recruits).  
Locations also have custom effects. Locations have up to four levels, where each level increases the effect. The information tab shows you the current and the next effect. Location level depends on your [base tier](#tiers). The little number next to the location image shows the current level.  
Like buildings, the amount of locations you can add also depends on your base tier.

### Upgrade
This page allows you to upgrade your base to the next [tier](#tiers), if you fulfill the requirements.

### Miscellaneous
This menu gathers a number of other options that are locked behind upgrades or quest rewards.

#### Building roads
Starting at the second level of your base, you can build roads to other settlements. You’ll see a number of options, depending on how many unconnected settlements are nearby. The price depends on the amount of road tiles that have to be built. Once you’ve built a road to another settlement, these mechanics will be unlocked:
- Patrols: Your base will send out mercenary patrols to friendly settlements
- Caravans: Other factions that you’re friendly with can send caravans to your base. This will give your base a buff to the inventories of stores, amounting to 5% extra items. Furthermore, your base will also send out caravans to other settlements. They will gather food items produced by the town, and return to deposit it in your storage. If the town does not produce any specific food items, it will still fetch bread and grains
- [Sending Gifts](#Sending-gifts)
- Training brothers hiring mercenaries and creating the water of life are [quest](#quest) features.

#### Sending gifts
Once you’ve connected your base to other settlements, you can send gifts to noble factions. This requires treasures in your inventory or the storage of the base. The items will be loaded on a caravan, which will set out towards the faction of choice. Once it’s arrived, an event will tell you about the reputation you’ve gained. It is equal to 5% of the market value of the treasures.


## Tiers
A base starts out as an Outpost, which is tier 1. You can upgrade to three other tiers: Fort, Castle, and finally Stronghold.
Each tier unlocks some additional resources and features.
Upgrading to the next tier requires a certain amount of renown, costs crowns, and requires your warehouse to be upgraded to the same level.
Upgrading, much like building your base, causes enemies to attack you. The number of attacks is equal to the level you're upgrading to.
While upgrading, most other functions of your base will be disabled.

## Other features
### Effect Radius
The effect radius is the white circle around your base. It shows the range in which certain effects, such as the buff from the wheat field or the detection ability from the watchtower, take place. The radius is increased by upgrading the base.

### The Hamlet
The hamlet is a village connected to your base. It is built after upgrading your base to a Stronghold. The hamlet has fewer features than a base; the main advantage is another recruit pool and being able to add buildings.

### Base attacks
Any enemy bases within the [effect radius](#effect-radius) of the base will periodically send attacks towards your base. Nobles will not attack you, even if they are your enemies.
If you have a watchtower location, you will be informed of the imminent attack.
After waiting for a while, the enemies will march towards your base. Your guards will try to defeat them.
If the attackers win or the guards are indisposed, they will start to raid the base. This will take a while; but if they succeed in doing so, the base will get the Raided debuff. Apart from the usual vanilla effects, this situation will disable most of your base abilities.
You can pay crowns to rebuild the base, or wait the effect out.
You can disable base attacks entirely in the mod settings menu.

### Reforging items
After you have built an ore smelter, you can reforge named items. This essentially re-rolls the stats on the item. To do so, enter your warehouse, and shift-rightclick the named item.

### Item overflow
Item overflow happens when you gain more items (from the collector location, caravans and such) than your warehouse can show. It is signified with an exclamation mark event in the top right. Claim your items before leaving the base, or any that don't fit your warehouse or player stash are gone forever.

### Additional bases
You can have more than one base. Each tier of a base adds 500 renown to the cost of the next base or upgrade. For example:
- You already have a Stronghold (tier 4). Building another base requires (4 * 500 + 1 * 500 = ) 2500 renown.
- You have an Outpost (tier 1). Building another Outpost requires (1 * 500 + 1 * 500 =) 1000 renown.

### Quests
After leveling up your base to a Castle (tier 3), three contracts will be made available. These feature tough battles, they are to be considered endgame content. After completing each contract, a specific feature will be unlocked.
Free the mercenaries: After completing this contract, you will be able to hire mercenaries to follow you around. These mercenaries will stay for a week, and join you in battles (excluded: legendary locations).
Buy water of life: You will be able to buy a water of life for 20000 crowns. With this, you can heal brothers of permanent wounds.
Recruit the trainer: A special training regimen will be made available. This will add one talent star to a brother.

### The boon:
The base has a permanent settlement situation that changes prices and inventories of merchants. While it starts out as a negative in an Outpost, it increases to a substantial buff over the tiers:
- Outpost: 5% higher buying price, 5% lower selling price, no changes to inventory
- Fort: no changes to buying and selling prices, 4% better inventory
- Castle: 5% lower buying price, 5% higher selling price, 8% better inventory
- Stronghold: 10% lower buying price, 10% higher selling price, 12% better inventory

### Guards
Your base will naturally hire mercenaries to defend it. They will spawn once a week, and patrol around your attached locations. They will attack enemy parties, and will join you in fights close to them. They won’t stray too far from the base.

### Settings
Thanks to MSU, many balancing factors of the mod are available to be changed in the Mod Settings menu. Do note that I did not test these settings; while they are all used in the mod, changing them outside of expected parameters might negatively affect your experience.
You can notify me on the [BB mod server](https://discord.gg/E4K2JZ5KM4) if you want more settings to be available.


That’s it! If you need clarification or think that this guide lacks things, write to me on [Nexus](https://www.nexusmods.com/battlebrothers/mods/324) or [Discord](https://discord.gg/E4K2JZ5KM4). Thanks for playing, and thanks to all the people that have reported bugs and given suggestions during the development progress.

### Credits:
Necro for the Roster tab (I stole his PokeBro mod)
Luft for the new base visual assets
