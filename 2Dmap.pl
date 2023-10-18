use strict;
use Term::ReadKey;

# Définir la taille de la carte
my $largeur = 25;
my $hauteur = 5;

# Position initiale du personnage
my $x = int($largeur / 2);
my $y = int($hauteur / 2);

# Créer la carte
my @carte = ();
for my $row (0..$hauteur-1) {
    for my $col (0..$largeur-1) {
        $carte[$row][$col] = ' ';
    }
}

# Définir les coordonnées pour les '?'
my @question_marks = ();
for (1..3) {
    my $rand_x = int(rand($largeur));
    my $rand_y = int(rand($hauteur));
    push @question_marks, [$rand_x, $rand_y];
    $carte[$rand_y][$rand_x] = '?'; # Ajouter les '?' à la carte
}

# Initialiser les informations du personnage
my $vie = 100;
my $puissance = 10;

# Boucle de jeu
while (1) {
    system("clear"); # Effacer l'écran (Linux/Unix)
    #system("cls"); # Effacer l'écran (Windows)

    # Afficher le cadre en haut
    print '#' x ($largeur + 2), "\n";

    # Afficher la carte avec les bords
    for my $row (0..$hauteur-1) {
        print '#';
        for my $col (0..$largeur-1) {
            if ($row == $y && $col == $x) {
                print '0';
            } else {
                print $carte[$row][$col];
            }
        }
        print "#\n";
    }

    # Afficher le cadre en bas
    print '#' x ($largeur + 2), "\n";

    # Vérifier si le personnage se trouve sur un point d'interrogation
    for my $coord (@question_marks) {
        my ($q_x, $q_y) = @$coord;
        if ($q_x == $x && $q_y == $y) {
            print "Vous avez trouvé un point d'interrogation !\n";
            # Supprimer le point d'interrogation de la liste
            @question_marks = grep { $_ ne $coord } @question_marks;
        }
    }

    # Lire la commande de l'utilisateur
    my $input;
    ReadMode('cbreak');
    $input = ReadKey(0);
    ReadMode('normal');

    # Copier les coordonnées du personnage pour vérifier si le mouvement est valide
    my $new_x = $x;
    my $new_y = $y;

    # Déplacer le personnage en fonction de la commande
    if ($input eq 'z' && $y > 0) {
        $new_y--;
    } elsif ($input eq 's' && $y < $hauteur - 1) {
        $new_y++;
    } elsif ($input eq 'q' && $x > 0) {
        $new_x--;
    } elsif ($input eq 'd' && $x < $largeur - 1) {
        $new_x++;
    } elsif ($input eq 'q') {
        next; # Ignorer la commande 'q' pour éviter de quitter le jeu prématurément
    }

    # Vérifier si le mouvement est valide avant de mettre à jour la position du personnage
    if ($carte[$new_y][$new_x] ne '#') {
        # Effacer la position précédente du personnage
        $carte[$y][$x] = ' ';

        # Mettre à jour la position du personnage
        $x = $new_x;
        $y = $new_y;
    }
}
