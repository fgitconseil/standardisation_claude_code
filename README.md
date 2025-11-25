# Workflow Claude Code - Standardisation Complète

> **Installation automatique** : ClaudeForge + Backlog.md + OpenSpec + Slash Commands
>
> Transforme n'importe quel projet en projet optimisé pour Claude Code avec un état des lieux complet de la codebase.

**Version**: 1.0.0 | **Last Updated**: 2025-11-24 | **Maintainers**: @fgitconseil

---

## 📑 Table des Matières

- [Quick Start (2 commandes!)](#-quick-start-2-commandes)
- [Architecture Complète](#-architecture-complète)
- [Installation Détaillée](#-installation-détaillée)
- [Composants du Workflow](#-composants-du-workflow)
- [Workflow en 5 Étapes](#-workflow-en-5-étapes)
- [7 Slash Commands](#-7-slash-commands-personnalisés)
- [Scripts Disponibles](#-scripts-disponibles)
- [Décisions Architecturales](#-décisions-architecturales)
- [Troubleshooting](#-troubleshooting)
- [Contribution](#-contribution)

---

## 🚀 Quick Start (2 commandes!)

### 1. Installation automatique

```bash
# Depuis n'importe où
bash /chemin/vers/standardisation_claude_code/scripts/install-claude-workflow.sh /chemin/vers/votre-projet
```

**Ce que le script fait automatiquement** :
- ✅ Installe ClaudeForge (analyse codebase)
- ✅ Installe Backlog.md (gestion tâches CLI vanilla)
- ✅ Installe OpenSpec (spécifications formelles)
- ✅ Crée 7 slash commands personnalisés
- ✅ Copie les scripts workflow dans votre projet
- ✅ Initialise backlog.md et openspec/

**Temps d'installation** : ~5-10 minutes

### 2. Générer l'état des lieux de votre projet

```bash
cd votre-projet
claude
/enhance-claude-md  # Lance l'analyse complète de la codebase par ClaudeForge
```

**ClaudeForge va** :
- 🔍 Analyser toute votre codebase (fichiers, structure, dépendances)
- 📊 Détecter stack technique, architecture, patterns utilisés
- 📝 Générer un CLAUDE.md complet avec toutes les informations

**Temps d'analyse** :
- Petit projet (< 100 fichiers) : 1-2 minutes
- Projet moyen (1k-10k fichiers) : 5-10 minutes
- Gros projet (> 50k fichiers) : 15-30 minutes

### 3. Enrichir avec le workflow standardisé

```bash
./merge-claude-md.sh CLAUDE.md CLAUDE.md
# Ajoute : Instructions pour Claude, Moyens (Backlog vanilla + OpenSpec), État du Projet
```

**Le script ajoute** :
- 🤖 Instructions pour Claude (Protocole de Session, Principes d'Implémentation)
- 🛠️ Moyens Disponibles (Backlog CLI + OpenSpec)
- 📊 Section "État du Projet" à compléter
- 🔑 Section "Décisions Techniques" à compléter

### 4. Utiliser le workflow

```bash
/context  # [AU DÉMARRAGE] Charger le contexte complet
/task "Nouvelle feature"
/plan     # Auto-détection simple/complexe
/work     # Implémenter
/done     # Fin de session
```

---

## 🏗️ Architecture Complète

```
┌─────────────────────────────────────────────────────────────────┐
│                    ARCHITECTURE GLOBALE                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    CLAUDE.md                             │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ [AJOUTÉ par merge-claude-md.sh]                    │  │  │
│  │  │ • Instructions pour Claude                         │  │  │
│  │  │ • Protocole de Session                             │  │  │
│  │  │ • Principes d'Implémentation                       │  │  │
│  │  │ • Moyens: Backlog vanilla + OpenSpec              │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ [GÉNÉRÉ par ClaudeForge]                           │  │  │
│  │  │ • Titre + Métadonnées                              │  │  │
│  │  │ • Stack technique détectée                         │  │  │
│  │  │ • Architecture du projet                           │  │  │
│  │  │ • Patterns identifiés                              │  │  │
│  │  │ • Commandes dev/build/test                         │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ [AJOUTÉ par merge-claude-md.sh]                    │  │  │
│  │  │ • État du Projet (tableau statuts)                 │  │  │
│  │  │ • Décisions Techniques (historique)                │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                  │
│              ┌───────────────┴───────────────┐                  │
│              ▼                               ▼                  │
│  ┌─────────────────────┐         ┌─────────────────────┐       │
│  │     Backlog.md      │         │      OpenSpec       │       │
│  │  (CLI vanilla)      │         │  (Specs formelles)  │       │
│  ├─────────────────────┤         ├─────────────────────┤       │
│  │ • Liste des tâches  │         │ • Context           │       │
│  │ • Kanban board      │         │ • Specs détaillées  │       │
│  │ • Statuts           │         │ • Acceptance        │       │
│  │ • QUOI faire        │         │ • COMMENT le faire  │       │
│  │                     │         │ • Pour features     │       │
│  │ Commands:           │         │   complexes         │       │
│  │ backlog board view  │         │                     │       │
│  │ backlog task create │         │ Commands:           │       │
│  │ backlog task start  │         │ openspec list       │       │
│  │ backlog task move   │         │ openspec show <n>   │       │
│  └─────────────────────┘         └─────────────────────┘       │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              .claude/commands/ (7 commands)              │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │ /context → Charge CLAUDE.md + backlog.md + openspec/    │  │
│  │ /task → backlog task create                              │  │
│  │ /plan → Auto-détection simple/complexe                   │  │
│  │ /spec → Force création OpenSpec                          │  │
│  │ /work → Implémente selon spec/plan                       │  │
│  │ /done → Màj backlog + État Projet                        │  │
│  │ /ship → Tests + commit + push                            │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Principes de Design

1. **Automatisation maximale** - Installation en une commande
2. **Générique** - Fonctionne pour tout type de projet
3. **Non-intrusif** - N'altère pas le code source existant
4. **Versionnable** - État du projet partageable via Git
5. **Réversible** - Peut être désinstallé proprement

---

## 📁 Structure du Projet

```
standardisation_claude_code/
├── README.md                              # Ce fichier (guide complet)
├── .gitignore                             # Exclusions Git
├── .gitignore.claude                      # Template gitignore pour projets cibles
└── scripts/                               # Scripts d'installation et workflow
    ├── install-claude-workflow.sh        # Installation complète (8 phases)
    ├── merge-claude-md.sh                # Fusion ClaudeForge + Instructions Claude
    ├── setup-project.sh                  # Setup initial projet (backlog, openspec)
    └── setup-commands.sh                 # Création des 7 slash commands
```

**Après installation dans votre projet** :

```
votre-projet/
├── CLAUDE.md                              # État des lieux complet
├── backlog.md                             # Liste des tâches
├── backlog/                               # Données Backlog.md
│   ├── tasks/                            # Tâches individuelles
│   ├── completed/                        # Tâches terminées
│   ├── archive/                          # Archive
│   └── config.yml                        # Configuration
├── openspec/                              # Spécifications formelles
│   ├── project.md                        # Config projet
│   ├── specs/                            # Specs actives
│   └── archive/                          # Specs complétées
├── .claude/commands/                      # 7 slash commands
│   ├── context.md
│   ├── task.md
│   ├── plan.md
│   ├── spec.md
│   ├── work.md
│   ├── done.md
│   └── ship.md
├── setup-project.sh                       # Script setup
├── setup-commands.sh                      # Script commands
└── merge-claude-md.sh                     # Script fusion CLAUDE.md
```

---

## 📦 Installation Détaillée

### Prérequis (vérifiés automatiquement)

Le script vérifie et guide l'installation si nécessaire :
- **Node.js** (v16+) et **npm** - [nodejs.org](https://nodejs.org/)
- **Git** - pour cloner ClaudeForge

```bash
# Vérifier vos prérequis
node --version  # v16+ requis
npm --version
git --version
```

### 8 Phases d'Installation Automatique

| Phase | Action | Résultat | Durée |
|-------|--------|----------|-------|
| **0** | Vérifie Node.js/npm | ✅ Validation prérequis | < 1s |
| **1** | Installe ClaudeForge | ✅ Clone + install → `/enhance-claude-md` disponible | 2-3 min |
| **2** | Installe Backlog.md | ✅ `npm install -g backlog.md` → CLI disponible | 30s |
| **3** | Installe OpenSpec | ✅ `npm install -g openspec` → CLI disponible | 30s |
| **4** | Copie scripts workflow | ✅ setup-*.sh, merge-*.sh dans projet | < 1s |
| **5** | Affiche instructions | ℹ️ Comment lancer `/enhance-claude-md` | < 1s |
| **6** | Initialise Backlog + OpenSpec | ✅ backlog.md, backlog/, openspec/ créés | 5s |
| **7** | Crée 7 slash commands | ✅ .claude/commands/ prêt | < 1s |
| **8** | État des lieux basique | 📊 Compte fichiers, détecte type projet | 2-5s |

**Total** : ~5-10 minutes

### Installation Complète (Étapes)

```bash
# 1. Cloner ce repo (une seule fois)
git clone https://github.com/fgitconseil/standardisation_claude_code.git

# 2. Lancer l'installation sur votre projet
cd standardisation_claude_code
bash scripts/install-claude-workflow.sh /chemin/vers/votre-projet

# 3. Aller dans votre projet
cd /chemin/vers/votre-projet

# 4. Lancer Claude Code
claude

# 5. Générer CLAUDE.md avec analyse complète
/enhance-claude-md
# Suivre les instructions interactives

# 6. Fusionner avec instructions Claude
./merge-claude-md.sh CLAUDE.md CLAUDE.md

# 7. Utiliser le workflow
/context  # Charger contexte
```

---

## 🧩 Composants du Workflow

### 1. ClaudeForge (Analyse Technique)

**Rôle** : Analyser la codebase et générer un CLAUDE.md technique complet.

**Installation** :
```bash
# Automatique via install-claude-workflow.sh
# ou manuel:
cd ~/.claudeforge
git clone https://github.com/alirezarezvani/ClaudeForge.git
cd ClaudeForge && bash install.sh
```

**Fonctionnalités** :
- ✅ Détecte automatiquement la stack technique
- ✅ Analyse l'architecture du projet
- ✅ Identifie les patterns utilisés
- ✅ Génère un CLAUDE.md structuré

**Outputs** :
- Skill: `~/.claude/skills/claudeforge-skill/`
- Command: `/enhance-claude-md` (disponible dans Claude Code)
- Agent: `claude-md-guardian` (maintenance CLAUDE.md)

**Limitations** :
- Génère uniquement le contenu technique
- Ne contient pas les instructions pour Claude (workflow)
- Ne documente pas les moyens disponibles (Backlog, OpenSpec)

> ⚠️ C'est pour ça qu'on utilise `merge-claude-md.sh` après !

### 2. Backlog.md (Gestion des Tâches)

**Rôle** : Gestion des tâches avec Kanban board en CLI (**vanilla, pas MCP**).

**Installation** :
```bash
npm install -g backlog.md
```

**Fonctionnalités** :
- ✅ CLI pour créer/éditer/lister les tâches
- ✅ Kanban board interactif (`backlog board view`)
- ✅ Interface web optionnelle (`backlog browser`)
- ✅ Statuts : todo, in_progress, blocked, done

**Commandes principales** :
```bash
backlog board view            # Voir Kanban
backlog task create "..."     # Créer tâche
backlog task start <id>       # Démarrer tâche
backlog task move <id> done   # Terminer tâche
backlog task edit <id>        # Éditer tâche
```

**Performance** :
- `backlog board view` : < 1 seconde
- `backlog task create` : < 1 seconde
- `backlog browser` : 2-3 secondes (serveur web)

> ⚠️ **Important** : Ce workflow utilise **Backlog.md vanilla** (CLI standard), **PAS Backlog.md MCP** (tools `mcp__backlog__*`).

### 3. OpenSpec (Spécifications Formelles)

**Rôle** : Créer des spécifications formelles pour features complexes.

**Installation** :
```bash
npm install -g openspec
```

**Fonctionnalités** :
- ✅ Template de specs structurées
- ✅ Versioning des specs
- ✅ Archivage après implémentation

**Format de spec** :
```markdown
# Feature Name

## Context
[Pourquoi cette feature existe]

## Specs
[Comportement attendu détaillé]

## Acceptance Criteria
- [ ] Critère 1
- [ ] Critère 2

## Technical Notes
[Contraintes techniques]
```

**Commandes principales** :
```bash
openspec list                 # Lister specs
openspec show <n>             # Afficher spec
openspec create              # Créer nouvelle spec
openspec archive <n>          # Archiver spec
```

**Performance** :
- `openspec list` : < 1 seconde
- `openspec show <n>` : < 1 seconde

**Quand utiliser OpenSpec** (au moins 1 critère) :
- ✅ Nouveau comportement utilisateur visible
- ✅ Changement d'architecture ou patterns
- ✅ Impact sur plusieurs features
- ✅ Intégration système externe
- ✅ Modification d'API / contrat

**Quand NE PAS utiliser OpenSpec** :
- ❌ Bug fix isolé
- ❌ Refactoring simple
- ❌ Utilitaire simple
- ❌ Documentation

---

## 🎯 Workflow en 5 Étapes

```
┌─────────────────────────────────────────────────────────────┐
│                  DÉMARRAGE DE SESSION                       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                       /context
                            │
                  ┌─────────┴─────────┐
                  │ Claude lit :      │
                  │ • CLAUDE.md       │
                  │ • backlog.md      │
                  │ • openspec/       │
                  └─────────┬─────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                 CRÉATION DE TÂCHE                           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
               /task "Nouvelle feature"
                            │
                  ┌─────────┴─────────┐
                  │ backlog task      │
                  │ create "..."      │
                  └─────────┬─────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                    PLANIFICATION                            │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                         /plan
                            │
                  ┌─────────┴─────────┐
                  │ Auto-détection :  │
                  │ Simple → Plan     │
                  │ Complexe → OpenSpec│
                  └─────────┬─────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                  IMPLÉMENTATION                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                         /work
                            │
                  ┌─────────┴─────────┐
                  │ Claude implémente │
                  │ selon spec/plan   │
                  └─────────┬─────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                  FIN DE SESSION                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                         /done
                            │
                  ┌─────────┴─────────┐
                  │ • Màj backlog     │
                  │ • Màj État Projet │
                  │ • Archive specs   │
                  └───────────────────┘
```

### Commandes en Détail

```bash
# 1. Démarrage (OBLIGATOIRE à chaque session)
claude
/context

# 2. Créer une tâche
/task "Ajouter authentification OAuth"
# Ou: backlog task create "Ajouter authentification OAuth"

# 3. Planifier
/plan
# Auto-détecte: simple (plan rapide) ou complexe (OpenSpec)

# 4. Implémenter
/work
# Claude charge la tâche + spec si existe et implémente

# 5. Terminer
/done
# Màj backlog, archive specs, màj État Projet

# 6. (Optionnel) Livrer
/ship
# Tests + commit + push
```

---

## 📚 7 Slash Commands Personnalisés

| Command | Description | Détails |
|---------|-------------|---------|
| `/context` | **AU DÉMARRAGE** - Charge tout le contexte | Lit CLAUDE.md + backlog.md + openspec/<br>Exécute `backlog board view` et `openspec list`<br>Confirme: "On continue sur quoi ?" |
| `/task` | Créer une tâche Backlog.md | Usage: `/task "Description"`<br>Exécute: `backlog task create "Description"` |
| `/plan` | Planifier (auto simple/complexe) | Détecte automatiquement:<br>- Simple → Plan rapide<br>- Complexe → Crée OpenSpec |
| `/spec` | Créer spec OpenSpec directement | Force création spec formelle<br>Même si tâche simple |
| `/work` | Implémenter une tâche | 1. Charge tâche Backlog<br>2. Charge spec OpenSpec si existe<br>3. Implémente selon spec/plan |
| `/done` | Terminer la session | 1. Màj tâches Backlog<br>2. Archive specs complétées<br>3. Màj "État du Projet" CLAUDE.md |
| `/ship` | Tests + commit + push | 1. Exécute tests<br>2. Crée commit (Co-Authored-By: Claude)<br>3. Push si demandé |

### Contenu des Commands

Les commands sont dans `.claude/commands/` de votre projet.

**Exemple : `/context`**
```markdown
---
description: AU DÉMARRAGE - Charge le contexte complet
---

# Chargement du contexte

Tu dois LIRE dans cet ordre :
1. CLAUDE.md (état des lieux du projet)
2. backlog.md (tâches en cours)
3. openspec/project.md (conventions, si existe)

Puis EXÉCUTER :
- backlog board view (voir Kanban)
- openspec list (voir specs actives)

Puis CONFIRMER :
"Contexte chargé. On continue sur quoi ?"
```

---

## 🔧 Scripts Disponibles

### `scripts/install-claude-workflow.sh`

**Installation complète automatique** sur un projet cible.

```bash
bash scripts/install-claude-workflow.sh /chemin/vers/projet
```

**Ce qu'il fait** :
1. Vérifie prérequis (Node.js, npm, Git)
2. Installe ClaudeForge dans `~/.claudeforge/`
3. Installe Backlog.md globalement (`npm install -g`)
4. Installe OpenSpec globalement (`npm install -g`)
5. Copie les scripts workflow dans le projet
6. Affiche instructions pour `/enhance-claude-md`
7. Initialise `backlog.md` et `openspec/`
8. Crée les 7 slash commands dans `.claude/commands/`
9. Génère état des lieux basique

**Gestion des erreurs** :
- ✅ Vérifie chaque prérequis avant de continuer
- ✅ Backup automatique si fichiers existants
- ✅ Messages d'erreur clairs avec solutions

### `scripts/merge-claude-md.sh`

**Fusionne** le CLAUDE.md généré par ClaudeForge avec les instructions Claude standardisées.

```bash
cd votre-projet
./merge-claude-md.sh CLAUDE.md CLAUDE.md
```

**Ce qu'il fait** :

1. **Extrait** le contenu technique de ClaudeForge :
   - Titre + Métadonnées (`**Architecture**: ...`)
   - Tout le contenu après `---`

2. **Ajoute** les sections workflow :
   - 🤖 Instructions pour Claude (Protocole, Principes, Modes)
   - 🛠️ Moyens Disponibles (Backlog vanilla + OpenSpec)
   - 📊 État du Projet (tableau à compléter)
   - 🔑 Décisions Techniques (historique à compléter)

3. **Construit** le fichier fusionné :
```markdown
# [Titre] (ClaudeForge)
[Métadonnées] (ClaudeForge)

---

## 🤖 INSTRUCTIONS POUR CLAUDE (Ajouté)
[Protocole de Session]
[Principes d'Implémentation]
[Modes Dynamiques]
[Workflow de Planification]
[Moyens: Backlog vanilla + OpenSpec]

---

[Contenu technique complet] (ClaudeForge)

---

## 📊 État du Projet (Ajouté)
[Tableau de statuts]

---

## 🔑 Décisions Techniques (Ajouté)
[Historique décisions]
```

**Backup automatique** :
```bash
# Crée automatiquement :
CLAUDE.md.backup.20251124_183025
```

### `scripts/setup-project.sh`

Initialise `backlog.md` et `openspec/` (appelé automatiquement par `install-claude-workflow.sh`).

```bash
bash setup-project.sh
```

### `scripts/setup-commands.sh`

Crée les 7 slash commands dans `.claude/commands/` (appelé automatiquement par `install-claude-workflow.sh`).

```bash
bash setup-commands.sh
```

---

## 🏛️ Décisions Architecturales

### DA-001: Backlog.md Vanilla (pas MCP)

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- Backlog.md existe en 2 versions : CLI vanilla et MCP
- Certains projets utilisent Backlog.md MCP (tools `mcp__backlog__*`)
- Le workflow standard doit être générique

**Décision** :
Utiliser **Backlog.md vanilla** (CLI commands) dans le workflow standardisé.

**Raisons** :
1. Plus simple et universel (commands bash standard)
2. Pas de dépendance MCP server
3. Fonctionne out-of-the-box après `npm install -g`
4. Plus large compatibilité avec tous types de projets

**Conséquences** :
- Commands: `backlog task create`, `backlog board view`
- Pas: `mcp__backlog__task_create`, `mcp__backlog__*`
- Documentation doit clarifier : "Backlog vanilla (CLI)"

### DA-002: ClaudeForge Installation Non-Interactive

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- ClaudeForge `install.sh` pose des questions interactives
- Bloquant pour script d'installation automatique

**Décision** :
Forcer installation non-interactive avec variables d'environnement.

**Implementation** :
```bash
export CI=true
export SKIP_PROMPTS=yes
export AUTO_CONFIRM=yes
bash install.sh < /dev/null
```

**Conséquences** :
- Installation silencieuse
- Valeurs par défaut utilisées
- Pas d'interaction utilisateur nécessaire

### DA-003: Fusion CLAUDE.md (pas écrasement)

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- ClaudeForge génère un CLAUDE.md technique complet
- Besoin d'ajouter instructions workflow sans perdre contenu technique

**Décision** :
Script `merge-claude-md.sh` **fusionne** au lieu d'écraser.

**Structure finale** :
```
# Titre + Métadonnées (ClaudeForge)
## Instructions pour Claude (ajouté)
## Moyens Disponibles (ajouté)
[Contenu technique complet] (ClaudeForge)
## État du Projet (ajouté)
## Décisions Techniques (ajouté)
```

**Conséquences** :
- Préserve analyse technique de ClaudeForge
- Enrichit avec workflow standardisé
- Un seul fichier CLAUDE.md complet

### DA-004: Slash Commands Personnalisés

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- Claude Code supporte slash commands via `.claude/commands/`
- Besoin de simplifier le workflow

**Décision** :
Créer 7 slash commands standardisés pour tous les projets.

**Commands** :
1. `/context` - Charge contexte (AU DÉMARRAGE)
2. `/task` - Crée tâche Backlog
3. `/plan` - Planification intelligente
4. `/spec` - Force OpenSpec
5. `/work` - Implémente
6. `/done` - Fin de session
7. `/ship` - Livraison

**Conséquences** :
- Workflow unifié entre projets
- Moins de commandes à mémoriser
- Auto-documentation via description

### DA-005: Structure Modulaire Documentation

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- Beaucoup de fichiers MD de test/debug dans racine
- Difficile de naviguer

**Décision** :
Réorganiser en structure minimaliste :

```
├── README.md (guide complet autoporteur)
├── scripts/ (tous les scripts)
└── .gitignore.claude (template pour projets)
```

**Conséquences** :
- README complet et autoporteur (toute la doc en un fichier)
- Structure ultra-simple et claire
- Pas de documentation externe nécessaire

---

## 🔄 Gestion Git (versionner le contexte)

### À Versionner (pour collaboration)

```bash
git add CLAUDE.md backlog.md backlog/ openspec/ .claude/commands/
git add setup-project.sh setup-commands.sh merge-claude-md.sh .gitignore
git commit -m "feat: Add Claude Code workflow with full project analysis"
```

**Fichiers à versionner** :
- ✅ `CLAUDE.md` - État du projet
- ✅ `backlog.md` + `backlog/` - Tâches (sauf cache)
- ✅ `openspec/` - Specs (sauf `.openspec/`)
- ✅ `.claude/commands/` - Slash commands
- ✅ `*.sh` - Scripts workflow
- ✅ `.gitignore`

### Auto-Exclus par `.gitignore.claude`

**NE PAS versionner** :
- ❌ `*.backup.*` - Backups temporaires
- ❌ `*_backup_*` - Backups scripts
- ❌ `.backlog/` - Cache Backlog.md
- ❌ `openspec/.cache/` - Cache OpenSpec
- ❌ `openspec/.openspec/` - Config locale
- ❌ `.env` - Variables d'environnement
- ❌ `*.key`, `*.pem` - Clés privées
- ❌ `credentials.json` - Credentials

---

## 🆘 Troubleshooting

### Problèmes Courants

| Problème | Solution |
|----------|----------|
| `backlog: command not found` | `npm install -g backlog.md` |
| `openspec: command not found` | `npm install -g openspec` |
| `/enhance-claude-md` not found | Relancer `scripts/install-claude-workflow.sh` (Phase 1) |
| CLAUDE.md sans instructions | `./merge-claude-md.sh CLAUDE.md CLAUDE.md` |
| OpenSpec init failed | `cd votre-projet && openspec init` manuellement |
| ClaudeForge bloque sur prompts | Vérifier variables env : `CI=true SKIP_PROMPTS=yes` |
| Backlog.md board vide | `backlog task create "Première tâche"` |
| Permission denied sur scripts | `chmod +x scripts/*.sh` |

### Logs et Debug

```bash
# Vérifier installations
which backlog
which openspec
ls -la ~/.claudeforge

# Vérifier structure projet
ls -la CLAUDE.md backlog.md
ls -la .claude/commands/
tree backlog/ openspec/

# Debug install script (mode verbose)
bash -x scripts/install-claude-workflow.sh /projet

# Réinstaller proprement
rm -rf ~/.claudeforge
npm uninstall -g backlog.md openspec
bash scripts/install-claude-workflow.sh /projet
```

### Support

- **Issues**: [GitHub Issues](https://github.com/fgitconseil/standardisation_claude_code/issues)
- **Documentation**: Tout dans README.md

---

## 📊 Métriques et Performance

### Métriques d'Installation

- Temps total : ~5-10 minutes
- Taille ClaudeForge : ~50 MB
- Taille Backlog.md : ~2 MB
- Taille OpenSpec : ~1 MB

### Performance Runtime

**ClaudeForge `/enhance-claude-md`** :
- Petit projet (< 100 fichiers) : 1-2 minutes
- Projet moyen (1k-10k fichiers) : 5-10 minutes
- Gros projet (> 50k fichiers) : 15-30 minutes

**Backlog.md CLI** :
- `backlog board view` : < 1 seconde
- `backlog task create` : < 1 seconde
- `backlog browser` : 2-3 secondes (serveur web)

**OpenSpec CLI** :
- `openspec list` : < 1 seconde
- `openspec show <n>` : < 1 seconde

---

## 🚀 Roadmap

### v1.1 (Court terme)
- [ ] Support Windows (adaptation scripts bash → PowerShell)
- [ ] Tests automatisés (CI/CD)
- [ ] Mode verbose/debug pour install script
- [ ] Command `/status` (état global projet)

### v1.2 (Moyen terme)
- [ ] Support Docker (installation dans container)
- [ ] Templates de projets (React, Python, FastAPI, etc.)
- [ ] Dashboard web pour état projet
- [ ] Intégration VS Code (extension)

### v2.0 (Long terme)
- [ ] Plugin VSCode natif
- [ ] Intégration GitHub Actions
- [ ] Metrics et analytics
- [ ] Multi-projets (workspace support)

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Ouvrez une issue ou PR sur GitHub.

### Guidelines

1. **Fork** le repo
2. **Créer** une branche : `git checkout -b feature/ma-feature`
3. **Commiter** : `git commit -m "feat: Add amazing feature"`
4. **Pusher** : `git push origin feature/ma-feature`
5. **Ouvrir** une Pull Request

### Tests Avant PR

Avant de merger, testez sur un projet réel :

```bash
# 1. Tester installation
bash scripts/install-claude-workflow.sh /path/to/test-project

# 2. Tester génération CLAUDE.md
cd /path/to/test-project
claude
/enhance-claude-md

# 3. Tester fusion
./merge-claude-md.sh CLAUDE.md CLAUDE.md

# 4. Tester workflow
/context
/task "Test task"
backlog board view
```

---

## 📚 Ressources Externes

- **[Backlog.md](https://github.com/backlog-md/backlog.md)** - Gestion des tâches avec Kanban CLI
- **[OpenSpec](https://openspec.dev)** - Spécifications formelles pour features complexes
- **[ClaudeForge](https://github.com/alirezarezvani/ClaudeForge)** - Analyse de codebase et génération CLAUDE.md technique
- **[Claude Code](https://www.anthropic.com/claude-code)** - CLI officiel Anthropic

---

## 📝 Changelog

### v1.0.0 (2025-11-24)
- ✅ Installation automatique complète (8 phases)
- ✅ Intégration ClaudeForge + Backlog.md + OpenSpec
- ✅ 7 slash commands personnalisés
- ✅ Script `merge-claude-md.sh` pour fusion
- ✅ Documentation complète et autoporteuse (README.md unique)
- ✅ Structure minimaliste (README + scripts/)
- ✅ 5 décisions architecturales documentées

---

**Happy coding with Claude! 🚀**

**Version**: 1.0.0
**Last Updated**: 2025-11-24
**Maintainers**: @fgitconseil
**License**: MIT
