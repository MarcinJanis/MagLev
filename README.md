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