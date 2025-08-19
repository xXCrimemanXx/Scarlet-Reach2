/datum/skill/combat
	abstract_type = /datum/skill/combat
	name = "Combat"
	desc = ""
	dream_cost_base = 2
	dream_cost_per_level = 1
	max_skillbook_level = 3

/datum/skill/combat/knives
	name = "Knife-fighting"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with knives, and your chance to bypass dodge by 10%. At Apprentice or above, you will not fumble while taking out knives from a bandolier."
	dreams = list(
		"...a barkeep whistles as he cleans glasses and a drunkard snores, passed out on the counter. The rest of the tavern focuses on you with bated breath as your dagger darts between your fingers in an impressive display of legerdemain...",
		"...a flash of steel through the sky, and another, and another. Blades pass between your juggling hands as if you were pulling on singular, thick rope...",
		"...you tuck the blade away in your cloak, and offer yourself up for inspection. While small, the invisible blade cannot be parried..."
	)


/datum/skill/combat/swords
	name = "Sword-fighting"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with swords, and your chance to bypass dodge by 10%."
	dreams = list(
		"...your heavy blade swings in a wide arc, cleaving through the air with a roar. Each landed strike hits with bone shattering force. Your opponent's shield crumples under the weight, and your blade finds its mark - crushing through armor, flesh, and will alike...",
		"...a shining length of ivory steel. A token. A symbol. More than just a weapon. Blood runs thick in the wash-bin. Sparks fly from the grindstone. You maintain the blade and it maintains your honour...",
		"...the rapier dances in your hand, a whisper of steel cutting through the air. Every thrust is precise, every parry and riposte flowing in perfect rhythm, simply awaiting the moment to seal your their fate with a single, fatal strike..."
	)

/datum/skill/combat/polearms
	name = "Polearms"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with polearms, and your chance to bypass dodge by 10%."
	dreams = list(
	"...the pale volf snaps its jaws, but to no avail. Your weapon has the superior reach and you jab at it with precision until it bleeds and retreats back into the woods...",
	"...armed with your trusty staff, you hike through the muck and mire with ease. It serves not only as a weapon but a tool, its sturdy length offering support as you press onward, unfazed by the thick, unrelenting muck...",
	"...the billhook hums through the air, its hooked blade striking with chilling precision. It rends through chain and leather. With each twist, your strikes become inevitable, seamless. A relentless dance of destruction, merciless and fluid..."
	)

/datum/skill/combat/maces
	name = "Maces"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with maces, and your chance to bypass dodge by 10%."
	dreams = list(
	"...darkness surrounds you. You smash, again and again against the walls, the ominous thuds ringing through your skull with each strike. The wall trembles and with a final earth-shaking smash, light breaks through and you emerge into freedom...",
	"...'I am ineffable. I am unpierceable.' The wicked white guardian says. And so, you shatter its skull in a single blow with your mace, for it was not unbludgeonable...",
	"...the air trembles with each of your mighty blows, each strike echoing like the final toll of a bell. This is your symphony. Revel in its brutal beauty, its crushing simplicity...",
	"...'This blade is a masterwork of Malum's craftsmanship,' the elf declared. Moments later his head was abruptly transformed into pavement decor under the crushing weight of your brutish tool..."
	)

/datum/skill/combat/axes
	name = "Axes"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with axes, and your chance to bypass dodge by 10%."
	dreams = list(
	"...bones are like trees. The bigger they are, the harder they fall. With a monstrous swing, the skeleton is decapitated and you have saved the town from its evil...",
	"...stuck in the flesh, you rip away at your weapon. It comes loose. Blood splatters across your armor and cloak and the side of your face. Hunting is no easy job, but the old man's teachings are effective...",
	"...your axe descends, and another tree falls. Wet sap runs down your face as you hack and chop relentlessly turning the forest into a thicket, then the thicket until it is an open plains. It's only when you pause and look down that you see the shattered bones, the torn flesh and the mangled faces. The town square has turned crimson, drenched in the aftermath of your fury...",
	"...the heft of iron pulls upon your arm. It knows where it wishes to be - all you have to do is guide its fall. Knowing this, your axe feels lighter than you remember...",
	"...despite the insurmountable challenge, you fear nothing, for the axe is thy companion eternal. Problem solving is quite simple, really..."
	)

/datum/skill/combat/whipsflails
	name = "Whips & Flails"
	desc = "Increases your chance to successfully parry and bypass your opponent's parry by 20% with whips or flails, and your chance to bypass dodge by 10%."
	dreams = list(
	"...the sing-song of your flail cleaves through the air and rouses something primal, but the down swing of your hand quickly puts it to sleep...",
	"...with a whistle and a snap and a crack, another bruise is left on flesh. With a sharp pull, you strike down again. They will be tamed..."
	)

/datum/skill/combat/bows
	name = "Archery"
	desc = "Alongside perception, increases the speed you draw back a bow and have it ready to shoot. Does not influence damage or chance to hit."
	dreams = list(
	"...the cold wind on the balcony bristles against your left so you adjust your aim towards it. Your fingers relax and your bow exhales a quiet sigh. Moments later, your mark drops to the cobblestone streets below. Dead...",
	"...your fingers sting as you let loose another arrow and it glances off the pale knight's breastplate. You aim at their visor and pray to whatever gods you hold dear that this one will make it through...",
	"...it takes half a minute for an experienced arbalist to cock and load a crossbow. You could kill five men with three arrows in half that time..."
	)

/datum/skill/combat/crossbows
	name = "Crossbows"
	desc = "Alongside perception, increases the speed you ready a crossbow and have it ready to shoot. Does not influence damage or chance to hit."
	dreams = list(
	"...you put your foot down and pull on the string. You wind the crossbow back with all your might. It feels like the thing is mocking you, impossible to pull taut. Only when a seasoned arbalist reminds you to pull from your back, and not your knees, do you make progress...",
	"...the crossbow is a deadly marvel of engineering, waiting for your guidance. You steady your breath, finger poised on the trigger. The world narrows as you take aim, the perfect shot soon to come..."
	)

/datum/skill/combat/wrestling
	name = "Wrestling"
	desc = "Alongside strength, improves your chance of grabbing, and avoiding a grab from an opponent."
	dreams = list(
	"...you grab him by the shirt and twist your hand with a mighty shove, working your opponent to the ground. The dirt fills your lungs but you feel his resistance give way as he coughs, a smile of approval crossing his face...",
	"...the dirt gets in your lungs and you can feel your legs quiver. You can't stand. You hear the clanking of plate, and see mighty boots stop in front of you. With a yank at their leg, your would-be killer is brought tumbling to the ground..."
	)

/datum/skill/combat/unarmed
	name = "Unarmed"
	desc = "Increases your chance to bypass your opponent's parry by 20% with unarmed or unarmed weapons such as katars, and your chance to bypass dodge by 10%. Parrying while unarmed does not work currently."
	dreams = list(
	"...the wet and harsh sound of skin against bone and clattering teeth reaches your ears before your mind processes what just happened. You got knocked out with a mighty blow to the jaw...",
	"...your nails are claws, your hands are weapons. A silent watcher in pale plate armor nods with approval at your ferocity..."
	)

/datum/skill/combat/shields
	name = "Shields"
	desc = "Increases your chance to bypass your opponent's parry by 20% with shields, and your chance to bypass dodge by 10%."
	dreams = list(
	"...a terrible lizard unleashes a torrent of fire upon you. Yet, you stand firm, a living bastion, unyielding and stalwart...",
	"...the half-moon crest upon your shield shines even in the bright of Astrata's day. You catch a gleam on it, and reflexively pull it upwards. An arrow bounces off..."
	)

/datum/skill/combat/slings
	name = "Slings"
	desc = "Alongside perception, increases the speed you ready a sling and have it ready to shoot. Does not influence damage or chance to hit."
	dreams = list(
	"...you recall an old maxim you read in a dusty tome within the archives: if you can throw, you can sling...",
	"...the perched archers ruthlessly repel the peasant rebellion. Hope for fairness is almost forlorn, until with a soft crack, a hailing of iron bullets clatter against the foe's helmets...",
	"...your arm tires from the toils of practice. Swinging rapidly has left your arm numb. With weary eyes, you glance aside to witness a hunter practice their craft with a brief overhand toss. Absorbing the technique, you mimic it, and effortlessly cast a powerful stone square onto the target..."
	)
