#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

//variabili globali dei menu settabili 4,5 e 7
bool status4 = 1;
bool status5 = 1;
int frecce_direzionali = 3;

//funzione che ritorna un 'codice' per ogni freccia
//SU = 1, GIU = 2, DX = 3, 0 = INVIO (per uscire dal sottomenu), 0 = ALTRO
int input()
{
    int invio;
    int c = getchar();
    if (c == '\n')
        return 4;

    else if (c == 27) //escape
    {
        c = getchar();
        if (c == 91) //'['
        {   
            c = getchar();
            invio = getchar();

            if(c == 65) //'A'
                return 1;
            else if (c == 66) //'B'
                return 2;
            else if (c == 67) //'C'
                return 3;
            else
                return 0;
            
        }
    }

    return 0;
}

//funzione che gestisce il sottomenu di 4 e 5
void ON_OFF(bool status, int code)
{
    int freccia;
    do
    {
        if(status)
            printf("ON");
        else
            printf("OFF");
    
        freccia = input();

        if (freccia == 1 || freccia == 2)
            status = !status;
        
    }while (freccia == 1 || freccia == 2);

    if (code == 4)
        status4 = status;
    else
        status5 = status;
    
    return;
}

//funzione che gestisce il sottomenu 7
void set_sette()
{
    bool cifra = true; //variabile che tiene conto se l input è una cifra

    while (cifra)
    {
        printf("%d", frecce_direzionali);
        char new_frecce[4]; //massimo 4 caratteri
        scanf("%s", new_frecce);

        if (strlen(new_frecce) != 1 || new_frecce[0] < '0' || new_frecce[0] > '9')
            cifra = false;
        else
        {
            if (new_frecce[0] >= '5')
                frecce_direzionali = 5;
            else if (new_frecce[0] <= '2')
                frecce_direzionali = 2;
            else
                frecce_direzionali = new_frecce[0] - 48; //trasformo da char a int
        }        
    }
    return;
}

//funzione che gestisce i sottomenu non settabili

void menu (int code)
{
    char riga1s [] = "1.Setting automobile (supervisor):";
    char riga1 [] = "1.Setting automobile:";
    char riga2 [] = "2.Data: 24/02/2024";
    char riga3 [] = "3.Ora: 08:00";
    char riga4 [] = "4.Blocco automatico porte: ";
    char riga5 [] = "5.Back-home: ";
    char riga6 [] = "6.Check olio";
    char riga7 [] = "7.Frecce direzione: ";
    char riga8 [] = "8.Reset pressione gomme";

    switch (code)
    {
    case 0:
        printf("%s", riga1);
        break;

    case 1:
        printf("%s", riga1s);
        break;

    case 2:
        printf("%s", riga2);
        break;

    case 3:
        printf("%s", riga3);
        break;

    case 4:
        printf("%s", riga4);
        if (status4)
            printf("ON");
        else 
            printf("OFF");
        break;

    case 5:
        printf("%s", riga5);
        if (status5)
            printf("ON");
        else 
            printf("OFF");
        break;

    case 6:
        printf("%s", riga6);
        break;

    case 7:
        printf("%s", riga7);
        printf("%d", frecce_direzionali);
        break;

    case 8:
        printf("%s", riga8);
        break;

    default:
        break;
    }

    return;
}

void submenu(int code)
{
    char riga1s [] = "Setting automobile (supervisor)";
    char riga1 [] = "Setting automobile";
    char riga2 [] = "24/02/2024";
    char riga3 [] = "08:00";
    char riga6 [] = "Check olio";
    char riga8 [] = "Pressione gomme resettata";

    switch(code)
    {
        case 0:
            printf("%s", riga1);
            break;
        
        case 1:
            printf("%s", riga1s);
            break;
        
        case 2:
            printf("%s", riga2);
            break;
        
        case 3:
            printf("%s", riga3);
            break;
        
        case 4:
            ON_OFF(status4, 4);
            menu(4);
            break;
        
        case 5:
            ON_OFF(status5, 5);
            menu(5);
            break;
        
        case 6:
            printf("%s", riga6);
            break;
        
        case 7:
            set_sette();
            menu(7);
            break;
        
        case 8:
            printf("%s", riga8);
            break;
    }
    return;
}

void main(int argc, char *argv[]) 
{
    int supervisor;
    //controllo parametro a riga di comando
    if (argc == 2 && strcmp(argv[1], "2244") == 0)
        supervisor = 1;
    else
        supervisor = 0;

    //variabile che tiene conto della riga del menu
    int code = supervisor;
    menu(code);

    while (code >= 0)
    {
        int freccia = input();
        //controllo la freccia inserita
        //in base a code chiamo la stringa del menu corretta
        //NB gestione dell eccezioni (fine menu, inizio menu...)
        //nelle eccezioni imposto code in modo da poter lasciare la chiamata uguale per tutti

        if(freccia == 0 || freccia == 4)
            code = -1;//esce dal ciclo (e quindi dal programma)
            
        else if (freccia == 1)
        {
            if (code == 0)
                code = 7;
            if (code == 1)
                code = 9;
            if (code == 2)
                code = supervisor+1;

            menu(--code);
        }
        else if (freccia == 2)
        {   
            if (code == 0)
                code = 1;
            if (code == 8)
                code = 0;
            if (code == 6)
                if (!supervisor)
                    code = -1;
            menu(++code);
        }
        else if (freccia == 3)
        { //la freccia dx va gestita diversamente, potrei già essere nel sottomenu
            submenu(code);
            
            //i menu settabili vengono gestiti diversamente da quelli non
            //(la chiamata al menu da quelli non settabili è direttamente nella funzione)
            if (code != 4 && code != 5 && code != 7)
            {
                while (input() == 3)
                    submenu(code);

                menu(code);
            }  
        }   
    }
}
