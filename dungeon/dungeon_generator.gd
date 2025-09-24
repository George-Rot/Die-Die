extends Node

var mapas_disponiveis := []
var mapas_utilizados := []

func inicializar_mapas():
	mapas_disponiveis.clear()
	mapas_utilizados.clear()
	for i in range(1, 16):
		mapas_disponiveis.append("mapa" + str(i))

func escolher_masmorra():
	if mapas_disponiveis.size() == 0:
		push_warning("Todos os mapas já foram utilizados.")
		return null
		
	var index = randi() % mapas_disponiveis.size()
	var mapa_escolhido = mapas_disponiveis[index]
	mapas_disponiveis.remove_at(index)
	mapas_utilizados.append(mapa_escolhido)
	return mapa_escolhido
