#set page(
  numbering: "1",
)
#set text(font: "Noto Serif JP")
// #set text(font: "Yu Mincho")
#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")
#show link: underline


#align(center, text(17pt)[
  *オイラー・ラグランジュ方程式*
])

#outline()

= オイラー・ラグランジュ方程式

オイラー・ラグランジュ方程式は、下記のように定義される。

$ (diff cal(L)) / (diff q_i) - d / (d t) (diff cal(L)) / (diff dot(q_i)) = 0  $ <euler>

ここで $cal(L)$ はラグランジュ関数(Lagrangean)、 $q_i$ は一般化座標、 $dot(q)_i$ は一般化速度(一般化座標の時間微分) である。

ラグランジュ関数は

$ L = T − V $

と定義される。ここで T
 は運動エネルギー、 V
 はポテンシャルエネルギーである。

このようにいきなり書かれても何がなんだかわからないし、いきなり覚えようとしても難しいが、これは非常に強力なツールで、特に座標系を普通の直交座標系以外のものにした場合にもニュートンの運動方程式に相当するものを導出できる優れものである。 実際の物理的描像を理解したり、問題に適用してみたりするにつれて覚えられるようになるだろう。

== 導出

ある粒子の座標 $x$ が時間に従って変化していくという状況を考える。
この座標は時間の関数 $x(t)$ と表せる。 この粒子が $t = t_0$ のときに $x_0$、
$t = t_1$ のときに $x_1$ という座標をとるとすると、この粒子が $t_0 < t < t_1$
の間描く曲線が想像できる。

さらにある座標とその座標軸上の速度の関数 $f(x, dot(x))$ を考える。
これを $x(t_0) = x_0$ から $x(t_1) = x_1$ まで積分したものを作用(Action)と呼ぶ。
これを書き下すと

$ A = integral_(t_0)^(t_1) f(x(t), dot(x)(t)) dif t $

となる。

== 最小作用の原理

さて、ここで最小作用の原理というものを適用する。
最小作用の原理とは、物理的過程は作用を最小にするように推移する、という原理で、なぜかと聞かれても答えられる人はおらず、実際の現象を数多観測してきた結果の経験則として、そういった原理が常に成り立つということに過ぎない。
たとえばボールを投げ上げれば放物線を描いて落ちるし、光は到達時間が最短になるように伝搬する(フェルマーの原理)が、これも最小作用の原理に従った運動方程式から導けることである。

また、ここで作用は連続関数であるとみなす。
ここからの目的は作用をいじくることによって微分方程式を導くことであり、それが運動方程式になる。
このためには作用が $x$ の不連続な関数であったり、微分不可能であったりすると都合が悪い。
まあ、実際の物理現象はほぼ連続関数で成り立っているとみなして差し支えないので、わざわざ仮定として置くこともしないという場合も多い。

さて、これらの仮定から、最小値を探すということは停留点を探すということに言い換えられる。 厳密には最大値や鞍部点、極値も停留点になるわけだが、特にラグランジュ関数に関する作用は最小値ただ一点で停留点となる性質があるようである。 詳しくは私も証明できない。

少し普通の停留点と違うのは、動かすのは変数ではなく関数だということである。
具体的には、 $f(x, dot(x))$ の関数形を動かすことによって $A$ を最小化するのである。
変分法ではこれを関数の前に $delta$ をつけることによって表す。
すなわち、停留点の条件は、

$ delta A = integral_(t_0)^(t_1) delta f(x, dot(x)) dif t = 0 $

となる。

では $delta f(x, dot(x))$ とは何なのか。
これを考えるにあたって、 $f$ を離散近似する。
すなわち $x$ を連続関数ではなく、離散化された変数 $x_i$ とする。
離散化した $t$ の幅を $epsilon$ とすると、

$ f(x_i, (x_i - x_(i - 1)) / epsilon). $

と表せる。

もし注目している $i$ 番目の $x_i$ を変化させた場合、 $f$ はどう変化するだろうか。
まず $f$ の $i$ 番目のサンプル $f_i$ について、 $x_i$ に関する偏微分であらわすと、

$ diff / (diff x_i) &= diff / (diff x_i) f (x_i, (x_i - x_(i - 1)) / epsilon) \
&= (diff f_i) / (diff x_i) + (diff v_i) / (diff x_i) (diff f_i) / (diff v_i) \
&= (diff f_i) / (diff x_i) + 1 / epsilon (diff f_i) / (diff v_i)
$

となる。 ここで煩雑なので $v_i ident (x_i - x_(i−1)) / epsilon$ とおいた。

ただし、実際には全体の $(diff f) / (diff x_i)$ を求めたいので、 $f_(i+1)$ からの寄与も生じる。

$ diff / (diff x_i) f_(i+1) &= diff / (diff x_i) f(x_(i+1), (x_(i+1) - x_i) / epsilon) \
&= (diff v_(i + 1)) / (diff x_i) (diff f_(i + 1)) / (diff v_(i + 1)) \
&= - 1 / epsilon (diff f_(i + 1)) / (diff v_(i + 1))
$

つまり、全体の変化は

$ (diff f_i) / (diff x_i) + 1 / epsilon (diff f_i) / (diff v_i) - 1 / epsilon (diff f_(i + 1)) / (diff v_(i + 1)). $

となる。

ところで $(f_(i+1) − f_i) / epsilon$ というのは、$epsilon -> 0$ の極限においては微分に他ならない。
また、 $v_i$ というのは極限において位置座標の微分、すなわち速度である。

これをゼロにするのであるから、最終的に

$ (diff f_i) / (diff x_i) - d / (d t) (diff f_i) / (diff dot(x)_i) = 0 $

となる。 連続化極限において $i$ という添え字がなくなり、代わりに $t$ という連続変数の関数となる結果、のオイラー・ラグランジュ方程式が得られる。

$
x &= X cos(omega t) + Y sin(omega t) \
y &= X sin(omega t) − Y cos(omega t).
$ <rotating>

この座標系で自由粒子がどのように運動するか考えてみよう。
もちろん慣性系では直線運動をするわけだが、回転している系ではニュートンの運動方程式が成り立たないので、オイラー・ラグランジュの方程式から求める。
ニュートンの運動方程式を愚直に座標変換することもできるはずだが、オイラー・ラグランジュの方程式から導くほうがはるかに簡単である、 という触れ込みなのだが、実際にやってみると結構面倒である。

ともかく、自由粒子のラグランジュ関数は、ポテンシャルエネルギーがゼロであるとすれば

$ cal(L) = m / 2 (dot(x)^2 + dot(y)^2) $

である。

ここで (2) を代入して中身を地道に計算すると、

$ cal(L) = m / 2 (dot(X)^2 + dot(Y)^2) + (omega^2 m) / 2 (X^2 + Y^2)
  + (omega m) / 2 (X dot(Y) - Y dot(X)) $

となる。

この式の右辺の最初の項は、回転している座標系での直線運動のエネルギーと解釈できる。
第２の項は、回転中心からの遠心力のポテンシャルである。 $r = X^2 + Y^2$ とおいて $r$ で微分してみれば、遠心方向に距離に比例した力になることがわかるだろう。
最後の項は、位置と速度の両方に依存する項である。この項によってもたらされる見かけ上の力はコリオリの力と呼ばれる。

実際に $X$ 成分に関するオイラー・ラグランジュの方程式を求めてみよう。

$ (diff cal(L)) / (diff X) - d / (d t) (diff cal(L)) / (diff dot(X)) =
omega^2 m X + (omega m) / 2 dot(Y) - m dot.double(X) + (omega m) / 2 dot(Y) = 0 \
therefore m dot.double(X) = omega^2 m X + omega m dot(Y)
$

これを $m a = F$ と対比してみると、右辺第１項は遠心力であるが、第２項は $X$ とは垂直な方向への速度に依存する項である。
同じように $Y$ に関して求めても、やはり $dot(X)$ に比例する項が得られる。
このことから、コリオリの力は速度ベクトルに垂直な方向へ作用するということができる。
速度の絶対値に寄与しないので、運動エネルギーは変化させず、向きだけを変化させる力である。
これは電磁気学での磁場中を運動する荷電粒子に働くローレンツ力と同じ性質であるのは注目に値する。

== 極座標

極座標の場合はどうなるだろうか。
極座標は座標系そのものは時間によって変化しないが、粒子の座標は $r, theta$ という座標系で表される代物である。
この変換則は単純に次のようになる。

$ x &= r cos(theta) \
  y &= r sin(theta). $

自由粒子の運動方程式を求めるため、前節と同様にラグランジュ関数のポテンシャルエネルギーがゼロであるとして

$ cal(L) &= m / 2 (dot(x)^2 + dot(y)^2) \
&= m / 2 (dot(r)^2 + r^2 dot(theta)^2)
$

となる。

ここで $r$ に関するオイラー・ラグランジュの方程式から、

$ (diff cal(L)) / (diff r) - d / (d t) (diff cal(L)) / (diff dot(r)) &= m r dot(theta)^2 - d / (d t) m dot(r) \
&= m r dot(theta)^2 - m dot.double(r) = 0 \
therefore m r dot(theta)^2 &= m dot.double(r).
$

この式を $F = m a$ と見立てると、左辺は $theta^2$ に比例する力、すなわち遠心力であるとみなせる。
遠心力は $r$ 方向で角速度の2乗に比例することが分かる。

また、 $theta$ に関するオイラー・ラグランジュの方程式から、

$ (diff cal(L)) / (diff theta) - d / (d t) (diff cal(L)) / (diff dot(theta)) = - m r^2 dot(theta) = 0. $

となる。

これは角運動量の保存則である。

== 対称性と保存則

以上の保存則は場当たり的であり、もっと複雑な一般化座標系を使ったときにどう導けばいいかといわれると迷子になりそうである。 そこで一般化座標のセットを使って言えることを一般化することを考える。

まず、変分原理から、次のように書ける。これは全微分の表現と同じである。

$ delta f(arrow(q)) = sum_i (diff f) / (diff q_i) delta q_i $

ここで $f(dot(q))$ は全ての $q_i(i=1,2,…,n)$ に依存する関数である。

ここで、変換の対称性というものを定義する。
対称性とは、変換の性質であり、ラグランジュ関数を変化させないような座標系への微小な変化であるということである。
たとえば原点の平行移動や、座標系の回転などがそれにあたる。
平行移動や回転は微小な変化ではないが、微小な変化を積み重ねていくことによって到達できるため、対称性の性質を持っている。

対称性によって一般化座標 $q_i$ に生じる変分 $delta q_i$ を、関数の組 $f_i(dot(q))$ を使って

$ delta q_i = f_i (arrow(q)) delta $ <variation>

と表すことができる。 ここで何かの前についていない $delta$ は微小な変化量そのものを表す。
これは微小量 $delta$ の範囲内では線形近似できるという意味である。

ところで、ラグランジュ関数は一般化座標 $q_i$ および一般化速度 $dot(q)_i$ の関数であるから、その変分は

$ delta cal(L)(arrow(q), arrow(dot(q))) = sum_i ((diff cal(L)) / (diff q_i) delta q_i + (diff cal(L)) / (diff dot(q)_i) delta dot(q)_i). $ <general>

となる。

さて、ラグランジュ関数がオイラー・ラグランジュの方程式を満たすとき、すなわち運動の法則を満たすとき、 @euler が成り立つということを上では導出した。 簡単のため、

$ (diff cal(L)) / (diff dot(q)_i) ident p_i. $ <Lqdotp>

という記号を導入する。 これはデカルト座標系では運動量に相当するものであるが、一般的には運動量以外の「何か」になりうる。

これでオイラー・ラグランジュの方程式を書き直すと、

$ (diff cal(L)) / (diff q_i) = dot(p)_i $ <Lqpdot>

となる。

これを使うと、 @general は、

$ delta cal(L)(arrow(q), arrow(dot(q))) = sum_i (dot(p)_i delta q_i + p_i delta dot(q)_i) $

となる。 積の微分の公式を使えばまとめて

$ delta cal(L)(arrow(q), arrow(dot(q))) = d / (d t) sum_i p_i delta q_i $ 

と書ける。

さて、ここで $delta q_i$ が対称性によって生じた変分であるとする。
するとラグランジュ関数は変化しないはずであるから、 @variation を使って

$ delta cal(L)(arrow(q), arrow(dot(q))) = d / (d t) sum_i p_i delta q_i $ 

である。

$delta$ を因数として外に出すと

$ d / (d t) sum_i p_i f_i (arrow(q)) = 0 $

と書き直せる。

ここで、時間微分される対象の量

$ Q ident sum_i p_i f_i (arrow(q)) $

が保存量となる。

いくつかの座標系で実際に計算してみると、これは運動量保存則や、角運動量保存則となる。

ここで示した方法はネーターの定理の応用の一つである。

= 時間併進対称性とエネルギー保存則

前節では空間座標の併進および回転対称性がある場合に運動量保存則を導いたが、今回は時間併進対称性を使ってエネルギー保存則を導く。

時間併進対称性は、ラグランジュ関数が明示的な時間の関数ではないということである。これはラグランジュ関数が $q_i, dot(q)_i$ のみの明示的な関数であるともいえる。
これを $cal(L)(dot(q), dot.double(q))$ と表現することもできる。

さて、ラグランジュ関数の時間微分を書くと

$ (d cal(L)(arrow(q), arrow(dot(q)))) / (d t) = sum_i { (diff cal(L)) / (diff q_i) dot(q)_i + (diff cal(L)) / (diff dot(q)_i) dot.double(q)_i } $ <lagrange-time>

ここで @Lqdotp, @Lqpdot を使うと

$ (d cal(L)) / (d t) = sum_i (p_i dot(q) + dot(p)_i dot.double(q)_i). $

ここで、また積の微分の公式を使う。こういったトリックは繰り返し同じものが出てくるので、それほど多様な手練手管ではない。

$ (d cal(L)) / (d t) = sum_i d / (d t) p_i dot(q)_i $

さて、ここで両辺が何かの時間微分ということになった。つまり

$ d / (d t) { cal(L) - sum_i p_i dot(q)_i } = 0 $ <lagrange-dt>

と書ける。

ここで時間微分されている中身

$ cal(H) ident sum_i p_i dot(q)_i - cal(L) $

をハミルトニアンと呼ぶ。
なぜこの符号かというと、定義の問題であり、歴史的経緯でこうなっているようである。
ハミルトニアンは時間併進対称性があれば保存される、ということである。

実際に1次元のデカルト座標系でハミルトニアンを書き表してみよう。
運動量は $p_i = m_i dot(x)_i$ となるので、

$ cal(H) &= sum_i p_i dot(q)_i - cal(L) \
&= sum_i [m_i dot(x)_i^2 - { m / 2 dot(x)_i - V(x_i)}] \
&= sum_i { (m dot(x)_i^2) / 2 + V(x_i) }.
$

となる。
これは運動エネルギーとポテンシャルエネルギーの和、つまり全エネルギーである。
一般に、古典的な系ではハミルトニアンは全エネルギーとなる。
量子力学ではこのように簡単に運動エネルギーとポテンシャルエネルギーの和としては表現できないが、それでも保存される量であることに変わりはない。

さて、時間併進対称性がない場合はどうなるだろうか。 @lagrange-time から @lagrange-dt までの議論を $cal(L)$ に明示的な時間依存性があるという条件 $cal(L)(dot(q), dot.double(q), t)$ でやりなおすと

$ (d cal(L)) / (d t) &= sum_i d / (d t) p_i dot(q)_i + (diff cal(L)) / (diff t) \
(d cal(H)) / (d t) &= - (diff cal(L)) / (diff t).
$

と書ける。 符号にかかわらずハミルトニアンが保存されるという結論には変わりない。

= ハミルトン方程式

ハミルトニアンの全微分を取ってみよう。

$ d cal(H) = sum_i [ dot(q)_i d p_i + p_i d dot(q) - (diff cal(L)) / (diff dot(q)_i) d dot(q)_i - (diff cal(L)) / (diff q_i) d q_i] $

ここで、 $(diff cal(L)) / (diff dot(q)_i) = p_i$, $(diff cal(L)) / (diff p_i) = dot(q)_i$ という関係を使って単純化すると

$ d cal(H) = sum_i (dot(q)_i d p_i - dot(p)_i d q_i) $

それぞれの $p_i$ と $q_i$ での偏微分を取ると

$ (diff cal(H)) / (diff p_i) &= dot(q)_i \
 (diff cal(H)) / (diff q_i) &= - dot(p)_i $

となる。

これらの方程式をハミルトン方程式という。

= 参考文献

+ #link("https://www.youtube.com/watch?v=3apIZCpmdls")[Leonard Susskind, Classical Mechanics | Lecture 3]
+ #link("https://www.youtube.com/watch?v=ojEwHlyty4Q")[Leonard Susskind, Classical Mechanics | Lecture 4]
+ #link("https://www.youtube.com/watch?v=lW9GJ0aiaNc")[Leonard Susskind, Classical Mechanics | Lecture 5]
+ #link("https://en.wikipedia.org/wiki/Noether%27s_theorem")[Wikipedia's Noether's theorem article]
