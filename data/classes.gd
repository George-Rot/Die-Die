extends Resource
class_name Classes

enum ClassType { ARQUEIRO, CAVALEIRO, MAGO, ASSASSINO }

static func allowed_slots(ct:ClassType) -> Array[String]:
	match ct:
		ClassType.ARQUEIRO:
			return ["calcas","armadura","capacete","arco","adaga"]
		ClassType.CAVALEIRO:
			return ["calcas","armadura","capacete","espada_longa","adaga"]
		ClassType.MAGO:
			return ["calcas","armadura","capacete","cajado","adaga"]
		ClassType.ASSASSINO:
			return ["calcas","armadura","capacete","adaga","arco"]
	return []
