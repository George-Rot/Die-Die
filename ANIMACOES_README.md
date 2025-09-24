# Animações, Movimentação e Colisões - Die&Die

## Implementações Realizadas

### Player (script/player_controller.gd)
- **Movimentação suave** usando CharacterBody2D e move_and_slide()
- **Controles**: WASD ou setas direcionais
- **Animações**: 
  - "idle" quando parado
  - "walk" quando em movimento
  - Flip horizontal automático baseado na direção
- **Velocidade**: 200 pixels/segundo
- **Movimento diagonal normalizado** para velocidade consistente
- **Colisões**: Colide automaticamente com paredes e detecta colisão com enemies

### Enemy (script/enemy.gd)
- **Movimentação automática** com mudança de direção aleatória
- **Mudança de direção**: A cada 1.5-3 segundos (intervalo aleatório)
- **Animação contínua** do sprite
- **Flip horizontal** baseado na direção de movimento
- **Velocidade**: 50 pixels/segundo
- **Colisões**: Rebate automaticamente nas paredes usando bounce()

### Sistema de Colisões
- **Paredes**: 4 SegmentShape2D organizados em um StaticBody2D
  - LeftWall, TopWall, BottomWall, RightWall
  - Paredes invisíveis que bloqueiam o movimento
- **Detecção automática**: CharacterBody2D detecta colisões automaticamente
- **Rebote do enemy**: Enemy muda direção ao colidir com paredes
- **Detecção player-enemy**: Player detecta quando colide com enemy

### Configurações do Projeto
- **Input Map**: Configurado no project.godot
  - move_left: A + Seta Esquerda
  - move_right: D + Seta Direita  
  - move_up: W + Seta Cima
  - move_down: S + Seta Baixo

### Estrutura de Arquivos
```
maps/
  Map1Test.tscn      # Cena principal com paredes configuradas
  Map1Test.gd        # Script da cena (inicialização)

script/
  player_controller.gd  # Lógica do player com colisões
  enemy.gd             # Lógica do enemy com rebote
```

### Estrutura da Cena
```
SimpleMap1Test (Node2D)
├── Player (CharacterBody2D) - com script player_controller.gd
│   ├── CollisionShape2D
│   ├── Camera2D
│   └── AnimatedSprite2D
├── Enemy (CharacterBody2D) - com script enemy.gd
│   ├── AnimatedSprite2D
│   └── CollisionShape2D
├── Walls (StaticBody2D) - paredes invisíveis
│   ├── LeftWall (CollisionShape2D)
│   ├── TopWall (CollisionShape2D)
│   ├── BottomWall (CollisionShape2D)
│   └── RightWall (CollisionShape2D)
└── TileMapLayer (visual)
```

### Animações Configuradas
- **Player**: 2 animações (idle, walk) com 3 frames para walk
- **Enemy**: 1 animação (default) com 10 frames contínuas

## Como Testar
1. Execute a cena Map1Test.tscn
2. Use WASD ou setas para mover o player
3. Tente mover o player contra as bordas - ele não passará das paredes
4. Observe o enemy rebatendo nas paredes automaticamente
5. Encoste o player no enemy - aparecerá uma mensagem no console

## Funcionalidades Implementadas ✅
- ✅ Animações do player (idle/walk)
- ✅ Animações do enemy (contínua)
- ✅ Movimentação suave com input
- ✅ Sistema de colisões com paredes
- ✅ Enemy rebate nas paredes
- ✅ Detecção de colisão player-enemy
- ✅ Flip automático de sprites

## Próximos Passos (não implementados)
- Sistema de combate/dano
- Sistema de vida/morte
- Mais tipos de inimigos
- Animações de ataque
- Efeitos sonoros
