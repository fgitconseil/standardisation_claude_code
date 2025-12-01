Livrer les changements.

1. Vérifier :
   - Les changements sont-ils complets ?
   - La documentation Divio est-elle à jour ?

2. Exécuter les tests avec couverture

3. Si tests OK :
   - Linter + fix automatique
   - Mettre à jour CLAUDE.md "État du Projet"
   - Mettre à jour component-catalog.yml si nécessaire
   - Mettre à jour docs-index.yml si nouvelle doc
   - Git commit avec références :
     ```
     git commit -m "feat: [description]

     Updates:
     - CLAUDE.md: État du projet
     - component-catalog.yml: [si changements]
     - docs-index.yml: [si changements]
     - [fichiers modifiés]"
     ```
   - Push

4. Si échec :
   - Noter dans CLAUDE.md "État du Projet" (section problèmes)
   - Afficher les erreurs et suggérer des fixes
   - NE PAS commit/push
