# ZenThea
###### projet L3 nec UPPA

ce fichier sert a clarifier l'utilisation de l'outil Cocoapods
(pour la gestion des message pour que l'on ai pas a refaire une n-iéme fois
on code qui a déja été utilisé beaucoup de fois dans le passé)

## installation complet des dépendances Cocoapods

en local pour le projet de A a Z

### outils nécessaires 

- brew (a installer depuis leurs site web en ligne)

1. installer cocoapods avec brew en local

```bash
brew install cocoapods
```

2. dans le répertoire .../ZenThea/

faire le commande suivante :

```
pod init
```
faire ensuite :

```
open Podfile
```

écrire dans le fichier la dépendance a installer 
`pod 'MessageKit'` (les classes pour gérer les messages)

le fichier complet ci-dessous 

```txt
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ZenThea' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # dépendances a installer pour notre projet :
  pod 'MessageKit'

  target 'ZenTheaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ZenTheaUITests' do
    # Pods for testing
  end

end
```

3. on revient dans le terminal et on import les packages

```bash
pod install
```

# tres important

## a partir de maintenant il faut tujours ouvrir le projet en utilisant le fichier suivant 

# `ZenThea.xcworkspace``

(double cliquer dessus pour l'ouvrir ou faites depuis le terminal)<br>
toujours dans le même répertoire :
`open ZenThea.xcworkspace`

### tout a été fait jusqu'ici




<!-- end  -->
