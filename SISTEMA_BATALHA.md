# Sistema de Batalha - Die&Die

## Funcionalidades Implementadas

### 🎯 **Detecção de Colisão**
- Player detecta automaticamente colisão com Enemy
- Transição automática para tela de batalha
- Sistema de prevenção contra múltiplas transições

### ⚔️ **Interface de Batalha**
- **Barra de vida**: Player (verde) e Enemy (vermelha)
- **Estatísticas**: HP atual/máximo exibido em tempo real
- **Sprites**: Player e Enemy posicionados na arena
- **Mensagens**: Feedback visual das ações

### 🎮 **Ações do Player**
1. **ATAQUE** (Dano: ~20)
   - Ataque normal com variação aleatória de dano
   - Maior dano, mas turno único

2. **ATAQUE RÁPIDO** (Dano: ~12)
   - Ataque mais fraco com menor variação
   - Dano consistente e rápido

3. **DEFENDER**
   - Reduz o próximo dano recebido em 10 pontos
   - Estratégia defensiva para sobreviver

4. **FUGIR**
   - Retorna ao mapa instantaneamente
   - Fuga sempre bem-sucedida

### 🤖 **IA do Enemy**
- **Ataque automático**: ~15 de dano com variação
- **Respeita defesa**: Reduz dano quando player se defende
- **Turno alternado**: Sistema clássico de RPG

### 📊 **Estatísticas**
```
PLAYER:
- HP: 100/100
- Ataque: 20 (±5 variação)
- Ataque Rápido: 12 (±3 variação)
- Defesa: 10 pontos de redução

SLIME:
- HP: 50/50
- Ataque: 15 (±3 variação)
```

### 🔄 **Fluxo de Batalha**
1. **Início**: Player escolhe ação
2. **Execução**: Ação do player é executada
3. **Turno Enemy**: Enemy ataca automaticamente
4. **Verificação**: Checa vitória/derrota
5. **Repetição**: Volta ao turno do player

### 🏁 **Condições de Fim**
- **Vitória**: Enemy HP chega a 0
- **Derrota**: Player HP chega a 0
- **Fuga**: Player escolhe fugir
- **Retorno**: Automático ao mapa após 2 segundos

### 🎨 **Visual Design**
- **Tema escuro**: Fundo azul escuro profissional
- **Botões estilizados**: Bordas e cores personalizadas
- **Layout responsivo**: Interface organizada em painéis
- **Feedback visual**: Barras de HP coloridas

## Como Testar

1. **Iniciar batalha**: Mova o player para colidir com o enemy no mapa
2. **Experimentar ações**: Teste cada botão (Ataque, Ataque Rápido, Defender, Fugir)
3. **Observar mecânicas**: Note a redução de HP e mensagens
4. **Testar finais**: Deixe o HP chegar a 0 ou fuja da batalha

## Arquivos Modificados

```
script/player_controller.gd  # Detecção de colisão
scenes/batalha_slime.tscn    # Interface de batalha
scenes/batalha_slime.gd      # Lógica de batalha
maps/Map1Test.gd            # Reset de triggers
```

## Próximas Expansões

- [ ] Sistema de experiência/level up
- [ ] Múltiplos tipos de inimigos
- [ ] Itens consumíveis na batalha
- [ ] Animações de ataque
- [ ] Efeitos sonoros
- [ ] Sistema de raridade de equipamentos
- [ ] Batalhas com múltiplos inimigos
