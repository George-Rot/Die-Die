# Sistema de Menu e Seleção de Personagem

## Funcionalidades Implementadas

### Menu Principal
- **Localização**: `menu/MainMenu.tscn`
- **Script**: `menu/MainMenu.gd`
- **Botões**:
  - **Novo Jogo**: Vai para a tela de seleção de personagem
  - **Hall da Fama**: Abre o hall da fama (se existir)
  - **Sair**: Encerra o jogo

### Seleção de Personagem
- **Localização**: `menu/CharacterSelection.tscn`
- **Script**: `menu/CharacterSelection.gd`

#### Classes Disponíveis:

1. **CAVALEIRO**
   - Vitalidade: 15
   - Força: 10  
   - Agilidade: 6
   - *Descrição*: Tanque resistente com alta vitalidade

2. **ARQUEIRO**
   - Vitalidade: 8
   - Força: 12
   - Agilidade: 15
   - *Descrição*: Balanceado com boa agilidade

3. **BANDIDO**
   - Vitalidade: 6
   - Força: 10
   - Agilidade: 20
   - *Descrição*: Rápido com muitos ataques

### Sistema de Stats

#### Como funciona:
- Quando um personagem é selecionado, seus stats são armazenados no `GameManager.selected_character`
- Ao entrar no mapa, os stats são aplicados ao player automaticamente
- O sistema de batalha usa esses stats para calcular HP, dano e múltiplos ataques

#### Fórmulas:
- **HP Máximo**: `Vitalidade × 10`
- **Ataque Poderoso**: `Força + (Força ÷ 2)`
- **Ataque Ágil**: Número de tentativas = `Agilidade`
- **Defesa**: Overshield = `Vitalidade × 0.75`

### Controles no Jogo
- **WASD ou Setas**: Movimento do player
- **ESC**: Voltar ao menu principal (do mapa)
- **Colisão com Enemy**: Iniciar batalha

### Navegação de Cenas
1. `MainMenu.tscn` → `CharacterSelection.tscn` → `Map1Test.tscn`
2. Durante o jogo: `Map1Test.tscn` ↔ `batalha_slime.tscn`
3. ESC no mapa: volta para `MainMenu.tscn`

### Arquivos Modificados
- `project.godot` - Definida cena inicial como MainMenu
- `script/game_manager.gd` - Adicionado sistema de seleção de personagem
- `maps/Map1Test.gd` - Aplicação automática de stats
- `menu/MainMenu.gd` - Correção de referências de botões
- `scenes/batalha_slime.gd` - Sistema de batalha validado e funcional

### Como Testar
1. Execute o projeto
2. Selecione "Novo Jogo" no menu
3. Escolha um dos três personagens
4. Jogue no mapa e teste a batalha
5. Use ESC para voltar ao menu e testar outros personagens
