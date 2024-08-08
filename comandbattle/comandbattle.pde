PImage slime,goblin,dragon;
import ddf.minim.*;//mp3ファイルを取り込めるようにする
Minim minim = new Minim(this);
//キャラクターのステータス、ダメージ計算設定
abstract class characters{
  int maxHp,hp,maxMp,mp,attack,guard,sAttack,sGuard;
  String name;
  characters(int maxHp0,int hp0,int maxMp0,int mp0,int attack0,int guard0,int sAttack0,int sGuard0,String name0){
    maxHp=maxHp0;
    hp=hp0;
    maxMp=maxMp0;
    mp=mp0;
    attack=attack0;
    guard=guard0;
    sAttack=sAttack0;
    sGuard=sGuard0;
    name=name0;
  }
  void damage(int damage,boolean skill){
    if(skill){
      hp-=damage-sGuard;
    }else{
      hp-=damage-guard;
    }
  }
  int attack(boolean skill){
    if(skill){
      return sAttack+int(random(-10,10));
    }else{
      return attack+int(random(-10,10)); 
    }  
  }
}

class Enemy extends characters{
   PImage ilust;
   Enemy(int maxHp0,int hp0,int maxMp0,int mp0,int attack0,int guard0,int sAttack0,int sGuard0,String name0,PImage ilust0){
    super(maxHp0,hp0,maxMp0,mp0,attack0,guard0,sAttack0,sGuard0,name0);
    ilust=ilust0;
   }
}

class Player extends characters{
  Player(int maxHp0,int hp0,int mpMax0,int mp0,int attack0,int guard0,int sAttack0,int sGuard0,String name0){
    super(maxHp0,hp0,mpMax0,mp0,attack0,guard0,sAttack0,sGuard0,name0);
  }
}
//プレイヤーと敵のコマンド設定
class Command{
  int r=int(random(4));
  int playerCommand(){
    playerGuard=false;
    int c=-1;
    if(keyPressed){
      if(down==0&&key==ENTER){
        sword.play();
        sword.rewind();
        int attack=player.attack(false);
          if(enemyGuard==true){
            if(attack/2-enemyData[i].guard<=0){
              message="ダメージを与えられない！";
              text(0,500,300);
            }else{
              enemyData[i].damage(attack/2,false);
              message="通常攻撃！"+(attack/2-enemyData[i].guard)+"のダメージを与えた!";
              text(attack/2-enemyData[i].guard,500,300);
            }
          }else{
            if(attack-enemyData[i].guard<=0){
              message="ダメージを与えられない！";
              text(0,500,300);
            }else{
              enemyData[i].damage(attack,false);
              message="通常攻撃！"+(attack-enemyData[i].guard)+"のダメージを与えた!";
              text(attack-enemyData[i].guard,500,300);
            }
          }
          if(enemyData[i].hp<0){
            enemyData[i].hp=0;
          }
        c = 0;
      }else if(down==2&&key==ENTER){
        message="防御した";
        playerGuard=true;
        c = 1;
      }else if(down==1&&key==ENTER){
        int attack=player.attack(true)*skillCount;
        if(player.mp>=20){
          if(enemyGuard==true){
            player.mp-=20;
            sword.play();
            sword.rewind();
            thunder.play();
            thunder.rewind();
            if(attack/2-enemyData[i].guard<=0){
              message="ダメージを与えられない！";
              text(0,500,300);
            }else{
              enemyData[i].damage(attack/2,true);
              message=("剣に雷をまとわせて攻撃！"+(attack/2-enemyData[i].sGuard)+"のダメージを与えた!");              
              text(attack/2-enemyData[i].sGuard,500,300);
            }
          }else{
            player.mp-=20;
            sword.play();
            sword.rewind();
            thunder.play();
            thunder.rewind();
            if(attack-enemyData[i].guard<=0){
              message="ダメージを与えられない！";
              text(0,500,300);
            }else{
              enemyData[i].damage(attack,true);
              message=("剣に雷をまとわせて攻撃！"+(attack-enemyData[i].sGuard)+"のダメージを与えた!");              
              text(attack-enemyData[i].sGuard,500,300);
            }
          }
          if(enemyData[i].hp<0){
            enemyData[i].hp=0;
          }
        }else{
          message=("MPが足りない！");
        }
        if(skillCount==3){
          skillCount=1;
        }else{
          skillCount++;
        }
        
      }else if(down==3&&key==ENTER){
        if(player.mp>=15){
        int heal;
        int healMax;
        if(healCount==1){
          healMax=player.maxHp/5;
        }else if(healCount==2){
          healMax=player.maxHp/2;
        }else{
          healMax=player.maxHp;
        }   
        if(player.hp+healMax>player.maxHp){
          heal=player.maxHp-player.hp;
        }else{
          heal=healMax;
        }
        player.hp+=heal;
        message="HPが"+heal+"回復した";
        player.mp-=15;
        c = 3;
        }else{
          message="MPが足りない!";
        }
        if(healCount==3){
          healCount=1;
        }else{
          healCount++;
        }
      }
      if(key==ENTER){
        playerTurn=false;
      }
    }
    return c;
  }
  int enemyCommand(){
    int r=int(random(4));
    enemyGuard=false;
      if(r==0){
        int attack=enemyData[i].attack(false);
        if(playerGuard==true){
            if(attack/2-player.guard<=0){
              message2="ダメージを受けない！";
            }else{
              player.damage(attack/2,false);
              message2="敵の通常攻撃!"+(attack/2-player.guard)+"のダメージを受けた";
            }
        }else if(playerGuard==false){  
            if(attack-player.guard<=0){
              message2="ダメージを受けない！";
            }else{
              player.damage(attack,false); 
              message2="敵の通常攻撃!"+(attack-player.guard)+"のダメージを受けた";
            }
        }
        if(player.hp<0){
            player.hp=0;
          }
      }else if(r==1){
        message2="敵は防御した";
        enemyGuard=true;
      }else if(r==2){
        int attack=enemyData[i].attack(true);
        if(enemyData[i].mp>=20){
          if(playerGuard==true){
            enemyData[i].mp-=20;
              if(attack/2-player.sGuard<=0){
                message2="ダメージを受けない！";
              }else{
                player.damage(attack/2,true);
                if(i==0){
                  dageki.play();
                  dageki.rewind();
                  message2="勢いよく体当たりをしてきた！敵から"+(attack/2-player.sGuard)+"のダメージを受けた";
                }else if(i==1){
                  sword2.play();
                  sword2.rewind();
                  message2="剣での二回攻撃！敵から"+(attack/2-player.sGuard)+"のダメージを受けた";
                }else if(i==2){
                  fire.play();
                  fire.rewind();
                  message2="炎を吐いてきた！敵から"+(attack/2-player.sGuard)+"のダメージを受けた";
                }
              }
            }else if(playerGuard==false){
              enemyData[i].mp-=20;   
              if(attack-player.sGuard<=0){
                message2="ダメージを受けない！";
              }else{
                player.damage(attack,true);
                 if(i==0){
                   dageki.play();
                   dageki.rewind();
                   message2="勢いよく体当たりをしてきた！敵から"+(attack-player.sGuard)+"のダメージを受けた";
                }else if(i==1){
                  sword2.play();
                  sword2.rewind();
                  message2="剣での二回攻撃！敵から"+(attack-player.sGuard)+"のダメージを受けた";
                }else if(i==2){
                  fire.play();
                  fire.rewind();
                  message2="炎を吐いてきた！敵から"+(attack-player.sGuard)+"のダメージを受けた";
                }
              }
            }
        }else{
          message2="MPが足りない!";
        }
          if(player.hp<0){
            player.hp=0;
          }
      }else if(r==3){
        if(enemyData[i].mp>=20){
          int heal=0;
          if(enemyData[i].hp+enemyData[i].maxHp/3>enemyData[i].maxHp){
            heal=enemyData[i].maxHp-enemyData[i].hp;
          }else{
            heal=enemyData[i].maxHp/3;
          }
          message2="敵のHPが"+heal+"回復した";
          enemyData[i].hp+=heal;
        }else{
          message="MPが足りない";
        }
      }
      playerTurn=true;
      //println("enemy:"+r);
      return r;
  }
}
Enemy[] enemyData=new Enemy[3];
int[][] enemyBaseData={{350,50,50,75},{1000,200,120,160},{3000,1000,250,300}};
int i=0;
int roop=1;
int winCount=0;
int down=0;
int skillCount=1;
int healCount=1;
Player player;
Command command;
Game game;
TitleRuleEnd titleRuleEnd;
displayStatusUI Status;
String message = "";
String message2 = "";
boolean playerTurn=true;
boolean playerGuard=false;
boolean enemyGuard=false;
boolean Title=true;
boolean rule=false;
boolean gameOver = false;
//敵が倒れたかどうかの判定
class Game{
  boolean isDead(){  
    if(enemyData[i].hp<=0){
      return true;
    }else{
      return false;
    }
  }
}
//タイトル画面、ルール説明画面、エンディング画面の作成
class TitleRuleEnd{
  void title(){
    textSize(60);
    fill(0);
    String titleName = "勝ち抜きコマンドバトル";
    text(titleName,width/2-60*titleName.length()/2,200);
    textSize(40);
    if(dist(mouseX,mouseY,500,400)<100){
      fill(255,0,0);
    }else{
      noFill();
    }
    ellipse(500,400,200,200);
    fill(0);
    text("Start",450,400);
  }
  void rule(){
    textSize(60);
    String ruleTitle="ルール説明";
    text("ルール説明",width/2-60*ruleTitle.length()/2,50);
    textSize(20);
    text("・自分のHPが0になるまで続くエンドレスバトル",20,100);
    text("・PCの十字キーでコマンドを操作し、Enterで決定",20,140);
    text("・こうげき：MPを消費しない代わりに威力の低い攻撃",20,180);
    text("・スキル：MPを消費し、威力の高い攻撃",20,220);
    text("・ぼうぎょ：1ターンの間自身が受けるダメージを半減",20,260);
    text("・かいふく：MPを消費し、HPを回復する",20,300);
    text("HP:自身の体力 MP:スキルの発動や回復を行うための値",20,340);
    text("A:通常攻撃の攻撃力 G:通常攻撃の防御力",20,380);
    text("SA:スキルの攻撃力 SG:スキルの防御力",20,420);
    textSize(20);
    text("・スキルと回復は使うたびに3回まで強化され、最大まで強化されたら次使用時はリセット(プレイヤーのみ)",20,460);
    text("・敵は一定の戦闘回数でループして出現し、2回目以降の出現では一定量強化される",20,500);
    text("・敵のループに応じてプレイヤーのHPとMPも一定量回復する",20,540);
    text("・以上が確認出来たらスペースキーを押しゲームスタート",20,580);
  }
}
//ステータスや与ダメ、被ダメの表示や各種UIの設定
class displayStatusUI{
  void status(){
    text(message,250,500);
    text(message2,250,550);
    fill(255);
    rect(10,5,160,210);
    fill(0);
    text(player.name,10+160/2-30*player.name.length()/2,30);
    text("HP:"+player.hp, 30,60);
    text("MP:"+player.mp, 30, 90);
    text("A:"+player.attack, 40, 120);
    text("G:"+player.guard, 40, 150);
    text("SA:"+player.sAttack, 40, 180);
    text("SG:"+player.sGuard, 40, 210);
    fill(255);
    rect(830,5,160,210);
    fill(0);
    text(enemyData[i].name,830+160/2-30*enemyData[i].name.length()/2,30);
    text("HP:"+enemyData[i].hp, 850,60);
    text("MP:"+enemyData[i].mp, 850, 90);
    fill(255);
    rect(10,350,200,240);
    fill(0);
    text("こうげき",20,390);
    text("スキル",20,450);
    text("ぼうぎょ",20,510);
    text("かいふく",20,570);   
    text("連勝数："+winCount,200,100);
  }
  void UI(){
    if(keyPressed){
      delay(200);
      if(keyCode==DOWN){
        if(down==3){
          down=0;
        }else{
         down++;
        }
      }else if(keyCode==UP){
        if(down==0){
          down=3;
        }else{
          down--;
        }
      }
    }
    if(down==0){
      triangle(150,380,165,360,165,400);
    }else if(down==1){
      triangle(150,440,165,420,165,460);
    }else if(down==2){
      triangle(150,500,165,480,165,520);
    }else{
      triangle(150,560,165,540,165,580);
    }
    noFill();
    rect(400,150,200,10);
    fill(0);
    rect(400,150,float(enemyData[i].hp)/float(enemyData[i].maxHp)*200,10);
    if(30 <mouseX && mouseX<150 && 30<mouseY && mouseY <60){
      text("体力",300,40);
    }
    if(30 <mouseX && mouseX<150 && 61<mouseY && mouseY <90){
      text("精神力",300,40);
    }
    if(40 <mouseX && mouseX<150 && 91<mouseY && mouseY <120){
      text("攻撃力",300,40);
    }
    if(40 <mouseX && mouseX<150 && 121<mouseY && mouseY <150){
      text("防御力",300,40);
    }
    if(40 <mouseX && mouseX<150 && 151<mouseY && mouseY <180){
      text("スキルの攻撃力",300,40);
    }
    if(40 <mouseX && mouseX<150 && 181<mouseY && mouseY <310){
      text("スキルの防御力",300,40);
    }
    if(20 <mouseX && mouseX<140 && 360<mouseY && mouseY <400){
      text("MPを消費しない代わりに威力の低い攻撃",250,40);
    }
    if(20 <mouseX && mouseX<150 && 401<mouseY && mouseY <460){
      text("MPを消費し、威力の高い攻撃",300,40);
    }    
    if(20 <mouseX && mouseX<150 && 461<mouseY && mouseY <520){
      text("1ターンの間自身が受けるダメージを半減",250,40);
    }
    if(20 <mouseX && mouseX<150 && 521<mouseY && mouseY <580){
      text("MPを消費し、HPを回復する",300,40);
    }
  }
}
//攻撃音
AudioPlayer sword;
AudioPlayer dageki;
AudioPlayer thunder;
AudioPlayer sword2;
AudioPlayer fire;
void setup(){
  size(1000,600);
  slime = loadImage("slime.png");
  goblin= loadImage("goblin.png");
  dragon= loadImage("dragon.png");
  sword = minim.loadFile("swordSound.mp3");
  dageki = minim.loadFile("dagekiSound.mp3");
  sword2 = minim.loadFile("doublesword.mp3");
  fire = minim.loadFile("dragon.mp3");
  thunder = minim.loadFile("thunderSound.mp3");
  enemyData[0]=new Enemy(350,350,70,70,50,40,75,35,"スライム",slime);
  enemyData[1]=new Enemy(1000,1000,200,200,120,100,160,80,"ゴブリン",goblin);
  enemyData[2]=new Enemy(3000,3000,1000,1000,250,130,300,100,"ドラゴン",dragon);
  command=new Command();
  game=new Game();
  titleRuleEnd=new TitleRuleEnd();
  Status=new displayStatusUI();
  player=new Player(1000,1000,300,300,300,20,400,20,"あなた");
  PFont font= createFont("Meiryo", 50);
  textFont(font);
}
void draw(){
  textSize(30);
  background(255);
  if(Title==true&&gameOver == false){
    titleRuleEnd.title();
    if(mousePressed&&dist(mouseX,mouseY,500,400)<100){
      Title=false;
      rule=true;
    }
  }else if(rule==true){
    titleRuleEnd.rule();
    if(keyPressed&&key==' '){
      rule=false;
      message=enemyData[i].name+"があらわれた！";
    }
  }else if(Title==false&&rule==false&&gameOver == false){
   if(enemyData[i].hp<=0){
       message2=enemyData[i].name+"を倒した！";
    if(keyPressed&&key==ENTER){
      winCount++;
      if(i==2){
       i=0;
       roop+=1;
       enemyData[2].maxHp*=1.5;
       enemyData[2].attack*=1.2;
       enemyData[2].sAttack*=1.2;
       enemyData[2].hp=enemyData[2].maxHp;
       int heal=(player.maxHp-player.hp)/2;
       int mpHeal=(player.maxMp-player.mp)/2;
       player.hp+=heal;
       player.mp+=mpHeal;
      }else{
       i+=1;
       enemyData[i-1].maxHp*=1.5;       
       enemyData[i-1].attack*=1.2;
       enemyData[i-1].sAttack*=1.2;
       enemyData[i-1].hp=enemyData[i-1].maxHp;
      }
      message=enemyData[i].name+"があらわれた！";
      message2="";
      playerTurn=true;
    }
   }else{
     image(enemyData[i].ilust,350,200,300,250);
     if(playerTurn==true){
      command.playerCommand(); 
     }else{
      delay(1000);
      command.enemyCommand();    
     }
   }
    Status.status();
    Status.UI();
   }
   
  if(player.hp<=0){
    //battle.close();
    gameOver = true;
    background(255);
    textSize(60);
    text("GAME OVER",300,200);
    textSize(30);
    String winCountMessage = "連勝数:"+winCount;
    text(winCountMessage,width/2-60*winCountMessage.length()/2,400);
    text("スペースキーでタイトルに戻る",300,500);
    if(keyPressed&&key==' '){
      Title=true;
      gameOver = false;
      player.hp=player.maxHp;
      for(int i=0;i<3;i++){
        enemyData[i].maxHp=enemyBaseData[i][0];
        enemyData[i].maxMp=enemyBaseData[i][1];
        player.hp=player.maxHp;
        player.mp=player.maxMp;
        enemyData[i].attack=enemyBaseData[i][2];
        enemyData[i].sAttack=enemyBaseData[i][3];
        enemyData[i].hp=enemyData[i].maxHp;
        enemyData[i].mp=enemyData[i].maxMp;
      }
      roop=1;
      message=" ";
      message2=" ";
      i=0;
      winCount=0;
      skillCount=1;
      healCount=1;
    }
  }
}
