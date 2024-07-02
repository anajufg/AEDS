class No {
  int valor;
  No esq;
  No dir;

  No(int valor) {
    this.valor = valor;
    esq = null;
    dir = null;
  }
}

class ArvoreBinaria {
  No raiz;

  ArvoreBinaria() {
    raiz = null;
  }

  void insere(int valor) {
    raiz = insereRec(raiz, valor);
  }

  private No insereRec(No raiz, int valor) {
    /*
    FUNÇÃO Inserir(raiz, valor)
        SE raiz É nulo ENTÃO
            raiz ← NOVO NÓ(valor)
            RETORNA raiz
        FIM SE
    
        SE valor < raiz.valor ENTÃO
            SE raiz.esquerda É nulo ENTÃO
                raiz.esquerda ← NOVO NÓ(valor)
            SENÃO
                Inserir(raiz.esquerda, valor)
            FIM SE
        SENÃO SE valor > raiz.valor ENTÃO
            SE raiz.direita É nulo ENTÃO
                raiz.direita ← NOVO NÓ(valor)
            SENÃO
                Inserir(raiz.direita, valor)
            FIM SE
        FIM SE
    
        RETORNA raiz
    FIM FUNÇÃO

    */
    
    if (raiz == null) {
      raiz = new No(valor);
      return raiz;
    }
    
    if (valor < raiz.valor) {
      if (raiz.esq == null) {
        raiz.esq = new No(valor); 
      } else {
         insereRec(raiz.esq, valor);
      }
    } else if (valor > raiz.valor) {
      if (raiz.dir == null) {
        raiz.dir = new No(valor);
      } else {
        insereRec(raiz.dir, valor);
      }
    }
    
    return raiz;
  }
  
  

  void mostrar() {
    mostrarArvore(raiz, width / 2, 40, width / 4);
  }

  private void mostrarArvore(No raiz, float x, float y, float xOffset) {
  
    if (raiz != null) {
      

      if (raiz.esq != null) {
        line(x, y, x - xOffset, y + 60);
        mostrarArvore(raiz.esq, x - xOffset, y + 60, xOffset / 2);
      }

      if (raiz.dir != null) {
        line(x, y, x + xOffset, y + 60);
        mostrarArvore(raiz.dir, x + xOffset, y + 60, xOffset / 2);
      }
      
      stroke(#81542F);
      fill(#AF7B50);
      ellipse(x, y, 30, 30);
      fill(0);
      textAlign(CENTER, CENTER);
      text(raiz.valor, x, y);
    }
  }
  
  void PreOrdem(No raiz) {
    if (raiz == null) {
      return;
    }
    if (raiz != null) {
      print(raiz.valor + "\n");
      PreOrdem(raiz.esq);
      PreOrdem(raiz.dir);

    }
  }
}



ArvoreBinaria arv = new ArvoreBinaria();

void setup(){
   size(600, 600); 
}

void draw(){
  background(#F7D7AF);
  
  arv.mostrar();
  
}

void mouseClicked() {
  arv.insere((int)random(1000)); 
  arv.PreOrdem(arv.raiz);
  print("\n");
}
