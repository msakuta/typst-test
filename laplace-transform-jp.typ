#set page(
  numbering: "1",
)
#set text(font: ("linux libertine", "IPAMincho"))
#set math.equation(numbering: "(1)")

#align(center, text(17pt)[
  *ラプラス変換*
])

#outline()

= ラプラス変換

ラプラス変換は、下記に示す[[FFT|フーリエ変換]]によく似ている。

$
F(omega) &= integral_(-infinity)^infinity f(t) e^(-j omega t) d t
$

違いは、 $e^(-j omega t)$ の代わりに $e^(-s t)$ を使い、積分範囲を $"[" 0, infinity ")"$ としたものである。

$
F(s) = integral_0^infinity f(t) e^(-s t) d t
$

こうして得られた $F(s)$ は、フーリエ変換と同じく複素数 $s$ の関数であり、 $cal(L)[f]$ と表し、 $f$ のラプラス変換と呼ぶ。

フーリエ変換と同じく、線形システム解析に極めて有用であるが、微妙な違いがある。

まず式から明らかなように、 $F(s)$ は $f(t)$ の $t$ が正の範囲しか含まない。
このため $f(t)$ が時間 $t$ だけ過去の情報を示しているとすれば、過去の状態のみに依存する関数となる。
このことは過渡応答のような因果性のある事象の解析にはフーリエ変換に比べて有利である。

また、被積分関数の係数 $e^(-s t)$ を見ればわかるように、 $t$ を負の無限大まで拡張すると積分も無限大に発散する。
このため単なる積分演算上の都合からも正の範囲に限る必要がある。


== ラプラス変換の演算

ラプラス変換の最も重要な特徴は、微分・積分演算が積算・除算演算に帰着できるということである。
詳しい証明は文献#footnote[山田直平・國枝壽博　応用数学講座　ラプラス変換・演算子法　(昭和34年)　さすがに古すぎるのでもっと新しい教科書を探したほうが良いと思う]に譲るが、もし $f^((0))(0)=f^((1))(0)=...=f^((n))(0)=0$ であり、ラプラス変換の積分が収束するならば
$
cal(L)[f^((n))] = s^n cal(L)[f]
$

である。

積分に関しては
$
cal(L) lr([integral_0^t f(t) d t ]) = 1 / s cal(L)[f]
$

であり、多重積分は
$
cal(L) lr([ underbrace(integral_0^t integral_0^t dots.c integral_0^t, n) f(t) d t]) = 1 / (s^n) cal(L)[f]
$ <eq:multiint>

となる。

一般に $f(t)$ を微係数とする関数は
$
f^((-1))(t) = f^((-1))(0) + integral_0^t f(t) d t
$

と書けるので、 @eq:multiint は
$
cal(L)[f^((-n))] = 1 / s^n cal(L)[f]
$

とも書ける。
