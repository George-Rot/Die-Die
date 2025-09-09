# Sistema de Múltiplos Ataques por Agilidade - Die&Die

## 🎯 **Sistema Corrigido: Ataques Múltiplos Baseados em Agilidade**

Agora o **Ataque Ágil** funciona corretamente como um sistema de múltiplos acertos escalando infinitamente com a agilidade.

### ⚔️ **Como Funciona o Ataque Ágil**

#### **Mecânica Principal:**
- **Cada ponto de agilidade = 1 tentativa de ataque**
- **Cada tentativa é independente** (não para em erro)
- **Dano menor por hit**, mas potencial para muito dano total
- **Escalabilidade infinita** com agilidade

#### **Fórmula de Implementação:**
```gdscript
func multiple_agility_attacks():
    for i in range(battle_player.agilidade):  # Tentativas = agilidade
        var roll = randf_range(0, agilidade)
        if roll >= (agilidade * 0.4):  # 60% chance base por tentativa
            var damage = forca * (roll / agilidade) * 0.6  # Dano escalado
            # Cada acerto adiciona dano
```

### 📊 **Comparação de Tipos de Player**

#### **Player Tipo 0** (Tanque)
```
Força: 12, Agilidade: 6, Vitalidade: 12
- Ataque Poderoso: ~18 dano garantido
- Ataque Ágil: 0-6 tentativas, ~2-4 acertos esperados
- Defesa: +9 overshield
```

#### **Player Tipo 1** (Ágil) - IMPLEMENTADO
```
Força: 10, Agilidade: 13, Vitalidade: 8  
- Ataque Poderoso: ~15 dano garantido
- Ataque Ágil: 0-13 tentativas, ~7-8 acertos esperados
- Defesa: +6 overshield
```

### 🎮 **Estratégias de Combate**

#### **Build Tanque (Tipo 0):**
- Ataque Poderoso para dano consistente
- Defesa frequente para survivability
- Ataque Ágil como backup (poucos hits)

#### **Build Ágil (Tipo 1):**
- Ataque Ágil para DPS alto via múltiplos hits
- Potencial para 10+ acertos em combo perfeito
- Risk/reward: pode falhar tudo ou devastar

### 📈 **Escalabilidade do Sistema**

**Potencial de Dano do Ataque Ágil:**
- **Agilidade 6**: Máximo 6 acertos
- **Agilidade 13**: Máximo 13 acertos  
- **Agilidade 20**: Máximo 20 acertos
- **Agilidade 50**: Máximo 50 acertos (!!)

**Exemplo de Combo Perfeito (Tipo 1):**
```
=== Ataque Ágil (13 tentativas) ===
Tentativa 1: ACERTO! Dano: 4
Tentativa 2: ACERTO! Dano: 6  
Tentativa 3: erro
Tentativa 4: ACERTO! Dano: 3
...
Resultado: 8/13 acertos, 35 dano total
```

### 🎯 **Feedback Visual Implementado**

**Mensagens Dinâmicas:**
- `"Ataque Ágil! 8/13 acertos em combo = 35 dano total!"`
- `"Ataque Ágil! COMBO PERFEITO! 13/13 acertos = 65 dano!"`
- `"Ataque Ágil falhou! 0/13 acertos conectados!"`

**Console Detalhado:**
```
=== Ataque Ágil (13 tentativas baseadas na agilidade) ===
Tentativa 1: ACERTO! Dano: 4 (roll: 8.2)
Tentativa 2: erro (roll: 3.1)
Tentativa 3: ACERTO! Dano: 6 (roll: 10.5)
...
Resultado: 8 acertos, 35 dano total
```

### ⚖️ **Balanceamento**

**Vantagens do Ataque Ágil:**
- Potencial de dano muito alto
- Escalabilidade infinita com agilidade
- Emocionante (RNG em cada tentativa)

**Desvantagens:**
- Inconsistente (pode fazer 0 dano)
- Dano por hit menor que Ataque Poderoso
- Dependente de sorte

**Balanceamento:**
- 60% chance por tentativa evita ser OP
- Dano por hit escalado mas limitado
- Trade-off: consistência vs potencial

### 🔮 **Possibilidades Futuras**

Com esse sistema, players podem:
- **Buildar full agilidade** para builds de "máquina de tiro"
- **Equipamentos que aumentam agilidade** = mais tentativas
- **Skills que modificam** chance de acerto ou dano por hit
- **Críticos** em tentativas específicas
- **Combos especiais** com sequências de acertos

### 💡 **Mecânica Única**

Este sistema cria uma mecânica única onde:
- **Mais agilidade ≠ apenas mais dano**
- **Mais agilidade = mais oportunidades de dano**  
- **Gameplay emocionante** com múltiplas chances
- **Escalabilidade natural** sem hard caps

## 🚀 **Implementação Técnica**

O sistema agora usa corretamente:
- **Loop baseado em agilidade** para tentativas
- **Rolls independentes** por tentativa
- **Acúmulo de dano** de todos os acertos
- **Feedback detalhado** de cada tentativa
- **Escalabilidade ilimitada** com estatísticas
