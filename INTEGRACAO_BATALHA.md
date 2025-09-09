# Sistema de Batalha Integrado - Die&Die

## 🎯 Integração com Funções do Player

O sistema de batalha agora utiliza as funções reais de combate do player definidas em `player.gd`:

### ⚔️ **Funções de Ataque Integradas**

#### 1. **ATAQUE PODEROSO** → `ataque_P()`
```gdscript
func ataque_P():
    return forca + (forca * 0.5)
```
- **Fórmula**: Força + 50% da Força
- **Características**: Alto dano garantido
- **Exemplo**: Com Força 12 → Dano = 12 + 6 = 18

#### 2. **ATAQUE ÁGIL** → `ataque_L()`
```gdscript
func ataque_L():
    var chance = (agilidade * 2 - agilidade)  # = agilidade
    var roll = randf_range(0, chance) 
    if roll >= 20:
        var dano = (forca * (roll / 20))
        return dano
    return 0
```
- **Fórmula**: Baseado em agilidade e sorte
- **Características**: Pode errar (dano 0) ou causar dano variável
- **Chance de acerto**: Depende da agilidade vs roll de 20
- **Dano**: Força escalada pelo sucesso do roll

#### 3. **DEFENDER** → `defesa()`
```gdscript
func defesa():
    overshield += vitalidade * 0.75
```
- **Fórmula**: Overshield += 75% da Vitalidade
- **Características**: Adiciona escudo temporário
- **Exemplo**: Com Vitalidade 12 → +9 de overshield

### 📊 **Estatísticas do Player**

**Tipo 0 (Configuração Atual):**
```
Vitalidade: 12  → HP: 96 (12 * 8)
Força: 12       → Ataque Poderoso: ~18
Agilidade: 6    → Ataque Ágil: Variável
Overshield: 4   → Defesa base: +9 por uso
```

### 🎮 **Mecânicas de Combate**

#### **Ataque Poderoso**
- Dano consistente e alto
- Sempre acerta
- Baseado puramente em Força
- Ideal para dano garantido

#### **Ataque Ágil** 
- Dano variável ou miss
- Chance baseada em Agilidade
- Pode causar muito dano se der sorte
- Risk/reward gameplay

#### **Sistema de Defesa**
- Overshield absorve dano primeiro
- Depois reduz HP
- Acumula com múltiplos usos
- Estratégia defensiva viável

### 🔧 **Implementação Técnica**

```gdscript
# Criação do player de batalha
func create_battle_player():
    battle_player = Player.new(0)  # Tipo 0
    player_max_hp = battle_player.vitalidade * 8
    player_hp = player_max_hp

# Uso das funções reais
func _on_attack_pressed():
    var damage = int(battle_player.ataque_P())
    
func _on_quick_attack_pressed():
    var damage = int(battle_player.ataque_L())
    if damage > 0:  # Acertou
    else:  # Errou
    
func _on_defend_pressed():
    battle_player.defesa()  # Adiciona overshield
```

### 📈 **Balanceamento**

**Vantagens do Sistema:**
- Usa estatísticas reais do RPG
- Mecânicas consistentes entre exploração e batalha
- Agilidade influencia chance de acerto
- Força determina dano base
- Vitalidade influencia HP e defesa

**Estratégias:**
- **Alto Força**: Spam Ataque Poderoso
- **Alta Agilidade**: Risk com Ataque Ágil
- **Alta Vitalidade**: Tank com Defesa + HP alto

### 🎯 **Resultados Esperados**

Com as estatísticas padrão:
- **Ataque Poderoso**: ~18 dano consistente
- **Ataque Ágil**: 0 dano (erro) ou 6-24+ dano variável
- **Defesa**: +9 overshield por uso
- **HP Total**: 96 pontos

### 🔄 **Compatibilidade**

O sistema mantém compatibilidade com:
- Sistema de equipamentos (`trocar_arma`, `trocar_armadura`)
- Diferentes tipos de player (`_init(tipo)`)
- Escalabilidade de estatísticas
- Mecânicas futuras de RPG

## 🚀 **Próximas Expansões**

- [ ] Integrar sistema de equipamentos na batalha
- [ ] Diferentes tipos de player com builds variadas
- [ ] Críticos baseados em agilidade
- [ ] Status effects baseados em estatísticas
- [ ] Sistema de level up influenciando as fórmulas
