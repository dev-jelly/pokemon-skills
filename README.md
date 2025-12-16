<div align="center">

<img src="assets/logo.png" alt="Pokemon Green Text RPG" width="400">

# Pokemon Green Text RPG

**Claude Code Skill for Generation 1**

English | **[한국어](README.ko.md)**

</div>

A Claude Code skill that lets you play Generation 1 Pokemon Green Version as a text-based RPG in your terminal.

---

## Why Did I Make This?

### Nostalgia

1996. The first Pokemon game on a Game Boy screen. I wanted to relive that excitement in the terminal.

### Experiment

The real purpose of this project is an experiment: **"How deterministically can we control a non-deterministic LLM through skills?"**

- LLMs are inherently **non-deterministic**. Same input, different outputs.
- But what if we provide enough structured data and explicit rules?
- Can **skills (SKILL.md) as constraints** make AI behavior predictable?

Through Claude Code's skill system, we explore the possibility of **"taming AI with structured data."**

---

## Demo

### Game Start Screen

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║                    POKEMON GREEN VERSION                         ║
║                                                                  ║
║    ░█▀█░█▀█░█░█░█▀▀░█▄█░█▀█░█▀█                                 ║
║    ░█▀▀░█░█░█▀▄░█▀▀░█░█░█░█░█░█                                 ║
║    ░▀░░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀                                 ║
║                                                                  ║
║                    ♪ Opening BGM Playing...                      ║
║                                                                  ║
║              ┌─────────────────────────────────┐                 ║
║              │                                 │                 ║
║              │      [1] New Game               │                 ║
║              │      [2] Continue               │                 ║
║              │                                 │                 ║
║              └─────────────────────────────────┘                 ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### Prof. Oak Intro

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║               @@@@@@@@@          @@@@@@@@@                       ║
║               @@@@     **********  @@@@@@@                       ║
║               @@@@@  **   **     **  @@@@@                       ║
║               @@@@@    ***  *****    @@@@@                       ║
║               @@@@   **************    @@@                       ║
║               @@  *  **--*******-**  ** @@                       ║
║               @@  ******* ----  ******* @@                       ║
║               @@  *--**** ****  ***--** @@                       ║
║               @@   **  ***----***  **   @@                       ║
║                 ***  **          **  ***                         ║
║                 ***  ****       ***  ***                         ║
║               @@     **** ----  ***     @@                       ║
║               @@@@ ******       *****  @@@                       ║
║               @@@@@                  @@@@@                       ║
║               @@@@        @@@@         @@@                       ║
║                                                                  ║
║   ┌────────────────────────────────────────────────────────┐     ║
║   │                                                        │     ║
║   │  Prof. Oak:                                            │     ║
║   │  "Hello there! Welcome to the world of Pokemon!"       │     ║
║   │  "My name is Oak."                                     │     ║
║   │  "People call me the Pokemon Professor."               │     ║
║   │                                                        │     ║
║   └────────────────────────────────────────────────────────┘     ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### Battle Screen

![Battle Screen](assets/demo-battle.png)

```
╔════════════════════════════════════════════════════════════════╗
║  Wild PIKACHU                                       Lv.5      ║
║  ▓▓▓▓▓▓▓▓▓▓░░░░  HP                                           ║
║                                                                ║
║                                          :.            :+=.   ║
║                                        .**.       . .-*#**#-  ║
║                                        -*:    =*+::-+#***+-   ║
║                                    .-*##%#+-:#%#+=+**+*+-     ║
║                                    =%%#########- .=***-.      ║
║                                   =%*#%#*+.:%%#*-   -*#=      ║
║                                   .=*#%%#*++*##%%*..+=:       ║
║                                   .:.:+#*%#+=#%##*+=-:        ║
║                                        :**==+*=+%%#=..        ║
║                                         :+*+++#%#%*:          ║
║                                             .++*%*.           ║
║                                                 :             ║
║                                                                ║
║       :  :                                                     ║
║       ++=*.                                                    ║
║    .-+-+--==..                                                 ║
║ .-+*+==+-=++=++:                                               ║
║ :++==+++++=-+=-=-:..==                                         ║
║ :+=-=+==++--=---:-+**#+                                        ║
║                                                                ║
║  BULBASAUR                                          Lv.5      ║
║  ▓▓▓▓▓▓▓▓▓▓▓▓▓░░  HP  22/22                                   ║
╠════════════════════════════════════════════════════════════════╣
║  A wild PIKACHU appeared!                                      ║
╠════════════════════════════════════════════════════════════════╣
║     FIGHT             BAG                                      ║
║     POKEMON           RUN                                      ║
╚════════════════════════════════════════════════════════════════╝
```

> Opponent: Full front view / My Pokemon: Back view (flipped, top only)

---

## Features

| Feature | Description |
|---------|-------------|
| 151 Pokemon | Complete roster from Bulbasaur to Mew |
| 165 Moves | All Generation 1 moves implemented |
| Gen 1 Bugs | Psychic vs Ghost 0x damage, Focus Energy bug, etc. |
| Kanto Region | Pallet Town → 8 Gyms → Elite Four → Champion |
| ASCII Art | All Pokemon/NPC sprites |
| Auto BGM | 45 original soundtrack tracks |
| Cries | 151 Pokemon cries |
| Move SFX | 165 move-specific sound effects |
| Save/Load | 10 slots + auto-save |

---

## System Requirements

### Required
- **Claude Code** (Anthropic CLI)
- macOS, Linux, or Windows

### Audio (macOS Only)

> **Important**: BGM, sound effects, and Pokemon cries only work on **macOS**.

This skill uses macOS's `afplay` command. On other operating systems:
- The game itself works normally
- Only audio playback is unavailable

PRs for Linux/Windows audio support are welcome!

---

## Installation & Usage

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/pukiman.git
cd pukiman
```

### 2. Run Claude Code

```bash
claude
```

### 3. Start the Game

```
> pokemon
> new game
```

or

```
> continue
```

### Language Selection

- **English**: "pokemon", "new game", "battle", etc.
- **한국어**: "포켓몬", "새 게임", "전투", etc.

---

## Copyright & Sources

This project was created with **deep respect and admiration** for the original work.

### Original Copyright Holders

**Pokemon is a registered trademark of Nintendo / Game Freak / Creatures Inc.**

This is a fan-made non-profit project that respects the rights of the original copyright holders.

### Resource Sources

#### ASCII Art

| Resource | Source | License |
|----------|--------|---------|
| Full Pokemon Art | [MatheusFaria/pokedex_ascii.h](https://gist.github.com/MatheusFaria/4cbb8b6dbe33fd5605cf8b8f7130ba6d) | Public Gist |
| Original Artist | "mh" (fiikus.net, world-of-nintendo.com) | - |
| NPC Sprites | [pret/pokered](https://github.com/pret/pokered) | Decompilation Project |

#### Audio

| Resource | Source | Notes |
|----------|--------|-------|
| BGM (45 tracks) | [Internet Archive - pkmn-rgby-soundtrack](https://archive.org/details/pkmn-rgby-soundtrack) | Public Archive |
| Cries (151) | [Pokemon Showdown](https://play.pokemonshowdown.com/) | Public Resource |
| Move SFX | [KHInsider](https://downloads.khinsider.com/game-soundtracks/album/pokemon-sfx-gen-1-attack-moves-rby) | Public Soundtrack |
| Move SFX (Alt) | [The Sounds Resource](https://www.sounds-resource.com/game_boy_gbc/pokemonredblueyellow/) | Public Resource |

#### Game Data

| Data | Source | Notes |
|------|--------|-------|
| Base Stats | Generation 1 Official Data | Based on Original |
| Type Chart | Generation 1 (with bugs) | Gen 1 Unique Bugs Reproduced |
| Move Data | Generation 1 Official Data | 165 Moves |

---

## Disclaimer

```
This project was created purely for educational and experimental purposes.

- This is a non-commercial fan project
- No revenue is generated
- Will be removed immediately upon request from copyright holders
- We encourage purchasing the original games (Nintendo eShop, etc.)

Deep gratitude and respect to
Nintendo, Game Freak, and Creatures Inc.
for creating the Pokemon series.
```

---

## Core Experiment (Philosophy)

### "Can Skills Control AI?"

LLMs are inherently non-deterministic. Same prompt, different responses every time.

**But what if we provide sufficiently structured data and explicit rules?**

This project is an experiment to answer that question:

- **151 Pokemon data** → AI uses exact stats instead of making them up
- **165 move data** → Calculates damage precisely according to formulas
- **Type effectiveness chart** → Applies 2x, 0.5x, 0x by the rules
- **Even Gen 1 bugs documented** → Reproduces "Psychic vs Ghost = 0x"

When a skill document clearly defines **what to do and how**, even a non-deterministic LLM can behave **like a deterministic game engine**.

### Why Pokemon?

Pokemon Generation 1 is a perfect testbed for this experiment:

1. **Clear rules**: Damage formulas, catch rates, type matchups - all numerically defined
2. **Finite data**: 151 Pokemon, 165 moves - fully enumerable
3. **Verifiable**: Can measure accuracy by comparing to the original
4. **Right complexity**: Simple yet with diverse interactions

### What We've Learned

- **JSON data**: Single source of truth that AI can consistently reference
- **Explicit rules**: Not "do this" but "follow this formula"
- **Documenting exceptions**: Even bugs are reproduced when documented
- **Templates**: Defining output formats maintains consistent UI

### Future Possibilities

If this experiment succeeds, the same methodology could apply to:

- **Complex board games**: Chess, Go, Catan, etc.
- **Simulations**: Rule-based economic/ecological models
- **Educational tutors**: Learning assistants with definite answers
- **Workflow automation**: Rule-based task processing

**It's not "AI can't be controlled" but "how do we control it?"**

---

## Contributing

Issues and PRs are welcome!

- Bug reports
- New feature suggestions
- Linux/Windows audio support
- Documentation improvements

---

## License

- **Project Code**: MIT License
- **Game Resources**: Follow respective source licenses
- **Pokemon Assets**: Owned by Nintendo/Game Freak/Creatures Inc.

---

<div align="center">

**Made with love and nostalgia**

*Remembering the excitement of 1996*

</div>
