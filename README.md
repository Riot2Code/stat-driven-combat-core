README.md
# Stat-Driven Combat Core (Godot 4)

A small experimental project focused on learning and implementing **authoritative, stat-driven combat resolution** in Godot 4.

This project intentionally prioritizes **combat math and systems design** over visuals, movement, or UI.  
The goal is to build a foundation that scales cleanly from simple 2D prototypes to more complex RPG / MMO-style games.

---

## 🎯 Project Goals

- Learn **authoritative combat resolution** (hit, miss, crit, damage)
- Keep combat logic **centralized and deterministic**
- Support **off-level encounters** (possible but inefficient/risky)
- Avoid hard level gates or artificial restrictions
- Build systems that transfer cleanly from **2D → 3D**

Inspired by older MMO design philosophies where **knowledge, preparation, and stats** matter more than twitch reflexes.

---

## 🧠 Core Concepts

### Authoritative Combat Resolver
All combat math lives in a single resolver:
- No damage logic in entities
- No animation-driven outcomes
- Easy to port to server-side logic later

### Stat-Driven Outcomes
Combat outcomes are based on:
- Accuracy vs evasion
- Attack vs defense
- Critical chance and multipliers
- Level gaps (soft scaling, not hard locks)

### Soft Gating Philosophy
Being under-leveled:
- Increases miss chance
- Reduces damage
- Raises risk

…but never makes combat impossible.

---

## ⚔️ Current Features

- Basic attack resolution
- Hit / miss rolls
- Critical hits
- Damage mitigation
- Level-gap scaling (soft)
- Deterministic combat results
- Console combat log output

---

## 🕹 Controls

| Key | Action |
|----|------|
| Space | Attack target |
| R | Reset target HP |

---

## 🗂 Project Structure

res://scenes/
  Main.tscn

res://scripts/
  stats.gd
  combat/
    combat_entity.gd
    combat_resolver.gd
    combat_result.gd
  main.gd



---

## 🚧 What This Project Is *Not*

- Not a full game
- Not focused on graphics or polish
- Not animation-driven combat
- Not networked (yet)

This is a **systems-first learning project**.

---

## 🔜 Planned Experiments

- Level vs level incoming damage scaling
- Skill-based attacks (power coefficients, cooldowns)
- Buffs and debuffs
- Threat / aggro logic
- Illegal-but-viable grind zones
- Combat log UI

---

## 💬 Notes

This project is intentionally simple and iterative.  
Every mechanic added must preserve:
- Clarity
- Predictability
- Emergent outcomes

If you’re learning Godot or RPG systems design, feel free to explore, fork, or experiment.

---

## 📜 License

MIT (or replace with your preferred license)

---

Created by Riot2Code

"# stat-driven-combat-core" 
