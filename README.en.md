# Pokemon Green Text RPG

```
    Pokemon Green Version
    ░█▀█░█▀█░█░█░█▀▀░█▄█░█▀█░█▀█
    ░█▀▀░█░█░█▀▄░█▀▀░█░█░█░█░█░█
    ░▀░░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Claude Code Skill for Gen 1
```

> English | **[한국어](README.md)**

A Claude Code skill that lets you play Generation 1 Pokemon Green Version as a text-based RPG in your terminal.

---

## Why Did I Make This?

### Nostalgia

1996. The first Pokemon game on a Game Boy screen. I wanted to relive that excitement in the terminal.

### Experiment

The real purpose of this project is an experiment: **"Can non-deterministic gameplay be achieved through LLM skills?"**

- Traditional games are **deterministic**. Same input, same output.
- But what if an LLM plays the role of game master?
- Every playthrough brings slightly different dialogues, nuances, and experiences.

Through Claude Code's skill system, we explore the possibility of **"interactive fiction driven by AI."**

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

## Philosophy: Imagining the Future

### "Isn't this a waste of tokens?"

Yes. Honestly, this project is a **massive waste of tokens** right now.

Hundreds of tokens just to draw ASCII art. Thousands of tokens per battle.
We're running what a Game Boy did with 8KB RAM on a model with billions of parameters.

**But this is an imagination of the future.**

What if LLM inference becomes 100x, 1000x faster and cheaper?
- Real-time gameplay becomes possible
- Infinite NPC conversations become natural
- Instant response to every player action

This project is a **prototype** that lets us experience that future today.
It was built imagining when today's "waste" becomes tomorrow's "obvious."

### What If LLM Becomes a Game Master?

This project is not just a retro game recreation.

What does it mean when **"AI runs the game"**?

1. **Non-deterministic Experience**: Same choices, slightly different reactions every time
2. **Natural Language Interface**: Progress through conversation, not buttons
3. **Emergent Storytelling**: Improvisational dialogue beyond scripted responses
4. **Infinite Extensibility**: Any game is possible with skill data

### Future Possibilities

- **D&D-style TRPG**: AI Dungeon Master
- **Interactive Fiction**: Stories that respond to player choices
- **Educational Simulations**: Experiential learning in history, science, etc.
- **Prototyping**: Rapid validation of game ideas

I hope this project serves as a small experiment on **the future of LLM and interactive entertainment**.

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
