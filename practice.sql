##文法まとめ

CREATE TABLE posts (					postsテーブルを作成。
  message VARCHAR(140), 				（）内で、140字以内のmessageカラムと、整数のlikesカラムを作成
  likes INT
);

DESC posts;								postsテーブルのカラムなどを表示
SHOW TABLES;							存在するテーブルを表示

DROP TABLE （テーブル名）　　　　			該当のテーブルを削除
↓
DROP TABLE IF EXISTS posts;				もしpostsテーブルがあったら、それを消す記述

INSERT INTO テーブル名 (カラム１, カラム２) VALUES　　カラム１にThanks,カラム２に12が入るようになる。
  ('Thanks', 12);

 SELECT * FROM テーブル名;							テーブルを参照できる。

##データ型

UNSIGNED  正数という意味

DECIMAL(全体の桁数,小数点以下の桁数)　　　　つまり、DECIMAL(5,2)　だとしたら、表す数字の範囲は、  -999.99から、+999.99である。

ENUM('Gadget', 'Game', 'Business') とすると、　この三つの中のどれかしかえらべない、データができる。

SET('Gadget', 'Game', 'Business', 'Sauna') 		複数選択できるENUM。

CREATE TABLE posts (
  categories SET('Gadget', 'Game', 'Business', 'Sauna')　　2^0, 2^1, 2^2, 2^3 のように割り振られており、　1 => Gadgetのみ、　2 => Gameのみ、　2+4=8 =>Game, Business　となる。
)
INSERT INTO posts (categories) VALUES ('12') => Business,Sauna　が入る。

##真偽値、日時の取扱

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  message VARCHAR(140),
  likes INT,
  is_draft BOOL,
  created DATETIME
);

INSERT INTO posts (message, likes, is_draft, created) VALUES
  ('Thanks', 12, TRUE, '2020-10-11 15:32:05'),
  ('Arigato', 4, FALSE, '2020-10-12'),							時間を入れなければ、０時で扱われる。
  ('Merci', 4, 0, NOW());  　　　　　						　	  now()で、現在の時間を扱える。
SELECT * FROM posts;


+---------+-------+----------+---------------------+
| message | likes | is_draft | created             |
+---------+-------+----------+---------------------+
| Tnanks  |    12 |        1 | 1996-08-12 10:21:08 |
| Arigato |     4 |        0 | 1996-08-12 00:00:00 |
| Merci   |     4 |        1 | 2021-01-29 20:09:27 |
+---------+-------+----------+---------------------+

## NULLの取り扱い、NOT NULLや、DEFAULT値の設定の仕方。

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  message VARCHAR(140),
  ① likes INT 						このままだと、　likesがない時その値はNULLとなる。
  ② likes INT NOT NULL				NOT NULLとしてくと、値がない限り、エラーが発生する。
  ③ likes INT DEFAULT 0				likesの値がない場合は、デフォルト値として、0が設定されるようになる。

##値に制限をつける方法　(CHECK, UNIQUE)

CREATE TABLE posts (
  message VARCHAR(140) UNIQUE, 							UNIQUEをつけると、messageに同じ値はつけられなくなる。（一意性を持たせることができる。）
  likes INT CHECK (likes >= 0 AND likes <= 100) 		CHECK (条件)　で、そのカラムに条件を持たせることができる。
);

##一意性のある主キーをテーブルに追加する方法、またそれを自動的に追加する方法

CREATE TABLE posts (
  id INT NOT NULL AUTO_INCREMENT,　　　　　idというカラムを作成。　AUTO_INCREMENTとすることで、そのカラムがPRIMARY KEYに設定されていた場合は、自動的にカラムに追加してくれるようになる。
  message VARCHAR(140),
  likes INT,
  PRIMARY KEY (id)						idを主キーにする記述。
);

INSERT INTO posts (message, likes) VALUES 　　　　　　AUTO_INCREMENTがあるので、わざわざ記述しなくても、idが自動的に作られる。
  ('Thanks', 12),
  ('Arigato', 4),
  ('Merci', 4);

##SELECTでのデータ抽出、いろいろ

CREATE TABLE posts (
  id INT NOT NULL AUTO_INCREMENT,
  message VARCHAR(140),
  likes INT,
  PRIMARY KEY (id)
);

INSERT INTO posts (message, likes) VALUES
  ('Thanks', 12),
  ('Arigato', 4),
  ('Merci', 4),
  ('Gracias', 15),
  ('Danke', 23);

SELECT * FROM posts;				＊は、全てのカラムを抽出するという意味。
SELECT id, message FROM posts;      こうすると、messageカラムと、idカラムのみ。
SELECT * FROM posts WHERE likes < 20;  とすると、likesが２０以下のものを全て取り出す。

SELECT * FROM posts WHERE likes >= 10 AND likes <= 20;  likesが、１０以上２０以下のものを取り出す。
SELECT * FROM posts WHERE likes BETWEEN 10 AND 20;		上記と同じ意味
SELECT * FROM posts WHERE likes NOT BETWEEN 10 AND 20;	上記の否定ver.

SELECT * FROM posts WHERE likes = 4 OR likes = 12;		likesが４か、１２の場合のものを取り出す。
SELECT * FROM posts WHERE likes IN (4, 12);				上記と同じ
SELECT * FROM posts WHERE likes NOT IN (4, 12);			上記の否定ver

##LIKEを用いた抽出方法　％と、＿アンダーバーを用います。

+----+-------------------+-------+
| id | message           | likes |
+----+-------------------+-------+
|  1 | Thank you!        |    12 |
|  2 | thanks 100%       |     4 |
|  3 | Gracias           |     4 |
|  4 | Arigato_gozaimasu |    15 |
|  5 | Arigato! desu     |    23 |
+----+-------------------+-------+　このようなデータベースがあった場合は、

  SELECT * FROM posts WHERE message LIKE 't%';　　　　				messageがtか、Tで始まる要素を取り出す。
  SELECT * FROM posts WHERE message LIKE BINARY 't%';			  BINARYをつけると、大文字小文字を区別するようになるので、id=2だけを取り出すようになる。
  SELECT * FROM posts WHERE message LIKE  '%su%';				  文字列の中に、toが存在している要素を取り出す。文末に、suがあっても取り出すので、id=4,5も取り出される、
  SELECT * FROM posts WHERE message LIKE  '%su';					文末がsuのものを取り出す。

  SELECT * FROM posts WHERE message LIKE '___ga%'					gaの前に、文字が３つある要素を取り出す。　＿は、何かしらの一つの文字を表している。

  また、%や、_を検索する文字列にするには、%や_の前に/をつける。
  例
  SELECT * FROM posts WHERE message LIKE '%/%%'						これで、%を含む要素を探すという意味になり、id = 2　の要素だけを取り出すことができる。

##レコードに、NULLが存在する場合の抽出方法

+----+---------+-------+
| id | message | likes |
+----+---------+-------+
|  1 | Thanks  |    12 |
|  2 | Arigato |     4 |
|  3 | Merci   |  NULL |
|  4 | Gracias |    15 |
|  5 | Danke   |  NULL |
+----+---------+-------+  このようなデータベースがあった場合、

SELECT * FROM posts WHERE likes IS NULL				likes =　NULL　の要素だけを取り出すことができる。
SELECT * FROM posts WHERE likes IS NOT NULL　　　　　 likes != NULL　の要素だけを取り出すことができる・

ただし！
SELECT * FROM posts WHERE likes != 12;　　として、likesが１２以外のものを取り出そうとしても、likesがNULLのid=3,5は取り出されないので、注意！

##抽出結果の並び替え

+----+---------+-------+
| id | message | likes |
+----+---------+-------+
|  1 | Thanks  |    12 |
|  2 | Merci   |     4 |
|  3 | Arigato |     4 |
|  4 | Gracias |    15 |
|  5 | Danke   |     8 |
+----+---------+-------+  このようなデータベースがあった場合

likesの少ない順に並び替えたい時は、SELECT * FROM posts ORDER BY likes;

+----+---------+-------+
| id | message | likes |
+----+---------+-------+
|  2 | Merci   |     4 |
|  3 | Arigato |     4 |
|  5 | Danke   |     8 |
|  1 | Thanks  |    12 |
|  4 | Gracias |    15 |
+----+---------+-------+

likesの多い順に並び替えたい時は、SELECT * FROM posts ORDER BY likes　DESC;　　　　DESCを、加える。

+----+---------+-------+
| id | message | likes |
+----+---------+-------+
|  4 | Gracias |    15 |
|  1 | Thanks  |    12 |
|  5 | Danke   |     8 |
|  2 | Merci   |     4 |
|  3 | Arigato |     4 |
+----+---------+-------+

ここで、さらに、４、５番目のLIKESが同じ値の二つを、アルファベット順に並び替えたい場合は、最後にmessageを加える。

+----+---------+-------+
| id | message | likes |
+----+---------+-------+
|  4 | Gracias |    15 |
|  1 | Thanks  |    12 |
|  5 | Danke   |     8 |
|  3 | Arigato |     4 |
|  2 | Merci   |     4 |
+----+---------+-------+

上から３件だけ表示させたい場合は、LIMIT 3と、加える。

SELECT * FROM posts ORDER BY likes DESC, message LIMIT 3;

+----+---------+-------+
| id | message | likes |
+----+---------+-------+
|  4 | Gracias |    15 |
|  1 | Thanks  |    12 |
|  5 | Danke   |     8 |
+----+---------+-------+

逆に、上位２つを飛ばして、３、４、５番目だけを表示させたい時は、OFFSETを用いる。

SELECT * FROM posts ORDER BY likes DESC, message LIMIT 3 OFFSET 1;　　ちなみに、このOFFSETの数字は、0,1,2というふうに数えているので、上位２つを取り除きたい場合は、OFFSET 1 と記述する。
また、SELECT * FROM posts ORDER BY likes DESC, message LIMIT 1,3;  （ LIMIT 取り除きたい個数,表示する数　）
