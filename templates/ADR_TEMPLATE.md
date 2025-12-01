# ADR-XXX : [Titre de la Décision]

**Date** : YYYY-MM-DD | **Statut** : 🟡 Proposé / ✅ Accepté / ⚠️ Déprécié

## Contexte

[Quelle est la situation ? Quel problème doit être résolu ?]

## Décision

[Quelle décision a été prise ?]

## Raisons

1. [Raison 1]
2. [Raison 2]
3. [Raison 3]

## Alternatives Considérées

### Option A : [Nom]
- **Description** : [...]
- **Avantages** : [...]
- **Inconvénients** : [...]
- **Verdict** : ❌ Rejetée car [...]

### Option B : [Nom] (CHOISIE)
- **Description** : [...]
- **Avantages** : [...]
- **Inconvénients** : [...]
- **Verdict** : ✅ Acceptée car [...]

## Conséquences

### Positives
- [Conséquence positive 1]
- [Conséquence positive 2]

### Négatives / Compromis
- [Compromis 1]
- [Compromis 2]

## Notes

[Informations additionnelles, références, liens]

---

## Instructions d'Utilisation

**Quand créer un ADR ?**
- Décision architecturale majeure (choix de framework, pattern, infrastructure)
- Trade-off technique significatif
- Changement impactant plusieurs composants

**Où stocker les ADRs ?**
- **Petits projets (<15 DAs)** : Directement dans README.md (format DA-XXX)
- **Projets complexes (>15 DAs)** : Créer dossier `docs/adrs/` avec fichiers séparés

**Numérotation** :
- Format : ADR-001, ADR-002, etc.
- Ou : DA-001, DA-002 (Décision Architecturale) si dans README

**Maintenance** :
- Statut peut évoluer : Proposé → Accepté → Déprécié
- ADRs ne sont JAMAIS supprimés (trace historique)
- ADR déprécié → Créer nouvel ADR qui le remplace
