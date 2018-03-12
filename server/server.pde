//参考サイト http://kousaku-kousaku.blogspot.jp/2008/11/processinghttpweb.html

import processing.net.*;
//ポート3000番で起動
int netPort = 3000;

Server server;
//一時的に保存しとく変数
ArrayList<String> savefile = new ArrayList<String>();

void setup() {
  initNet();
}

void draw() {
  receiveMessage();
}

//ネットワークで受け取るための初期化
void initNet() {
  server = new Server(this, netPort);
  println("server started");
}

//ブラウザからのリクエストを受け取りパースする
//draw内で回す関数
void receiveMessage() {
  Client client = server.available();

  if (client != null) {
    //クライアントからのデータがあるとき
    if (client.available()>0) {
      String s = client.readString();
      savefile.add(s);

      //受信終了次第、読み込む
      //受信終了を明示的な正規表現に変えたい
      //データ量が多いと失敗する恐れがある
      if (match(s, "(\r\n|\n|\r)(\r\n|\n|\r)")!=null) {
        String request_text = "";
        for (String _str : savefile) {
          request_text+=_str;
        }
        //println(request_text);
        //正規表現でheaderとbodyを読み込む
        String [] request_header = match(request_text, "^(.*)\r\n\r\n");
        String [] request_body = match(request_text, "\r\n\r\n(.*)$");
        println("request_header-------------------");
        println(request_header[1]);
        println("request_body-------------------");
        println(request_body[1]);

        //以下の内容をクライアントへ返信する（HTTPレスポンス）
        client.write("HTTP/1.1 200 OK\n");//接続成立
        client.write("Content-Type: text/html\n");//HTML文書形式
        client.write("\n");//空白行
      }
      client.stop();//クライアントとの接続を停止
    }
  }
}