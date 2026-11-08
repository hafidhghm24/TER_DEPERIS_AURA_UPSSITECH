# Workflow Git & GitHub

Regle absolue : **Ne jamais commiter ou pusher directement sur `main`.**

---

### 1. Preparer la tache

1. Noter le numero de l'Issue (ex: `#2`).
2. Deplacer l'issue dans la colonne **In Progress** sur le GitHub Project.

### 2. Creer la branche (GitHub Desktop)

1. Se placer sur `main` et cliquer sur **Fetch origin**.
2. **Current Branch** -> **New Branch** :
    - Fonctionnalite : `feature/<numero>-<nom_court>`
    - Correction : `fix/<numero>-<nom_court>`
3. Cliquer sur **Publish branch**.

### 3. Developper & Sauvegarder

1. Coder et tester localement.
2. Dans GitHub Desktop : renseigner le message de commit, cliquer sur **Commit**, puis sur **Push origin**.

### 4. Ouvrir la Pull Request (PR)

1. Dans GitHub Desktop : appuyer sur **Ctrl + R** (ou _Create Pull Request_).
2. Dans la description sur le navigateur, ecrire :
    ```text
    Closes #<numero>
    ```
3. Valider la creation de la PR.
4. delete branch

### 5. Valider & Nettoyer

1. Sur GitHub : relire, cliquer sur **Merge pull request**, puis sur **Delete branch**.
   _(L'issue se ferme et passe dans **Done** automatiquement)._
2. Dans GitHub Desktop : revenir sur `main`, cliquer sur **Fetch / Pull origin**, puis supprimer la branche locale terminee.
