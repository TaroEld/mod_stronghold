::Stronghold.Building_options <-
[
	{
		Name = "Tavern",
		ID = "building.tavern",
		Cost = this.Stronghold.BuildingPrices["Tavern"],
		Path = "tavern_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Kennel",
		ID = "building.kennel",
		Cost = this.Stronghold.BuildingPrices["Kennel"],
		Path = "kennel_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Taxidermist",
		ID = "building.taxidermist",
		SouthID = "building.taxidermist_oriental",
		Cost = this.Stronghold.BuildingPrices["Taxidermist"],
		Path = "taxidermist_building",
		SouthPath = "taxidermist_oriental_building",
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && !(_contract.getHome().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Temple",
		ID = "building.temple",
		SouthID = "building.temple",
		Cost = this.Stronghold.BuildingPrices["Temple"],
		Path = "temple_building",
		SouthPath = "temple_oriental_building",
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && !(_contract.getHome().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Training Hall",
		ID = "building.training_hall",
		Cost = this.Stronghold.BuildingPrices["Training"],
		Path = "training_hall_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Alchemist",
		ID = "building.alchemist",
		Cost = this.Stronghold.BuildingPrices["Alchemist"],
		Path = "alchemist_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Weaponsmith",
		ID = "building.weaponsmith",
		SouthID = "building.weaponsmith_oriental",
		Cost = this.Stronghold.BuildingPrices["Weaponsmith"],
		Path = "weaponsmith_building",
		SouthPath = "weaponsmith_oriental_building",
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && !(_contract.getHome().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Armorsmith",
		ID = "building.armorsmith",
		SouthID = "building.armorsmith_oriental",
		Cost = this.Stronghold.BuildingPrices["Armorsmith"],
		Path = "armorsmith_building",
		SouthPath = "armorsmith_oriental_building",
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && !(_contract.getHome().hasBuilding(this.SouthID)))
		}
	},
	{
		Name = "Fletcher",
		ID = "building.fletcher",
		Cost = this.Stronghold.BuildingPrices["Fletcher"],
		Path = "fletcher_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID))
		}
	},
	{
		Name = "Port",
		ID = "building.port",
		Cost = this.Stronghold.BuildingPrices["Port"],
		Path = "port_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && _contract.getHome().isCoastal())
		}
	},
	{
		Name = "Arena",
		ID = "building.arena",
		Cost = this.Stronghold.BuildingPrices["Arena"],
		Path = "arena_building",
		SouthPath = false,
		isValid = function(_contract){
			return (!_contract.getHome().hasBuilding(this.ID) && _contract.getHome().m.Size == 3)
		}
	},
]
