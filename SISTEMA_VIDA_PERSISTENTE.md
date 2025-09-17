# Sistema de Vida Persistente e Game Over

## Funcionalidades Implementadas

### Sistema de Vida Persistente
- **Vida do jogador se mantém entre batalhas**
- **Não reseta após cada combate**
- **Baseada na vida atual, não na vida máxima**

#### Como Funciona:
1. **Primeira Batalha**: Usa vida máxima (Vitalidade × 10)
2. **Batalhas Subsequentes**: Usa vida atual salva
3. **Vitória**: Vida atual é salva no GameManager
4. **Fuga**: Vida atual é salva no GameManager
5. **Derrota**: Vai para tela de Game Over

### Tela de Game Over
- **Localização**: `menu/GameOver.tscn`
- **Script**: `menu/GameOver.gd`
- **Aparece quando**: Player morre em batalha (HP = 0)

#### Botões Disponíveis:
- **CONTINUAR**: Reseta personagem e volta ao menu principal
- **MENU PRINCIPAL**: Reseta personagem e volta ao menu principal

#### Visual:
- Fundo escuro avermelhado
- Título "GAME OVER" em vermelho
- Mensagem explicativa
- Dois botões para escolha do jogador

### Sistema de Stats Persistentes

#### Vida Atual vs Vida Máxima:
- **Vida Máxima**: `Vitalidade × 10` (nunca muda)
- **Vida Atual**: Varia conforme dano recebido/curado
- **Persistência**: Vida atual é salva em `GameManager.player_stats_backup.vida_atual`

#### Fluxo de Persistência:
1. **Seleção de Personagem** → Define vida máxima
2. **Entrada no Mapa** → Recupera vida atual (se existe)
3. **Batalha** → Usa vida atual como HP inicial
4. **Fim da Batalha** → Salva vida atual restante
5. **Próxima Batalha** → Usa vida atual salva

### Funções Adicionadas ao GameManager

#### `update_player_vida(nova_vida: int)`
- Atualiza vida atual do player
- Salva em `player_stats_backup.vida_atual`
- Atualiza referência do player se existir

#### `reset_character_selection()`
- Reseta personagem selecionado
- Limpa backup de stats (incluindo vida)
- Remove referência do player
- **Usado no Game Over para forçar nova seleção**

### Controles no Mapa
- **WASD/Setas**: Movimento
- **ESC**: Voltar ao menu principal
- **H**: Mostrar status completo do player
- **Colisão com Enemy**: Iniciar batalha

### Status do Player (Tecla H)
Mostra no console:
- Vida Atual
- Vitalidade (e HP Máximo calculado)
- Força
- Agilidade
- Overshield atual

### Cenários de Teste

#### Cenário 1: Batalhas Consecutivas
1. Selecione personagem (ex: Cavaleiro - 150 HP)
2. Lute contra slime, termine com 100 HP
3. Saia e lute novamente
4. **Resultado**: Batalha inicia com 100 HP, não 150 HP

#### Cenário 2: Game Over
1. Selecione personagem
2. Perca batalha (HP = 0)
3. **Resultado**: Tela Game Over aparece
4. Clique "Continuar"
5. **Resultado**: Volta ao menu, deve selecionar personagem novamente

#### Cenário 3: Persistência entre Mapas
1. Selecione personagem, batalhe
2. Use ESC para voltar ao menu
3. Selecione "Novo Jogo" novamente
4. **Resultado**: Mantém vida atual do personagem anterior

### Arquivos Modificados
- `script/game_manager.gd` - Sistema de vida persistente
- `scenes/batalha_slime.gd` - Salva vida após batalhas
- `maps/Map1Test.gd` - Recupera vida atual no mapa
- `menu/GameOver.tscn` - Nova tela de game over
- `menu/GameOver.gd` - Script da tela de game over

### Debugging
- Logs detalhados em cada operação de vida
- Status completo disponível com tecla H
- Console mostra quando vida é salva/recuperada

O sistema agora oferece progressão real entre batalhas, onde o jogador deve gerenciar cuidadosamente sua vida, já que ela não reseta automaticamente!
