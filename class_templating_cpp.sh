#!/bin/bash
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
    p=fopen(\"$TUARCHIVO\",\"rb\");
    if(p==NULL){return false;}
    fseek(p, sizeof *this*pos, 0);
    bool leyo = fread(this, sizeof *this, 1, p);
    fclose(p);
    return leyo;
}

bool $TUCLASE::grabarEnDisco(){
    FILE *p;
    p=fopen(\"$TUARCHIVO\",\"ab\");
    if(p==NULL){return false;}
    bool escribio = fwrite(this, sizeof *this, 1, p);
    fclose(p);
    return escribio;
}

bool $TUCLASE::modificarEnDisco(int pos){
    FILE *p;
    p=fopen(\"$TUARCHIVO\",\"rb+\");
    if(p==NULL){return false;}
    fseek(p, pos * sizeof($TUCLASE), 0);
    bool escribio=fwrite(this, sizeof ($TUCLASE), 1, p);
    fclose(p);
    return escribio;
}

int $TUCLASE::getCantidadRegistros(){
    FILE *p;
    p=fopen (\"$TUARCHIVO\",\"rb\");
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

CADENAU=${CADENA^}
printf "
    char $CADENA[$TAMANIO];" >> private

printf "
    void set$CADENAU(char *c){strcpy($CADENA,c);}" >> setters

printf "
    const char *get$CADENAU(){return $CADENA;}" >> getters
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


ENTEROU=${ENTERO^}
printf "
    int $ENTERO;" >> private

printf "
    void set$ENTEROU(int x){$ENTERO=x;}" >> setters

printf "
    int get$ENTEROU(){return $ENTERO;}" >> getters
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

FLOATU=${FLOAT^}
printf "
    float $FLOAT;" >> private

printf "
    void set$FLOATU(float f){$FLOAT=f;}" >> setters
printf "
    float get$FLOATU(){return $FLOAT;}" >> getters
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

BOOLU=${BOOL^}
printf "
    bool $BOOL;" >> private

printf "
    void set$BOOLU(bool b){$BOOL=b;}" >> setters

printf "
    bool get$BOOLU(){return $BOOL;}" >> getters
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

printf "###################################################################
"

cat class ;

rm class ; rm public; rm private ; rm getters ; rm setters ; rm class2
