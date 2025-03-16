# ZenThea
###### projet L3 nec UPPA

<!-- img ici serait cool -->

projet de bot conversationnel avec un LLM distant (serveur)

## fonctionnement

- l'utilisateur créer des conversations
- l'utilisateur envoie des message au bot (envoie via le réseau ou non)
- il récupère ensuite la réponse et sauvegarde le tout localement

### design pattern utilisés

- Mediator pour centralisés les objets pour que l'on sauvegarde (en local)(maintenabilité)
    les objets uniquement lorsque c'est nécéssaire
- Singleton pour la connexion (obligatoire dés que l'on a une BD (maintenabilité))
- DAO pour cécrocher la partie données de la base de données (obligatoire (maintenabilité))

### autres informations

- LLM avec Mistral
