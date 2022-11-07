#!/bin/bash

#Script that allows the quick creation of a class with primitive types
#of data attributes for C++ (string, int, float and bool) + Basic File
#functionality (Write, read, modify, and get total of registries in file.

#To skip to the following attribute type, leave the input empty and press ENTER.

echo "Ingrese nombre de clase:"
read TUCLASE
echo "Ingrese nombre de clase base:"
read CLASEBASE
echo "Ingrese nombre de archivo.extension"
read TUARCHIVO

if [ -z "$CLASEBASE" ]
then
    printf "class $TUCLASE{" > class
else
    printf "class $TUCLASE:$CLASEBASE{" > class
fi

printf "
bool $TUCLASE::leerDeDisco(int pos){
    FILE *p;
    p=fopen("$TUARCHIVO","rb");
    if(p==NULL){return false;}
    fseek(p, pos * sizeof ($TUCLASE), 0);
    bool leyo = fread(this, sizeof ($TUCLASE), 1, p);
    fclose(p);
    return leyo;
}

bool $TUCLASE::grabarEnDisco(){
    FILE *p;
    p=fopen("$TUARCHIVO","ab");
    if(p==NULL){return false;}
    bool escribio = fwrite(this, sizeof ($TUCLASE), 1, p);
    fclose(p);
    return escribio;
}

bool $TUCLASE::modificarEnDisco(int pos){
    FILE *p;
    p=fopen("TUARCHIVO.dat","rb+");
    if(p==NULL){return false;}
    fseek(p, pos * sizeof($TUCLASE), 0);
    bool escribio=fwrite(this, sizeof ($TUCLASE), 1, p);
    fclose(p);
    return escribio;
}

int $TUCLASE::getCantidadRegistros(){
    FILE *p;
    p=fopen ("$TUARCHIVO","rb");
    fseek(p,0,SEEK_END);
    int tam=0;
    tam=ftell(p)/sizeof($TUCLASE);
    fclose(p);
    return tam;
}
" > class2


printf "
private:" > private
printf "
public:" > public
printf "
    //setters" > setters
printf "

    //getters" > getters


while [ true ]
do
echo "Ingresar propiedad cadena:"
read CADENA
if [ -z "$CADENA" ]
then
    break
else

echo "Ingresar tamanio de la cadena:"
read TAMANIO


printf "
    char $CADENA[$TAMANIO];" >> private

printf "
    void set$CADENA(char *c){strcpy($CADENA,c);}" >> setters

printf "
    const char *get$CADENA(){return $CADENA;}" >> getters
fi
done

while [ true ]
do
echo "Ingresar propiedad int:"
read ENTERO
if [ -z "$ENTERO" ]
then
    break
else

printf "
    int $ENTERO;" >> private

printf "
    void set$ENTERO(int x){$ENTERO=x;}" >> setters

printf "
    int get$ENTERO(){return $ENTERO;}" >> getters
fi
done

while [ true ]
do
echo "Ingresar nombre float:"
read FLOAT
if [ -z "$FLOAT" ]
then
    break
else

printf "
    float $FLOAT;" >> private

printf "
    void set$FLOAT(float f){$FLOAT=f;}" >> setters

printf "
    float get$FLOAT(){return $FLOAT;}" >> getters
fi
done

while [ true ]
do
echo "Ingresar nombre bool:"
read BOOL
if [ -z "$BOOL" ]
then
    break
else

printf "
    bool $BOOL;" >> private

printf "
    void set$BOOL(bool b){$BOOL=b;}" >> setters

printf "
    bool get$BOOL(){return $BOOL;}" >> getters
fi
done

printf "

    //METODOS DE CLASE
    bool leerDeDisco(int pos);
    bool grabarEnDisco();
    bool modificarEnDisco(int pos);
    int getCantidadRegistros();
};
" >> getters

cat private >> class ;
cat public >> class ;
cat setters >> class ;
cat getters >> class ;
cat class2 >> class ;

printf "###################################################################"

cat class ;

rm class ; rm public; rm private ; rm getters ; rm setters ; rm class2
