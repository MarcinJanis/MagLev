# MagLev
Laboratorium problemowe 2: Lewitacja magnetyczna

Link do artykułu gdzie jest dobrze opisany model matematyczny:
`https://yadda.icm.edu.pl/baztech/element/bwmeta1.element.baztech-article-BSW1-0104-0065/c/Baczyk.pdf`

1) `Resistance_ident.m`
Identyfikacja rezystancji cewki i rysowanie charakterystyki jej oporu na bazie pomiarów
Po odpaleniu wygeneruje wykresik i wyswietli wartość rezystancji 

2) `Inductance_scalling.m`
Plik do rysowania zależności indukcyjności cewki od położenia kulki i pochodnej indukcyjności po odległości kulki, będą potrzebne w modelu. Wyrysuje też wykresiki żeby zweryfikować 
Należy wykonać pomiary:
Mierzyć indukcyjność cewki dla pozyjcji kulki, począwszy od góry (pozycja 0 - gdy kulka dotyka elektromagnesu). 
Pomiary podokonwyać co skok śruby czyli 0.7 mm 
Wartości wpisać do wektora L (w piątej linii kodu), a reztę zrobi program 

3) `Model_parameters.m`
Tam wpisuje parametry które będziemy uzywać w modelu, 
(te wektory scale_VtoM_x i scale_VtoM_y mają iść do lookup table które będzie przeskalowywać napięcie z czujnika położenia kulki na metry:   scale_VtoM_x -> scale_VtoM_y)

4) `Model.slx`
To jest model który będziemy porównywać do rzeczywistych pomiarów. Narazie w wstępna faza, in progress, bo chuj wi czy to jest git czy nie


____ rónania - wersja robocza:
# model fizyczny obiektu 

___
**rysunek **
___

# Równania Lagrange'a:

`Funkcja Lagrange'a`

$$\mathcal{L} = E_{kin} - E_{pot}$$
$E_{kin}=\frac{1}{2}m\dot{x}^2+\frac{1}{2}L(x)\dot{q}^2+qu$$
$E_{pot}=mg(-x)$

where:
$x_i=
\begin{bmatrix}
x \\
q 
\end{bmatrix}$ -(współrzędną uogólniona),
$x$ - position,
$q$ - electric charge,
$i=\dot{q}$ - current,
$L(x)$ - Inductance

`Lagrange equation`
$$
\frac{d}{dt}\left( \frac{\partial \mathcal{L}}{\partial \dot{x_i}} \right)
\;-\;
\frac{\partial \mathcal{L}}{\partial x_i}
\;+\;
\frac{\partial \mathcal{R}}{\partial \dot{x_i}}
= Q_{ext}
$$
where:
$\mathcal{R}=\frac{1}{2}Ri^2$ - Enery that is lost on resistance
$R$ - Resistance
$Q_{ext}=\frac{\partial \dot{q}u}{\partial\dot{q}}=u$ - (uogólnione siły zewnętrzne)

po podstawieniu do równania:

$$
\begin{bmatrix}
m\ddot{x}  \\
\frac{dL(x)}{dt}\ddot{q}
\end{bmatrix}
\;-\;
\begin{bmatrix}
mg+\frac{1}{2}\dot{q}^2 \frac{\partial L(x)}{\partial x}  \\
0
\end{bmatrix}
\;+\;
\begin{bmatrix}
0  \\
R\dot{q}
\end{bmatrix}
\;=\;
u
$$

przekształcając do równań stanu otrzymujemt dwa równania opisujące dynamikę układu:
$\dot{x}=v$
$\dot{v} = \frac{1}{2m}\frac{\partial L(x)}{\partial{x}}i^2 - g$
$\dot{i}=\frac{1}{L(x)}(u-iR-\frac{dL(x)}{d(x)}vi)$



---
tego się nie da do maierzy
A to przekształcić można do równań stanu:
$$ \mathbf{\dot{x}} = \mathbf{A} \mathbf{x} +  \mathbf{B}u$$
$$ y = \mathbf{C} \mathbf{x} +  \mathbf{D}u$$
gdzie:
$$ \mathbf{x}=
\begin{bmatrix}
x  \\
v \\
i 
\end{bmatrix}$$
$$ \mathbf{A}=
\begin{bmatrix}
0 & 1 & 0  \\
0 & 0 & \frac{1}{2m}\frac{\partial L(x)}{\partial{x}} \\
i 
\end{bmatrix}$$
$$ \mathbf{C}$$
$$ \mathbf{D}$$
$$ \mathbf{E}$$
