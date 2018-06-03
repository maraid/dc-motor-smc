# DC motor csúszómód (SMC) sebesség szabályozás
A projektben egy DC motor elméleti csúszómód sebesség szabályozását (sliding mode speed control) mutatom be Matlab és Simulink segítségével.
### 1. Differenciál egyenletek
#### Áram egyenlete: 
![Current](https://raw.githubusercontent.com/maraid/dc-motor-smc/master/docs/current.png)
ahol L~a~ a motor induktanciája H-ben, i~a~ az átfolyó áram A-ben, V~a~ a motorra kapcsolt feszültség V-ban,  K~b~ az ellen-elektromotors erő (back EMF) Vs/rad-ban, omega a szögsebesség rad/s-ben,  R~a~ az ellenállása Ohm-ban kifejezve.

#### Szögsebesség egyenlete:
![Angular velocity](https://raw.githubusercontent.com/maraid/dc-motor-smc/master/docs/velocity_diff.png)
ahol J a rotor inerciája Kgm^2^/s^2^-ben, K~t~ a motorra vonatkozó forgatónyomaték konstans Nm/A és b a viszkózus súrlódás konstansa Nms-ben kifejezve.

A fenti egyenletekből megvalósítható Simulink-ben a motor modellje:
![Motor modell in Simulink](https://raw.githubusercontent.com/maraid/dc-motor-smc/master/docs/motor.png)

### 2. Szabályozás
A másodfokú rendszerünkhöz másodfokú szabályzót kell alkalmaznunk.
#### Csúszófelület meghatározása
![sliding surface](https://raw.githubusercontent.com/maraid/dc-motor-smc/master/docs/s.png)
ahol lambda egy általunk választott konstans és y~e~ a hiba.

#### Csattogás csökkentése és vezérlés
Annak érdekében, hogy a csattogás ne "faltól falig" történjen csak, egy szaturációs függvényt vezetünk be. Ezt a kódban az elágazásos vezérlés valósítja meg. A psi itt egy általunk választott konstans.

A vezérlő belső Matlab kódja a következő

```matlab
function output  = smc(hiba, hiba_deriv, K, lambda, psi)
    s = lambda * hiba + hiba_deriv;
    
    if (abs(s) > psi)    
       sat_s = sign(s);
    else
        sat_s = s/psi;
    end
    
    output =  s - K * sat_s;
end
```

#### Teljes blokkdiagram
![full diagram](https://raw.githubusercontent.com/maraid/dc-motor-smc/master/docs/full_block.png)

### 3. Tesztelés
A futtatás paraméterei
```matlab
Ra = 0.6;
La = 0.012;
Kt = 0.8;
Kb = 0.8;
J = 0.0167;
b = 0.0167;

% SMC paraméterek
% K = 3
% lambda = 3
% psi = 0.05
```
![scope](https://raw.githubusercontent.com/maraid/dc-motor-smc/master/docs/scope.png)

A tervezés során valamilyen számítási hiba történt és nem sebesség hanem pozíció szabályozás történik.

### 4. Felhasznált irodalom
https://bono02.wordpress.com/2007/12/14/simulation-and-implementation-of-servo-motor-control-with-sliding-mode-control-smc-using-matlab-and-labview/
Sliding Mode Speed Control of a DC Motor (Srinivasa Kishore Babu Yadlapati, K. Amaresh),  2011
http://www.mogi.bme.hu/TAMOP/robotalkalmazasok/ch07.html
http://www.mogi.bme.hu/TAMOP/digitalis_szervo_hajtasok_angol/ch04.html
Sliding mode position control of a DC motor (P. Feller, U. Benz), 1987


