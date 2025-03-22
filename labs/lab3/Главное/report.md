---
## Front matter
title: "Лабораторная работа №3"
subtitle: "Модель боевых действий"
author: "Аскеров Александр Эдуардович"

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
lof: true # List of figures
lot: false # List of tables
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian
  options:
	- spelling=modern
	- babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: IBM Plex Serif
romanfont: IBM Plex Serif
sansfont: IBM Plex Sans
monofont: IBM Plex Mono
mathfont: STIX Two Math
mainfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
romanfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
sansfontoptions: Ligatures=Common,Ligatures=TeX,Scale=MatchLowercase,Scale=0.94
monofontoptions: Scale=MatchLowercase,Scale=0.94,FakeStretch=0.9
mathfontoptions:
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Список иллюстраций"
lotTitle: "Список таблиц"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

Построить модель боевых действий на языке программирования Julia, а также с помощью OpenModelica.

# Задание

Между страной $X$ и страной $Y$ идёт война. Численность состава войск исчисляется от начала войны, и является временными функциями $x(t)$ и $y(t)$. В начальный момент времени страна $X$ имеет армию численностью 500 000 человек, а в распоряжении страны $Y$ армия численностью в 500 000 человек. Для упрощения модели считаем, что коэффициенты $a, b, c, h$ постоянны. Также считаем, что $P(t)$ и $Q(t)$ -- непрерывные функции.

Построить графики изменения численности войск армии $X$ и армии $Y$ для  следующих случаев:

1. Модель боевых действий между регулярными войсками
$$\begin{cases}
    \dfrac{dx}{dt} = -0.45x(t)- 0.86y(t)+sin(t+1)\\\\
    \dfrac{dy}{dt} = -0.49x(t)- 0.73y(t)+cos(t+2)
\end{cases}$$

2. Модель ведения боевых действий с участием регулярных войск и партизанских отрядов

$$\begin{cases}
    \dfrac{dx}{dt} = -0.17x(t)-0.65y(t)+sin(2t)+2\\\\
    \dfrac{dy}{dt} = -0.31x(t)y(t)-0.28y(t)+cos(t)+2
\end{cases}$$

# Теоретическое введение

Уравнения Ланчестера (законы Осипова-Ланчестера) -- это дифференциальные уравнения, описывающие зависимость между силами сражающихся сторон A и D как функцию от времени, причём функция зависит только от A и D.

В 1916 году, в разгар первой мировой войны, Фредерик Ланчестер разработал систему дифференциальных уравнений для демонстрации соотношения между противостоящими силами. Среди них есть так называемые Линейные законы Ланчестера (первого рода или честного боя, для рукопашного боя или неприцельного огня) и Квадратичные законы Ланчестера (для войн начиная с XX века с применением прицельного огня, дальнобойных орудий, огнестрельного оружия).

# Выполнение лабораторной работы

## Модель боевых действий между регулярными войсками

$$\begin{cases}
    \dfrac{dx}{dt} = -0.45x(t)-0.86y(t)+sin(t+1)\\\\
    \dfrac{dy}{dt} = -0.49x(t)-0.73y(t)+cos(t+2)
\end{cases}$$

Потери, не связанные с боевыми действиями, описывают члены $-0.45x(t)$ и $-0.73y(t)$ (коэффициенты при $x$ и $y$ -- это величины, характеризующие степень влияния различных факторов на потери), члены $-0.86y(t)$ и $-0.49x(t)$ отражают потери на поле боя (коэффициенты при  $x$ и $y$ указывают на эффективность боевых действий со сторон у и х соответственно). Функции $P(t)=sin(t+1)$, $Q(t)=cos(t+2)$ учитывают возможность подхода подкрепления к войскам $X$ и $Y$ в течение одного дня.

Построим приведённую модель, используя Julia:

```Julia
using DifferentialEquations
using Plots

# Вариант №59
people = Float64[500000, 500000]

# Первый случай
a = [0.0, 3.0]
function syst(du, u, p, t)
    du[1] = -0.45*u[1] - 0.86*u[2] + sin(t+1)
    du[2] = -0.49*u[1] - 0.73*u[2] + cos(t+2)
end

prob = ODEProblem(syst, people, a)
sol = solve(prob, dtmax=0.1)
A1 = [u[1] for u in sol.u]
A2 = [u[2] for u in sol.u]
T = [t for t in sol.t]

plt = plot(title=:"Модель боевых действий - первый случай")
plot!(plt, T, A1, label=:"Численность армии X")
plot!(plt, T, A2, label=:"Численность армии Y", color=:pink)
savefig("3_1.png")
```

В результате получаем следующий график:

![Модель боевых действий  между регулярными войсками](image/J1.png){#fig:001 width=70%}

Из графика видно, что выиграла армия страны $Y$, поскольку численность армии страны $X$ стала 0, а потом и вообще ушла в отрицательную часть графика. Потери страны $Y$ очень значительные.

Теперь построим эту же модель с помощью OpenModelica.

```OpenModelica
model lab3
  parameter Real a = 0.45;
  parameter Real b = 0.86;
  parameter Real c = 0.49;
  parameter Real h = 0.73;
  parameter Real x0 = 500000;
  parameter Real y0 = 500000;
  Real x(start=x0);
  Real y(start=y0);
  Real P = sin(time + 1);
  Real Q = cos(time + 2);
equation
  der(x) = -a*x - b*y + P;
  der(y) = -c*x - h*y + Q;
  
  annotation(
    experiment(
      StartTime = 0,
      StopTime = 2,
      Tolerance = 1e-6,
      Interval = 0.002));
end lab3;
```

В результате получаем следующий график изменения численности армий:

![Модель боевых действий  между регулярными войсками](image/OM1.png){#fig:002 width=70%}

Здесь всё так же видно, что выиграла армия $Y$.

Также заметим, что график, построенный на Julia, и график из OpenModelica ничем не отличаются. По крайней мере, невооруженным глазом отличий не видно.

## Модель ведение боевых действий с участием регулярных войск и партизанских отрядов

Во втором случае в борьбу добавляются партизанские отряды. Нерегулярные войска в отличии от постоянной армии менее уязвимы, так как действуют скрытно, в этом случае сопернику приходится действовать неизбирательно -- по площадям, занимаемым партизанами. Поэтому считается, что темп потерь партизан, проводящих свои операции в разных местах на некоторой известной территории, пропорционален не только численности армейских соединений, но и численности самих партизан. В результате модель принимает такой вид:
$$\begin{cases}
    \dfrac{dx}{dt} = -0.17x(t)-0.65y(t)+sin(2t)+2\\\\
    \dfrac{dy}{dt} = -0.31x(t)y(t)-0.28y(t)+cos(t)+2
\end{cases}$$

В этой системе все величины имею тот же смысл, что и в первой модели.

Построим модель на Julia:

```Julia
# Второй случай
a = [0.0, 0.0001]
function syst(du, u, p, t)
    du[1] = -0.17*u[1] - 0.65*u[2] + sin(2*t) + 2
    du[2] = -0.31*u[1]*u[2] - 0.28*u[2] + cos(t) + 2  
end

prob = ODEProblem(syst, people, a)
sol = solve(prob, dtmax=0.1)
A1 = [u[1] for u in sol.u]
A2 = [u[2] for u in sol.u]
T = [t for t in sol.t]

plt = plot(title=:"Модель боевых действий - второй случай", legend=:topright)
plot!(plt, T, A1, label=:"Численность армии X")
plot!(plt, T, A2, label=:"Численность армии Y", color=:pink)
savefig("3_2.png")
```

В результате получаем следующий график изменения численности армий:

![Модель боевых действий с участием регулярных войск и партизанских отрядов](image/J2.png){#fig:003 width=70%}


Здесь уже выигрывает армия $X$, причём численность армии $Y$ уменьшается до нуля очень быстро.

Теперь выполним построение второй модели в OpenModelica.

```
model lab3
  parameter Real a = 0.17;
  parameter Real b = 0.65;
  parameter Real c = 0.31;
  parameter Real h = 0.28;
  parameter Real x0 = 500000;
  parameter Real y0 = 500000;
  Real x(start=x0);
  Real y(start=y0);
  Real P = sin(2*time) + 2;
  Real Q = cos(time) + 2;
equation
  der(x) = -a*x - b*y + P;
  der(y) = -c*x*y - h*y + Q;
  
  annotation(
    experiment(
      StartTime = 0,
      StopTime = 2,
      Tolerance = 1e-6,
      Interval = 0.002));
end lab3;
```
В результате получается такой график:

![Модель боевых действий с участием регулярных войск и партизанских отрядов](image/OM2.png){#fig:004 width=70%}

Из графика видно, что выиграла армия $X$, причём моментально. Несмотря на победу над другой армией, армия страны $X$ продолжает нести относительно незначительные потери.

Сравнивая графики, полученные в Julia и OpenModelica, особой разницы не видно. Если приглядеться, можно заметить, что в Julia график выглядит точнее прорисованным.

# Выводы

В процессе выполнения данной лабораторной работы была построена модель боевых действий на языке программирования Julia, а также с помощью OpenModelica. Был проведён сравнительный анализ. В случае с первой моделью, победила армия страны $Y$, в случае со второй моделью, победила армия страны $X$.

