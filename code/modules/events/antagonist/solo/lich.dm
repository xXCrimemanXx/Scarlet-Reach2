/datum/round_event_control/antagonist/solo/lich
	name = "Lich"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_LICH
	shared_occurence_type = SHARED_HIGH_THREAT

	denominator = 80

	base_antags = 1
	maximum_antags = 2

	weight = 3	//i love you
	max_occurrences = 1

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/lich
	antag_datum = /datum/antagonist/lich

	restricted_roles = list(
		"Grand Duke",
		"Grand Duchess",
		"Consort",
		"Dungeoneer",
		"Sergeant",
		"Men-at-arms",
		"Marshal",
		"Merchant",
		"Priest",
		"Acolyte",
		"Martyr",
		"Templar",
		"Councillor",
		"Bandit",
		"Prince",
		"Princess",
		"Hand",
		"Steward",
		"Court Physician",
		"Town Elder",
		"Captain",
		"Loudmouth",
		"Knight",
		"Court Magician",
		"Inquisitor",
		"Orthodoxist",
		"Warden",
		"Squire",
		"Veteran",
		"Apothecary"
	)

/datum/round_event/antagonist/solo/lich
