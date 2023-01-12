#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int instruction_add();
int instruction_minus();
int  search(char *);
int insert(char *, char *, int);
int insert_Func();
int insert_in_Func(char* semn);
int Print();
int check_declarations(char *);
int update_ID(char *, char *);
int update_VAL(char *, int);
void Write();
void WriteFunc();

struct table_simbol{
    char tip_simbol[100];
    char nume_simbol[100];
    int adancime_bloc;
    int nr_bloc;
    int valoare;
}tabel[200];
struct functions{
     char name[100];
     char tipuri[100][100];
     int nr_param;
} nume_func[100];

struct called_functions{
     char name[100];
     char tipuri[100][100];
     int nr_param;
}apeluri_user[100];

int name_index = 0, nr_bloc_adancime[100], adancime_curenta = 1;

struct tabel_func{
     char semnatura[450];
}tabelfunc[100];
int indiceVar = 0, j = 0, i = 0, k = 0, p = 0, indiceFunc = 0;
char SemnFunc[300], temp[100];

int instruction_add(){
    nr_bloc_adancime[adancime_curenta++]++;
    return 0;
}

int instruction_minus(){
    adancime_curenta--;
    return 0;
}

int  search(char *name){
  int i,  search_nr_bloc = nr_bloc_adancime[adancime_curenta - 1],  search_adancime = adancime_curenta;
     for (i = indiceVar - 1; i >= 0; i--){
          if (tabel[i].adancime_bloc <  search_adancime){
                search_adancime = tabel[i].adancime_bloc;
                search_nr_bloc = tabel[i].nr_bloc;
          }
          else if (tabel[i].adancime_bloc ==  search_adancime &&
                   tabel[i].nr_bloc ==  search_nr_bloc &&
                   strcmp(tabel[i].nume_simbol, name) == 0){
               return i;
          }
     }
     return -1;
}

int insert(char *tip, char *id, int valoare){
     if ( search(id) != -1){
          printf("  Eroare: variabila %s %s a fost deja declarata.\n", tip, id);
          return 0;
     }
     tabel[indiceVar].nr_bloc = nr_bloc_adancime[adancime_curenta - 1];
     tabel[indiceVar].adancime_bloc = adancime_curenta;
     strcpy(tabel[indiceVar].tip_simbol, tip);
     strcpy(tabel[indiceVar].nume_simbol, id);
     tabel[indiceVar].valoare = valoare;
     indiceVar++;
     return 0;
}

int check_declarations(char *id){
     int id_index =  search(id);
     if (id_index == -1){
          printf("  Eroare: variabila %s nu a fost declarata\n", id);
          return 0;
     }
     if (strcmp(tabel[id_index].tip_simbol, "int") != 0){
          if (tabel[id_index].valoare == 2147483647){
               printf("  Eroare: variabila %s nu a fost initializata\n", id);
               return -1;
          }
     }
     return 1;
}

int update_VAL(char *destinatie, int sursa){
     int index_destinatie =  search(destinatie);
     if (index_destinatie == -1){
          printf("  Eroare: variabila %s nu a fost declarata\n", destinatie);
          return -1;
     }
     tabel[index_destinatie].valoare = sursa;
     return 0;
}

int update_ID(char *destinatie, char *sursa){
     int index_sursa =  search(sursa), index_destinatie =  search(destinatie);
     if (index_sursa == -1){
          printf("  Eroare: variabila %s nu a fost declarata\n", sursa);
          return -1;
     }
     if (index_destinatie == -1){
          printf("  Eroare: variabila %s nu a fost declarata\n", destinatie);
          return -1;
     }
     if (strcmp(tabel[index_sursa].tip_simbol, "int") != 0){
          if (tabel[index_sursa].valoare == 2147483647){
               printf("  Eroare: variabila %s nu a fost initializata\n", destinatie);
               return -1;
          }
     }
     tabel[index_destinatie].valoare = tabel[index_sursa].valoare;
     return 0;
}

int Print(){
     int i, j,  search_bloc_nr = 0,  search_adancime = 0;
     printf("\n\nTabel variabile:\n");
     for (i = 0; i < indiceVar; i++){
          printf("%s %s %d\n", tabel[i].tip_simbol, tabel[i].nume_simbol, tabel[i].valoare);
     }
     printf("\n\nTabel functii:\n");
     for (i = 0; i < indiceFunc; i++){
          printf("%s\n", tabelfunc[i].semnatura);
     }
}

void Write(){
     int i, j;
     FILE *f = fopen("symbol_table.txt", "w+");
     fprintf(f, "Variabile: \n");
     for (i = 0; i < indiceVar; i++){
       fprintf(f, "%s %s %d\n", tabel[i].tip_simbol, tabel[i].nume_simbol, tabel[i].valoare);
     }
     fclose(f);
}

void WriteFunc(){
     int i, j;
     FILE *f1 = fopen("symbol_table_functions.txt", "w+");
     fprintf(f1, "Functii: \n");
     for (i = 0; i < indiceFunc; i++){
          fprintf(f1, "%s\n", tabelfunc[i].semnatura);
     }
     fclose(f1);
}

int  searchfunc(char *semn){
     for (int i = indiceFunc - 1; i >= 0; i--){
          if (strcmp(tabelfunc[i].semnatura, semn) == 0){
               return 1;
          }
     }
     return 0;
}

int insert_Func(){
     char as[200];
     strcpy(as,SemnFunc);
     strcat(as,temp);
     if( searchfunc(as) == 1 ){
          printf("  Eroare: functia cu semnatura %s este duplicata.\n",SemnFunc);
          memset(as,0,200);
          memset(SemnFunc, 0, 300);
          memset(temp,0,100);
          return 0;
     }
     strcpy(tabelfunc[indiceFunc].semnatura, SemnFunc);
     strcat(tabelfunc[indiceFunc].semnatura,temp);
     indiceFunc++;
     memset(as,0,200);
     memset(SemnFunc, 0, 300);
     memset(temp,0,100);
}

void inserareMatrixParam(char *tip){
   strcat(temp, tip);
   strcat(temp, " ");
   strcpy(nume_func[name_index].tipuri[j], tip);
   nume_func[name_index].nr_param++;
   j++;
}

int insert_in_Func(char* semn){
     strcat(SemnFunc, semn);
     strcat(SemnFunc, " ");
     return 0;
}

int inserareNumeMatrix(char *semn){
     strcpy(nume_func[name_index++].name, semn);
     j = 0;
     return 0;
}

void inserareNume(char *name){
     strcpy(apeluri_user[k++].name, name);
     p = 0;
}

int inserareMatrixUser(char *tip){
     strcpy(apeluri_user[k].tipuri[p++], tip);
     apeluri_user[k].nr_param++;
}

int verificareIdentitate(char *semn){
     int copie, copie_noua;
     for (int a = 0; a < k; a++)
          if (strcmp(semn, apeluri_user[a].name) == 0){
               copie = a;
          }
     int ok = 0;
     for (int b = 0; b < name_index; b++)
          if (strcmp(apeluri_user[copie].name, nume_func[b].name) == 0){
               copie_noua = b;
               ok = 1;
          }
     if (ok == 0){
          printf(" Eroare: functia %s nu a fost declarata \n", apeluri_user[copie].name);
          return 2;
     }
     for (int c = 0; c < apeluri_user[copie].nr_param; c++){
          if (strcmp(apeluri_user[copie].tipuri[c], nume_func[copie_noua].tipuri[c]) != 0)
               return 0;
     }
     return 1;
}
